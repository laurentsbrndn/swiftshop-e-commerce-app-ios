////
////  ShippingAddressView.swift
////  simple-e-commerce-app-ios
////
////  Created by Laurentius Brandon Vikario on 08/09/26.
////

import SwiftUI

struct AddressRow: View {
    let address: CustomerAddressResponse
    let onEdit: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(address.label)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.secondary)
                
                Spacer()
                
                if address.isDefault {
                    Label("Default", systemImage: "checkmark.circle.fill")
                        .font(.caption)
                        .foregroundStyle(Color.accentColor)
                }
            }
            
            Text(address.recipientName)
                .font(.headline)
            
            Text(address.recipientPhone)
                .font(.subheadline)
            
            Text("\(address.addressLine), \(address.city), \(address.state) \(address.postalCode)")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .lineLimit(2)
            
            Button("Edit Address") {
                onEdit()
            }
            .font(.footnote)
            .fontWeight(.medium)
            .padding(.top, 4)
        }
        .padding(.vertical, 4)
    }
}

struct ShippingAddressView: View {
    @EnvironmentObject private var sessionManager: SessionManager
    @StateObject private var viewModel = ShippingAddressViewModel()
    
    @State private var addressToEdit: CustomerAddressResponse?
    @State private var showingNewAddressForm = false
    
    var body: some View {
        Group {
            if viewModel.isLoading && viewModel.addresses.isEmpty {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if viewModel.addresses.isEmpty {
                ContentUnavailableView(
                    "No Address Found",
                    systemImage: "shippingbox",
                    description: Text("You haven't added any shipping addresses yet.")
                )
            } else {
                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(viewModel.addresses) { address in
                            AddressRow(address: address) {
                                addressToEdit = address
                            }
                            .padding(16)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color(uiColor: .secondarySystemGroupedBackground))
                            )
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                }
                .background(Color(uiColor: .systemGroupedBackground))
            }
        }
        .navigationTitle("Shipping Addresses")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    showingNewAddressForm = true
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(item: $addressToEdit) { address in
            NavigationStack {
                ShippingAddressFormView(
                    viewModel: viewModel,
                    editingAddress: address,
                    token: sessionManager.token
                )
            }
        }
        .sheet(isPresented: $showingNewAddressForm) {
            NavigationStack {
                ShippingAddressFormView(
                    viewModel: viewModel,
                    editingAddress: nil,
                    token: sessionManager.token
                )
            }
        }
        .alert("Error", isPresented: $viewModel.showError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(viewModel.errorMessage)
        }
        .onAppear {
            Task {
                await viewModel.fetchAddresses(token: sessionManager.token)
            }
        }
    }
}
