//
//  CustomerAddressRepository.swift
//  simple-e-commerce-app-ios
//
//  Created by Laurentius Brandon Vikario on 08/09/26.
//

import Foundation

protocol CustomerAddressRepositoryProtocol {
    func fetchAddresses(token: String) async throws -> [CustomerAddressResponse]
    func createAddress(token: String, request: CreateCustomerAddressRequest) async throws -> CustomerAddressResponse
    func updateAddress(token: String, addressId: String, request: UpdateCustomerAddressRequest) async throws -> CustomerAddressResponse
    func deleteAddress(token: String, addressId: String) async throws
}

struct CustomerAddressRepository: CustomerAddressRepositoryProtocol {
    
    private func authenticatedRequest<T: Decodable>(url: String, method: String, token: String, body: Data? = nil) async throws -> T {
        guard let endpoint = URL(string: url) else { throw URLError(.badURL) }
        
        var request = URLRequest(url: endpoint)
        request.httpMethod = method
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = body
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        if !(200...299).contains(httpResponse.statusCode) {
            let errorMessage = "Server Error: \(httpResponse.statusCode)"
            throw NSError(domain: "APIError", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: errorMessage])
        }
        
        if T.self == EmptyResponse.self {
            return EmptyResponse() as! T
        }
        
        return try JSONDecoder().decode(T.self, from: data)
    }
    
    func fetchAddresses(token: String) async throws -> [CustomerAddressResponse] {
        return try await authenticatedRequest(url: APIEndpoints.CustomerAddress.base, method: "GET", token: token)
    }
    
    func createAddress(token: String, request: CreateCustomerAddressRequest) async throws -> CustomerAddressResponse {
        let body = try JSONEncoder().encode(request)
        return try await authenticatedRequest(url: APIEndpoints.CustomerAddress.base, method: "POST", token: token, body: body)
    }
    
    func updateAddress(token: String, addressId: String, request: UpdateCustomerAddressRequest) async throws -> CustomerAddressResponse {
        let body = try JSONEncoder().encode(request)
        return try await authenticatedRequest(url: APIEndpoints.CustomerAddress.detail(id: addressId), method: "PUT", token: token, body: body)
    }
    
    func deleteAddress(token: String, addressId: String) async throws {
        let _: EmptyResponse = try await authenticatedRequest(url: APIEndpoints.CustomerAddress.detail(id: addressId), method: "DELETE", token: token)
    }
}
