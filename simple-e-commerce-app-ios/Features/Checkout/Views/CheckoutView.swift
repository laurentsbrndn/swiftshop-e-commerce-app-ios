////
////  CheckoutView.swift
////  simple-e-commerce-app-ios
////
////  Created by Laurentius Brandon Vikario on 09/09/26.
////

import SwiftUI

struct CheckoutView: View {
    @EnvironmentObject private var sessionManager: SessionManager
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = CheckoutViewModel()
    
    let itemsToCheckout: [CheckoutCartItem]
    
    var body: some View {
        Form {
            Section(header: Text("Shipping Address")) {
                if let selected = viewModel.selectedAddress {
                    NavigationLink {
                        AddressSelectionView(
                            addresses: viewModel.availableAddresses,
                            selectedAddress: $viewModel.selectedAddress
                        )
                    } label: {
                        VStack(alignment: .leading, spacing: 6) {
                            Text(selected.label)
                                .font(.caption).bold()
                                .foregroundStyle(.blue)
                            
                            Text(selected.recipientName)
                                .font(.headline)
                            
                            Text(selected.recipientPhone)
                                .font(.subheadline)
                            
                            Text("\(selected.addressLine), \(selected.city) \(selected.postalCode)")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        .padding(.vertical, 4)
                    }
                } else {
                    Text("No address found. Please add an address in your Profile.")
                        .foregroundStyle(.red)
                }
            }
            
            Section(header: Text("Order Summary")) {
                ForEach(viewModel.cartItems) { item in
                    HStack(alignment: .top) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(item.productName)
                                .font(.body)
                                .fontWeight(.medium)
                            
                            Text("\(item.quantity) x Rp \(item.unitPrice, specifier: "%.0f")")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        
                        Spacer()
                        
                        Text("Rp \(item.subtotalAmount, specifier: "%.0f")")
                            .font(.body)
                            .fontWeight(.semibold)
                    }
                    .padding(.vertical, 4)
                }
            }
            
            Section(header: Text("Payment Breakdown")) {
                HStack {
                    Text("Total Items")
                        .foregroundStyle(.secondary)
                    Spacer()
                    Text("\(viewModel.totalQuantity) Items")
                }
                
                HStack {
                    Text("Grand Total")
                        .font(.headline)
                    Spacer()
                    Text("Rp \(viewModel.grandTotal, specifier: "%.0f")")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundStyle(.blue)
                }
            }
            
            Section(
                header: Text("Payment"),
                footer: Text("To create a successful payment, enter the exact Grand Total amount.")
            ) {
                TextField("Enter exact amount", text: $viewModel.manualPaymentInput)
                    .keyboardType(.decimalPad)
            }
            
            Section {
                Button {
                    Task {
                        await viewModel.processCheckout(token: sessionManager.token)
                    }
                } label: {
                    if viewModel.isLoading {
                        ProgressView()
                            .frame(maxWidth: .infinity, alignment: .center)
                    } else {
                        Text("Pay")
                            .font(.headline)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
                .disabled(viewModel.isLoading || viewModel.selectedAddress == nil || viewModel.manualPaymentInput.isEmpty)
                .listRowBackground(
                    (viewModel.isLoading || viewModel.selectedAddress == nil || viewModel.manualPaymentInput.isEmpty) ? Color.gray.opacity(0.3) : Color.blue
                )
                .foregroundStyle(.white)
            }
        }
        .navigationTitle("Checkout")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            Task {
                await viewModel.loadInitialData(token: sessionManager.token, items: itemsToCheckout)
            }
        }
        .alert("Payment Failed", isPresented: .constant(viewModel.errorMessage != nil)) {
            Button("OK", role: .cancel) {
                viewModel.errorMessage = nil
            }
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
        .sheet(isPresented: $viewModel.isPaymentSuccessful) {
            PaymentSuccessView {
                viewModel.isPaymentSuccessful = false
                dismiss()
            }
            .interactiveDismissDisabled()
            .presentationDetents([.large])
        }
    }
}

struct PaymentSuccessView: View {
    let onContinueShopping: () -> Void
    
    var body: some View {
        VStack(spacing: 28) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(Color.green.opacity(0.12))
                    .frame(width: 120, height: 120)
                
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 80))
                    .foregroundStyle(.green)
            }
            
            VStack(spacing: 8) {
                Text("Order Placed Successfully!")
                    .font(.title2)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                
                Text("Your payment has been verified. We are processing your order right away.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
            }
            
            Spacer()
            
            Button(action: onContinueShopping) {
                Text("Continue Shopping")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .padding(.horizontal, 24)
            .padding(.bottom, 24)
        }
    }
}
