//
//  CheckoutDTO.swift
//  simple-e-commerce-app-ios
//
//  Created by Laurentius Brandon Vikario on 09/09/26.
//

import Foundation

struct CheckoutCartItem: Identifiable, Hashable {
    let id: UUID
    let productID: UUID
    let sku: String
    let productName: String
    let productImageUrl: String?
    let unitPrice: Double
    let quantity: Int
    
    var subtotalAmount: Double {
        return unitPrice * Double(quantity)
    }
}

struct CreateOrderRequestDTO: Codable {
    let currency: String = "IDR"
    let subtotalAmount: Double
    let discountAmount: Double? = 0
    let shippingAmount: Double? = 0
    let taxAmount: Double? = 0
    let totalAmount: Double
    let recipientName: String
    let recipientPhone: String
    let shippingAddressLine: String
    let shippingCity: String
    let shippingState: String
    let shippingPostalCode: String
    let shippingCountryCode: String
    let notes: String?
    let items: [CreateOrderItemRequestDTO]
}

struct CreateOrderItemRequestDTO: Codable {
    let productID: UUID
    let sku: String
    let productName: String
    let productImageUrl: String?
    let unitPrice: Double
    let quantity: Int
    let subtotalAmount: Double
    let currency: String = "IDR"
}

struct OrderResponseDTO: Codable {
    let id: UUID
    let orderNumber: String
}

struct PaymentRequestDTO: Codable {
    let orderID: UUID
    let amount: Double
    let currency: String
    let paymentMethod: String
    
    init(orderID: UUID, amount: Double, currency: String = "IDR", paymentMethod: String = "MANUAL_TRANSFER") {
        self.orderID = orderID
        self.amount = amount
        self.currency = currency
        self.paymentMethod = paymentMethod
    }
}
