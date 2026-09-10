////
////  CartDTO.swift
////  simple-e-commerce-app-ios
////
////  Created by Laurentius Brandon Vikario on 07/09/26.
////
//
//import Foundation
//
//struct Cart: Codable, Identifiable {
//    let id: String
//    let customerId: String
//    let status: String
//    let currency: String
//    var items: [CartItem]
//    
//    enum CodingKeys: String, CodingKey {
//        case id, status, currency, items
//        case customerId = "customer_id"
//    }
//}
//
//struct CartItem: Codable, Identifiable, Equatable {
//    let id: String
//    let productId: String
//    let productName: String
//    let unitPrice: Double
//    let productImageUrl: String?
//    var quantity: Int
//    let availableStock: Int
//    
//    enum CodingKeys: String, CodingKey {
//        case id, quantity
//        case productId = "product_id"
//        case productName = "product_name"
//        case unitPrice = "unit_price"
//        case productImageUrl = "product_image_url"
//        case availableStock = "available_stock"
//    }
//}
//
//struct AddToCartRequest: Codable {
//    let customerID: String
//    let productID: String
//    let quantity: Int
//    let productName: String
//    let unitPrice: Double
//    let productImageUrl: String?
//    let availableStock: Int
//}
//
//struct UpdateCartItemRequest: Codable {
//    let quantity: Int
//}
//
//struct EmptyResponse: Codable {}

//
//  CartDTO.swift
//  simple-e-commerce-app-ios
//
//  Created by Laurentius Brandon Vikario on 07/09/26.
//

import Foundation

struct Cart: Codable, Identifiable {
    let id: String
    let customerId: String
    let status: String
    let currency: String
    var items: [CartItem]

    enum CodingKeys: String, CodingKey {
        case id, status, currency, items
        case customerId = "customerID"
    }
}

struct CartItem: Codable, Identifiable, Equatable {
    let id: String
    let productId: String
    let productName: String
    let unitPrice: Double
    let productImageUrl: String?
    var quantity: Int
    let availableStock: Int

    enum CodingKeys: String, CodingKey {
        case id, quantity, productName, unitPrice, productImageUrl, availableStock
        case productId = "productID"
    }
}

struct AddToCartRequest: Codable {
    let customerID: String
    let productID: String
    let quantity: Int
    let productName: String
    let unitPrice: Double
    let productImageUrl: String?
    let availableStock: Int
}

struct UpdateCartItemRequest: Codable {
    let quantity: Int
}

struct EmptyResponse: Codable {}
