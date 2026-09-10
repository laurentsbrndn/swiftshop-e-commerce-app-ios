//
//  OrderRepository.swift
//  simple-e-commerce-app-ios
//
//  Created by Laurentius Brandon Vikario on 06/09/26.
//

import Foundation

protocol OrderRepositoryProtocol {
    func fetchOrderHistory(token: String?) async throws -> [OrderHistoryResponse]
}

struct OrderRepository: OrderRepositoryProtocol {
    func fetchOrderHistory(token: String? = nil) async throws -> [OrderHistoryResponse] {
        let endpoint = APIEndpoints.Order.history()
        let response: PagedResponse<OrderHistoryResponse> = try await APIClient.shared.request(
            url: endpoint,
            token: token
        )
        return response.items
    }
}
