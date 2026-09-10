//
//  CartViewModel.swift
//  simple-e-commerce-app-ios
//
//  Created by Laurentius Brandon Vikario on 07/09/26.
//


import SwiftUI
internal import Combine

@MainActor
class CartViewModel: ObservableObject {
    @Published var cart: Cart?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    @Published var selectedItemIDs: Set<String> = []
    
    private let repository: CartRepositoryProtocol
    
    init(repository: CartRepositoryProtocol = CartRepository()) {
        self.repository = repository
    }
    
    var totalSelectedPrice: Double {
        guard let items = cart?.items else { return 0 }
        return items
            .filter { selectedItemIDs.contains($0.id) }
            .reduce(0) { $0 + ($1.unitPrice * Double($1.quantity)) }
    }
    
    func fetchCart(customerID: String, token: String?) async {
        isLoading = true
        errorMessage = nil
        do {
            cart = try await repository.fetchCart(customerID: customerID, token: token)
            if let items = cart?.items {
                let availableItems = items.filter { $0.availableStock > 0 }.map { $0.id }
                selectedItemIDs = Set(availableItems)
            }
        } catch {
            errorMessage = "Failed to load cart."
        }
        isLoading = false
    }
    
    func addToCart(product: Product, quantity: Int, customerID: String, token: String?) async -> Bool {
        let request = AddToCartRequest(
            customerID: customerID,
            productID: product.id,
            quantity: quantity,
            productName: product.name,
            unitPrice: product.price,
            productImageUrl: product.images.first?.imageURL,
            availableStock: product.inventory?.quantityAvailable ?? 0
        )
        
        do {
            cart = try await repository.addToCart(request: request, token: token)
            return true
        } catch {
            errorMessage = "Failed to add to cart: \(error.localizedDescription)"
            return false
        }
    }
    
    func updateQuantity(itemID: String, newQuantity: Int, customerID: String, token: String?) async {
        guard let itemIndex = cart?.items.firstIndex(where: { $0.id == itemID }),
              let item = cart?.items[itemIndex] else { return }
        
        let validatedQty = max(1, min(newQuantity, item.availableStock))
        
        cart?.items[itemIndex].quantity = validatedQty
        
        let request = UpdateCartItemRequest(quantity: validatedQty)
        do {
            _ = try await repository.updateCartItem(itemID: itemID, request: request, token: token)
        } catch {
            await fetchCart(customerID: customerID, token: token)
        }
    }
    
    func deleteItem(itemID: String, customerID: String, token: String?) async {
        selectedItemIDs.remove(itemID)
        
        do {
            _ = try await repository.removeCartItem(
                itemID: itemID,
                token: token
            )
            
            cart?.items.removeAll { $0.id == itemID }
            
        } catch {
            errorMessage = "Failed to delete item."
        }
    }
    
    func toggleSelection(for itemID: String) {
        if selectedItemIDs.contains(itemID) {
            selectedItemIDs.remove(itemID)
        } else {
            selectedItemIDs.insert(itemID)
        }
    }
}
