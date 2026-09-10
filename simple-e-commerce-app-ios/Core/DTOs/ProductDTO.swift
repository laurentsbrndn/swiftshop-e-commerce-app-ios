//
//  ProductDTO.swift
//  simple-e-commerce-app-ios
//
//  Created by Laurentius Brandon Vikario on 03/09/26.
//

import Foundation

struct Product: Codable, Identifiable {
    let id: String
    let sku: String
    let name: String
    let slug: String
    let price: Double
    let currency: String
    let status: String
    let isFeatured: Bool

    let description: String?
    let shortDescription: String?
    let weightGrams: Int?

    let category: Category?
    let images: [ProductImage]
    let inventory: Inventory?

    enum CodingKeys: String, CodingKey {
        case id
        case sku
        case name
        case slug
        case description
        case shortDescription
        case price
        case currency
        case status
        case isFeatured
        case weightGrams
        case category
        case images
        case inventory
    }
}

struct Category: Codable, Identifiable {
    let id: String
    let name: String
}

struct ProductImage: Codable, Identifiable {
    let id: String
    let imageURL: String
    let altText: String?

    enum CodingKeys: String, CodingKey {
        case id
        case imageURL
        case altText
    }
}

struct Inventory: Codable, Identifiable {
    let id: String
    let quantityAvailable: Int
    let quantityReserved: Int
    let lowStockThreshold: Int

    enum CodingKeys: String, CodingKey {
        case id
        case quantityAvailable
        case quantityReserved
        case lowStockThreshold
    }
}
