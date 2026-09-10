//
//  ProductViewModel.swift
//  simple-e-commerce-app-ios
//
//  Created by Laurentius Brandon Vikario on 03/09/26.
//

import SwiftUI
internal import Combine

@MainActor
class ProductViewModel: ObservableObject {
    @Published var products: [Product] = []
    @Published var categories: [Category] = []
    
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    @Published var selectedCategoryId: String?
    @Published var minPriceText: String = ""
    @Published var maxPriceText: String = ""
    
    private let repository: ProductRepositoryProtocol
    
    init(repository: ProductRepositoryProtocol = ProductRepository()) {
        self.repository = repository
    }
    
    func fetchProducts() async {
        isLoading = true
        errorMessage = nil
        
        let minPrice = Double(minPriceText)
        let maxPrice = Double(maxPriceText)
        
        do {
            products = try await repository.fetchProducts(
                categoryId: selectedCategoryId,
                minPrice: minPrice,
                maxPrice: maxPrice
            )
        } catch {
            print("❌ Product fetch error: \(error)")
            errorMessage = "Failed to load product catalog."
        }
        
        isLoading = false
    }
    
    func fetchCategories() async {
        do {
            categories = try await repository.fetchCategories()
            print("✅ Categories fetched: \(categories.count) items")
        } catch {
            print("❌ Category fetch error:")
            print(error)
            
            if let decodingError = error as? DecodingError {
                switch decodingError {
                case .keyNotFound(let key, let context):
                    print("Missing key: \(key.stringValue) di path: \(context.codingPath)")
                case .typeMismatch(let type, let context):
                    print("Type mismatch: \(type) di path: \(context.codingPath)")
                case .valueNotFound(let type, let context):
                    print("Value not found: \(type) di path: \(context.codingPath)")
                case .dataCorrupted(let context):
                    print("Data corrupted di path: \(context.codingPath)")
                @unknown default:
                    print("Unknown decoding error")
                }
            }
        }
    }
    
    func resetFilters() {
        selectedCategoryId = nil
        minPriceText = ""
        maxPriceText = ""
        Task {
            await fetchProducts()
        }
    }
}
