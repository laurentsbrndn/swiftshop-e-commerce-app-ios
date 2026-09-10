//
//  TransactionHistoryView.swift
//  simple-e-commerce-app-ios
//
//  Created by Laurentius Brandon Vikario on 06/09/26.
//

import SwiftUI

struct TransactionHistoryView: View {
    @EnvironmentObject private var sessionManager: SessionManager
    @StateObject private var viewModel = TransactionHistoryViewModel()
    
    @State private var searchText = ""
    @State private var showFilterSheet = false
    
    var body: some View {
        Group {
            if viewModel.isLoading && viewModel.orders.isEmpty {
                ProgressView("Loading transactions...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let errorMessage = viewModel.errorMessage {
                ErrorStateView(message: errorMessage) {
                    Task { await loadOrders() }
                }
            } else if viewModel.filteredAndSortedOrders(searchText: searchText).isEmpty {
                ContentUnavailableView(
                    searchText.isEmpty && viewModel.selectedStatusFilter == nil ? "No Transactions" : "No Matches Found",
                    systemImage: "doc.text.magnifyingglass",
                    description: Text(searchText.isEmpty ? "Your purchase history will appear here." : "Try adjusting your search or filter.")
                )
            } else {
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(viewModel.filteredAndSortedOrders(searchText: searchText)) { order in
                            OrderHistoryRowView(order: order)
                                .padding(16)
                                .background(Color(.secondarySystemGroupedBackground))
                                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                }
                .background(Color(.systemGroupedBackground))
                .refreshable {
                    await loadOrders()
                }
            }
        }
        .navigationTitle("Transaction History")
        .searchable(text: $searchText, prompt: "Search transaction or product...")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { showFilterSheet = true }) {
                    Image(systemName: "ellipsis")
                        .overlay(alignment: .topTrailing) {
                            if viewModel.selectedStatusFilter != nil || viewModel.startDate != nil {
                                Circle()
                                    .fill(Color.red)
                                    .frame(width: 8, height: 8)
                                    .offset(x: 2, y: -2)
                            }
                        }
                }
            }
        }
        .sheet(isPresented: $showFilterSheet) {
            NavigationStack {
                TransactionFilterSheet(viewModel: viewModel)
            }
            .presentationDetents([.large])
        }
        .task {
            if viewModel.orders.isEmpty {
                await loadOrders()
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .checkoutDidSucceed)) { _ in
            Task {
                await loadOrders()
            }
        }
    }
    
    private func loadOrders() async {
        await viewModel.fetchOrders(token: sessionManager.token)
    }
}

struct OrderHistoryRowView: View {
    let order: OrderHistoryResponse
    
    private var statusColor: Color {
        switch order.status.uppercased() {
        case "COMPLETED", "PAID": return .green
        case "PENDING": return .orange
        case "CANCELLED", "FAILED": return .red
        default: return .blue
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(order.orderNumber)
                        .font(.headline)
                    Text(order.parsedDate, format: .dateTime.day().month().year().hour().minute())
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                Text(order.status.capitalized)
                    .font(.caption.weight(.bold))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(statusColor.opacity(0.12))
                    .foregroundStyle(statusColor)
                    .clipShape(Capsule())
            }
            
            Divider()
            
            VStack(alignment: .leading, spacing: 12) {
                ForEach(order.items) { item in
                    HStack(alignment: .center, spacing: 12) {
                        AsyncImage(url: URL(string: item.productImageUrl ?? "")) { phase in
                            if let image = phase.image {
                                image.resizable().scaledToFill()
                            } else {
                                Color.secondary.opacity(0.1)
                            }
                        }
                        .frame(width: 56, height: 56)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.secondary.opacity(0.2), lineWidth: 1)
                        )
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(item.productName)
                                .font(.subheadline.weight(.medium))
                                .lineLimit(2)
                            
                            Text("\(item.quantity) x \(item.unitPrice, format: .currency(code: order.currency))")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
            
            Divider()
            
            HStack {
                Text("Grand Total")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Spacer()
                Text(order.totalAmount, format: .currency(code: order.currency))
                    .font(.headline)
                    .foregroundStyle(.primary)
            }
        }
    }
}

struct TransactionFilterSheet: View {
    @ObservedObject var viewModel: TransactionHistoryViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var enableDateFilter: Bool
    
    let statuses = ["All", "Pending", "Paid", "Completed", "Cancelled"]
    
    init(viewModel: TransactionHistoryViewModel) {
        self.viewModel = viewModel
        _enableDateFilter = State(initialValue: viewModel.startDate != nil)
    }
    
    var body: some View {
        Form {
            Section(header: Text("Sort By")) {
                Picker("Sorting", selection: $viewModel.sortOption) {
                    ForEach(TransactionHistoryViewModel.SortOption.allCases) { option in
                        Text(option.rawValue).tag(option)
                    }
                }
                .pickerStyle(.menu)
            }
            
            Section(header: Text("Transaction Status")) {
                Picker("Status", selection: Binding(
                    get: { viewModel.selectedStatusFilter?.capitalized ?? "All" },
                    set: { newValue in
                        viewModel.selectedStatusFilter = newValue == "All" ? nil : newValue.lowercased()
                    }
                )) {
                    ForEach(statuses, id: \.self) { status in
                        Text(status).tag(status)
                    }
                }
                .pickerStyle(.menu)
            }
            
            Section(header: Text("Date Range")) {
                Toggle("Use Date Filter", isOn: $enableDateFilter)
                    .onChange(of: enableDateFilter) { isOn in
                        if !isOn {
                            viewModel.startDate = nil
                            viewModel.endDate = nil
                        } else {
                            viewModel.startDate = Calendar.current.date(byAdding: .month, value: -1, to: Date())
                            viewModel.endDate = Date()
                        }
                    }
                
                if enableDateFilter {
                    DatePicker(
                        "From",
                        selection: Binding(
                            get: { viewModel.startDate ?? Date() },
                            set: { viewModel.startDate = $0 }
                        ),
                        in: ...Date(),
                        displayedComponents: .date
                    )
                    
                    DatePicker(
                        "To",
                        selection: Binding(
                            get: { viewModel.endDate ?? Date() },
                            set: { viewModel.endDate = $0 }
                        ),
                        in: (viewModel.startDate ?? Date())...Date(),
                        displayedComponents: .date
                    )
                }
            }
            
            Section {
                Button("Reset All Filter", role: .destructive) {
                    viewModel.resetFilters()
                    enableDateFilter = false
                }
                .frame(maxWidth: .infinity, alignment: .center)
            }
        }
        .navigationTitle("Filter & Sort")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Close") { dismiss() }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button("Apply") { dismiss() }
                    .bold()
            }
        }
    }
}
