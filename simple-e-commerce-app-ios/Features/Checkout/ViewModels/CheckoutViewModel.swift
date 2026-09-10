//
//  CheckoutViewModel.swift
//  simple-e-commerce-app-ios
//
//  Created by Laurentius Brandon Vikario on 09/09/26.
//


import SwiftUI
internal import Combine

@MainActor
class CheckoutViewModel: ObservableObject {
    @Published var cartItems: [CheckoutCartItem] = []
    
    @Published var availableAddresses: [CustomerAddressResponse] = []
    @Published var selectedAddress: CustomerAddressResponse?
    
    @Published var manualPaymentInput: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var isPaymentSuccessful: Bool = false
    
    private let repository: CheckoutRepositoryProtocol
    
    init(repository: CheckoutRepositoryProtocol = CheckoutRepository()) {
        self.repository = repository
    }
    
    var totalQuantity: Int {
        cartItems.reduce(0) { $0 + $1.quantity }
    }
    
    var grandTotal: Double {
        cartItems.reduce(0) { $0 + $1.subtotalAmount }
    }
    
    
    func loadInitialData(token: String, items: [CheckoutCartItem]) async {
        self.cartItems = items
        
        guard availableAddresses.isEmpty else { return }
        
        self.isLoading = true
        do {
            let addresses = try await repository.fetchAddresses(token: token)
            self.availableAddresses = addresses
            
            if self.selectedAddress == nil {
                self.selectedAddress = addresses.first(where: { $0.isDefault }) ?? addresses.first
            }
        } catch {
            self.errorMessage = "Failed to load shipping addresses."
        }
        self.isLoading = false
    }
    
    func processCheckout(token: String) async {
        guard let address = selectedAddress else {
            errorMessage = "Please select a shipping address."
            return
        }
        
        let typedAmount = Double(manualPaymentInput.trimmingCharacters(in: .whitespaces)) ?? 0.0
        guard typedAmount == grandTotal else {
            errorMessage = "Payment declined. The amount entered (Rp \(typedAmount)) does not match the Grand Total (Rp \(grandTotal))."
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            let orderItems = cartItems.map { item in
                CreateOrderItemRequestDTO(
                    productID: item.productID, sku: item.sku, productName: item.productName,
                    productImageUrl: item.productImageUrl, unitPrice: item.unitPrice,
                    quantity: item.quantity, subtotalAmount: item.subtotalAmount
                )
            }
            
            let orderRequest = CreateOrderRequestDTO(
                subtotalAmount: grandTotal, totalAmount: grandTotal,
                recipientName: address.recipientName, recipientPhone: address.recipientPhone,
                shippingAddressLine: address.addressLine, shippingCity: address.city,
                shippingState: address.state, shippingPostalCode: address.postalCode,
                shippingCountryCode: address.countryCode, notes: nil, items: orderItems
            )
            
            let orderResponse = try await repository.createOrder(request: orderRequest, token: token)
            
            let paymentRequest = PaymentRequestDTO(orderID: orderResponse.id, amount: grandTotal)
            _ = try await repository.processPayment(request: paymentRequest, token: token)
            
            isPaymentSuccessful = true
            NotificationCenter.default.post(name: .checkoutDidSucceed, object: nil)
            
        } catch {
            errorMessage = "Transaction failed. Please try again."
        }
        
        isLoading = false
    }
}
