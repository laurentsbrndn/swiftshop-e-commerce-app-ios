//
//  CheckoutRepository.swift
//  simple-e-commerce-app-ios
//
//  Created by Laurentius Brandon Vikario on 09/09/26.
//

import Foundation

protocol CheckoutRepositoryProtocol {
    func fetchAddresses(token: String) async throws -> [CustomerAddressResponse]
    func createOrder(request: CreateOrderRequestDTO, token: String) async throws -> OrderResponseDTO
    func processPayment(request: PaymentRequestDTO, token: String) async throws -> EmptyResponse
}

struct CheckoutRepository: CheckoutRepositoryProtocol {
    func fetchAddresses(token: String) async throws -> [CustomerAddressResponse] {
        return try await APIClient.shared.request(
            url: APIEndpoints.CustomerAddress.base,
            method: "GET",
            token: token
        )
    }
    
    func createOrder(request: CreateOrderRequestDTO, token: String) async throws -> OrderResponseDTO {
        return try await APIClient.shared.request(
            url: APIEndpoints.Order.create,
            method: "POST",
            body: request,
            token: token,
            additionalHeaders: ["Idempotency-Key": UUID().uuidString]
        )
    }
    
    func processPayment(request: PaymentRequestDTO, token: String) async throws -> EmptyResponse {
        return try await APIClient.shared.request(
            url: APIEndpoints.Payment.pay,
            method: "POST",
            body: request,
            token: token,
            additionalHeaders: ["Idempotency-Key": UUID().uuidString]
        )
    }
}
