//
//  APIEndpoint.swift
//  simple-e-commerce-app-ios
//
//  Created by Laurentius Brandon Vikario on 03/09/26.
//

import Foundation

struct APIEndpoints {
    static let baseURL = "https://swiftshop-e-commerce-app-apigateway.onrender.com/api/v1"
    
    struct Customer {
        static let register = "\(baseURL)/customers/register"
        static let login = "\(baseURL)/customers/login"
        static let logout = "\(baseURL)/customers/logout"
    }
    
    struct Product {
        static func all(categoryId: String? = nil, minPrice: Double? = nil, maxPrice: Double? = nil) -> String {
            var components = URLComponents(string: "\(baseURL)/products")!
            var queryItems: [URLQueryItem] = []
            
            if let categoryId = categoryId, !categoryId.isEmpty {
                queryItems.append(URLQueryItem(name: "categoryId", value: categoryId))
            }
            if let minPrice = minPrice {
                queryItems.append(URLQueryItem(name: "minPrice", value: String(minPrice)))
            }
            if let maxPrice = maxPrice {
                queryItems.append(URLQueryItem(name: "maxPrice", value: String(maxPrice)))
            }
            
            if !queryItems.isEmpty {
                components.queryItems = queryItems
            }
            
            return components.string ?? "\(baseURL)/products"
        }
        
        static func detail(id: String) -> String { "\(baseURL)/products/\(id)" }
    }
    
    struct Category {
        static let all = "\(baseURL)/categories"
    }
    
    struct Order {
        static let create = "\(baseURL)/orders"
        static func history(page: Int = 1, per: Int = 20) -> String {
            "\(baseURL)/orders?page=\(page)&per=\(per)"
        }
    }
    
    struct Payment {
        static let pay = "\(baseURL)/payments/pay"
    }
    
    struct Notification {
        static func get(page: Int = 1, per: Int = 20) -> String {
            "\(baseURL)/notifications?page=\(page)&per=\(per)"
        }
    }
    
    struct Cart {
        static func get(customerID: String) -> String { "\(baseURL)/carts?customer_id=\(customerID)" }
        static let items = "\(baseURL)/carts/items"
        static func item(id: String) -> String { "\(baseURL)/carts/items/\(id)" }
    }
    
    struct CustomerAddress {
        static let base = "\(baseURL)/customers/addresses"
        static func detail(id: String) -> String { "\(baseURL)/customers/addresses/\(id)" }
    }
}
