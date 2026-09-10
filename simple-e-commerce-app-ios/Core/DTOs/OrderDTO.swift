//
//  OrderDTO.swift
//  simple-e-commerce-app-ios
//
//  Created by Laurentius Brandon Vikario on 03/09/26.
//

import Foundation

struct PageMetadata: Codable {
    let per: Int
    let total: Int
    let page: Int
}

struct OrderHistoryResponse: Codable, Identifiable {
    let id: UUID
    let orderNumber: String
    let status: String
    let currency: String
    let totalAmount: Double
    let createdAt: String?
    let items: [OrderItemResponse]
    
    var parsedDate: Date {
        guard let dateString = createdAt else { return Date() }
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter.date(from: dateString) ?? ISO8601DateFormatter().date(from: dateString) ?? Date()
    }
}

struct OrderItemResponse: Codable, Identifiable {
    let id: UUID
    let productID: UUID
    let sku: String
    let productName: String
    let productImageUrl: String?
    let unitPrice: Double
    let quantity: Int
    let subtotalAmount: Double
}
