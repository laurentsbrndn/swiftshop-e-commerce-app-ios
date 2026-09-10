//
//  CartView.swift
//  simple-e-commerce-app-ios
//
//  Created by Laurentius Brandon Vikario on 07/09/26.
//


import SwiftUI

struct CartView: View {
    @EnvironmentObject var viewModel: CartViewModel
    @EnvironmentObject var sessionManager: SessionManager
    @State private var searchText = ""
    
    var filteredItems: [CartItem] {
        guard let items = viewModel.cart?.items else { return [] }
        if searchText.isEmpty { return items }
        return items.filter { $0.productName.localizedCaseInsensitiveContains(searchText) }
    }
    
    var body: some View {
        Group {
            if viewModel.isLoading && viewModel.cart == nil {
                ProgressView()
            } else if filteredItems.isEmpty {
                ContentUnavailableView(
                    "Your Cart is Empty",
                    systemImage: "cart",
                    description: Text(searchText.isEmpty ? "Start exploring our catalog to add items." : "No matching items found.")
                )
            } else {
                List {
                    ForEach(filteredItems) { item in
                        CartItemRow(item: item)
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                Button(role: .destructive) {
                                    Task {
                                        await viewModel.deleteItem(
                                            itemID: item.id,
                                            customerID: sessionManager.customerID ?? "",
                                            token: sessionManager.token
                                        )
                                    }
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                    }
                }
                .listStyle(.plain)
                .refreshable {
                    await viewModel.fetchCart(customerID: sessionManager.customerID ?? "", token: sessionManager.token)
                }
                .safeAreaInset(edge: .bottom) {
                    if !viewModel.selectedItemIDs.isEmpty {
                        VStack(spacing: 0) {
                            Divider()
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("Total")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                    Text(viewModel.totalSelectedPrice, format: .currency(code: "IDR"))
                                        .font(.title3)
                                        .fontWeight(.bold)
                                }
                                Spacer()
                                NavigationLink(destination: CheckoutView(itemsToCheckout: getSelectedCheckoutItems())) {
                                    Text("Checkout (\(viewModel.selectedItemIDs.count))")
                                        .font(.headline)
                                        .padding(.horizontal, 24)
                                        .padding(.vertical, 14)
                                        .background(Color.accentColor)
                                        .foregroundColor(.white)
                                        .cornerRadius(12)
                                }
                            }
                            .padding()
                            .background(.regularMaterial)
                        }
                    }
                }
            }
        }
        .navigationTitle("Shopping Cart")
        .searchable(text: $searchText, prompt: "Search in cart...")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Button("Select All") {
                        if let items = viewModel.cart?.items {
                            viewModel.selectedItemIDs = Set(items.map { $0.id })
                        }
                    }
                    Button("Deselect All") {
                        viewModel.selectedItemIDs.removeAll()
                    }
                } label: {
                    Image(systemName: "ellipsis")
                }
            }
        }
        .task {
            if viewModel.cart == nil {
                await viewModel.fetchCart(
                    customerID: sessionManager.customerID ?? "",
                    token: sessionManager.token
                )
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .checkoutDidSucceed)) { _ in
            Task {
                await viewModel.fetchCart(
                    customerID: sessionManager.customerID ?? "",
                    token: sessionManager.token
                )
            }
        }
    }
    private func getSelectedCheckoutItems() -> [CheckoutCartItem] {
        guard let items = viewModel.cart?.items else { return [] }
        
        let selectedItems = items.filter { viewModel.selectedItemIDs.contains($0.id) }
        
        return selectedItems.map { item in
            CheckoutCartItem(
                id: UUID(uuidString: item.id) ?? UUID(),
                productID: UUID(uuidString: item.productId) ?? UUID(),
                sku: "SKU-\(item.productId.prefix(6))",               
                productName: item.productName,
                productImageUrl: item.productImageUrl,
                unitPrice: item.unitPrice,
                quantity: item.quantity
            )
        }
    }
    
}

struct CartItemRow: View {
    let item: CartItem
    @EnvironmentObject var viewModel: CartViewModel
    @EnvironmentObject var sessionManager: SessionManager
    
    @State private var localQuantity: Int
    
    init(item: CartItem) {
        self.item = item
        _localQuantity = State(initialValue: item.quantity)
    }
    
    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            // Checkbox
            Button(action: { viewModel.toggleSelection(for: item.id) }) {
                Image(systemName: viewModel.selectedItemIDs.contains(item.id) ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
                    .foregroundColor(viewModel.selectedItemIDs.contains(item.id) ? .accentColor : Color(.tertiaryLabel))
            }
            .buttonStyle(.plain)
            
            // Image
            AsyncImage(url: URL(string: item.productImageUrl ?? "")) { phase in
                if let image = phase.image {
                    image.resizable().scaledToFill()
                } else {
                    Color.secondary.opacity(0.1)
                }
            }
            .frame(width: 64, height: 64)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            
            // Content
            VStack(alignment: .leading, spacing: 4) {
                Text(item.productName)
                    .font(.headline)
                    .lineLimit(2)
                
                Text(item.unitPrice, format: .currency(code: "IDR"))
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                QuantityInputView(quantity: $localQuantity, maxStock: item.availableStock)
                    .onChange(of: localQuantity) { newValue in
                        Task {
                            await viewModel.updateQuantity(
                                itemID: item.id,
                                newQuantity: newValue,
                                customerID: sessionManager.customerID ?? "",
                                token: sessionManager.token
                            )
                        }
                    }
            }
        }
        .padding(.vertical, 4)
        .opacity(item.availableStock == 0 ? 0.5 : 1.0)
    }
}
