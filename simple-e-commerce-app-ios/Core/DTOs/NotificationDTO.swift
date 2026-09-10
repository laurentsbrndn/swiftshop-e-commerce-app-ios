//
//  NotificationDTO.swift
//  simple-e-commerce-app-ios
//
//  Created by Laurentius Brandon Vikario on 09/09/26.
//

import Foundation

struct PagedResponse<T: Codable>: Codable {
    let items: [T]
    let metadata: PageMetadata
}

struct NotificationResponse: Codable, Identifiable {
    let id: UUID
    let orderID: UUID?
    let type: String
    let title: String
    let message: String
    let status: String
    let createdAt: String?
    let readAt: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case orderID = "orderID"
        case type, title, message, status, createdAt, readAt
    }
    
    var parsedDate: Date {
        guard let dateString = createdAt else { return Date() }
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter.date(from: dateString) ?? ISO8601DateFormatter().date(from: dateString) ?? Date()
    }
}
