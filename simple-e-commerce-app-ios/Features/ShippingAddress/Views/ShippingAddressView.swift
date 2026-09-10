////
////  ShippingAddressView.swift
////  simple-e-commerce-app-ios
////
////  Created by Laurentius Brandon Vikario on 08/09/26.
////

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

import SwiftUI

struct ShippingAddressView: View {
    @EnvironmentObject private var sessionManager: SessionManager
    @StateObject private var viewModel = ShippingAddressViewModel()
    
    @State private var showingForm = false
    @State private var addressToEdit: CustomerAddressResponse?
    
    var body: some View {
        List {
            if viewModel.isLoading && viewModel.addresses.isEmpty {
                ProgressView()
                    .frame(maxWidth: .infinity, alignment: .center)
            } else if viewModel.addresses.isEmpty {
                ContentUnavailableView(
                    "No Address Found",
                    systemImage: "shippingbox",
                    description: Text("You haven't added any shipping addresses yet.")
                )
            } else {
                ForEach(viewModel.addresses) { address in
                    AddressRow(address: address) {
                        addressToEdit = address
                        showingForm = true
                    }
                }
                .onDelete(perform: delete) 
            }
        }
        .navigationTitle("Shipping Addresses")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    addressToEdit = nil
                    showingForm = true
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showingForm) {
            NavigationStack {
                ShippingAddressFormView(
                    viewModel: viewModel,
                    editingAddress: addressToEdit,
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
    
    private func delete(at offsets: IndexSet) {
        guard let index = offsets.first else { return }
        let address = viewModel.addresses[index]
        Task {
            _ = await viewModel.deleteAddress(token: sessionManager.token, id: address.id)
        }
    }
}
