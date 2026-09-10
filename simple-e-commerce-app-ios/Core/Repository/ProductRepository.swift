//
//  ProductRepository.swift
//  simple-e-commerce-app-ios
//
//  Created by Laurentius Brandon Vikario on 03/09/26.
//

import Foundation

protocol ProductRepositoryProtocol {
    func fetchProducts(categoryId: String?, minPrice: Double?, maxPrice: Double?) async throws -> [Product]
    func fetchProductDetail(id: String) async throws -> Product
    func fetchCategories() async throws -> [Category]
}

struct ProductRepository: ProductRepositoryProtocol {
    func fetchProducts(categoryId: String? = nil, minPrice: Double? = nil, maxPrice: Double? = nil) async throws -> [Product] {
        let urlString = APIEndpoints.Product.all(categoryId: categoryId, minPrice: minPrice, maxPrice: maxPrice)
        return try await APIClient.shared.request(url: urlString)
    }
    
    func fetchProductDetail(id: String) async throws -> Product {
        return try await APIClient.shared.request(url: APIEndpoints.Product.detail(id: id))
    }
    
    func fetchCategories() async throws -> [Category] {
        return try await APIClient.shared.request(url: APIEndpoints.Category.all)
    }
}
