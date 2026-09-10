//
//  CartRepository.swift
//  simple-e-commerce-app-ios
//
//  Created by Laurentius Brandon Vikario on 07/09/26.
//

import Foundation

protocol CartRepositoryProtocol {
    func fetchCart(customerID: String, token: String?) async throws -> Cart
    func addToCart(request: AddToCartRequest, token: String?) async throws -> Cart
    func updateCartItem(itemID: String, request: UpdateCartItemRequest, token: String?) async throws -> CartItem
    func removeCartItem(itemID: String, token: String?) async throws -> CartItem
}

struct CartRepository: CartRepositoryProtocol {
    func fetchCart(customerID: String, token: String? = nil) async throws -> Cart {
        let endpoint = APIEndpoints.Cart.get(customerID: customerID)
        return try await APIClient.shared.request(url: endpoint, token: token)
    }
    
    func addToCart(request: AddToCartRequest, token: String? = nil) async throws -> Cart {
        return try await APIClient.shared.request(
            url: APIEndpoints.Cart.items,
            method: "POST",
            body: request,
            token: token
        )
    }
    
    func updateCartItem(itemID: String, request: UpdateCartItemRequest, token: String? = nil) async throws -> CartItem {
        return try await APIClient.shared.request(
            url: APIEndpoints.Cart.item(id: itemID),
            method: "PUT",
            body: request,
            token: token
        )
    }
    
    func removeCartItem(itemID: String, token: String? = nil) async throws -> CartItem {
        return try await APIClient.shared.request(
            url: APIEndpoints.Cart.item(id: itemID),
            method: "DELETE",
            token: token
        )
    }
}
