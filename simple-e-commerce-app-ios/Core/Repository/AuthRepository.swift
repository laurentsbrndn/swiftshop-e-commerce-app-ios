//
//  AuthRepository.swift
//  simple-e-commerce-app-ios
//
//  Created by Laurentius Brandon Vikario on 03/09/26.
//

import Foundation

protocol AuthRepositoryProtocol {
    func login(request: AuthRequest) async throws -> AuthResponse
    func register(request: RegisterRequest) async throws -> AuthResponse
    func logout(token: String) async throws
}

struct AuthRepository: AuthRepositoryProtocol {
    func login(request: AuthRequest) async throws -> AuthResponse {
        return try await APIClient.shared.request(
            url: APIEndpoints.Customer.login,
            method: "POST",
            body: request
        )
    }
    
    func register(request: RegisterRequest) async throws -> AuthResponse {
        return try await APIClient.shared.request(
            url: APIEndpoints.Customer.register,
            method: "POST",
            body: request
        )
    }
    
    func logout(token: String) async throws {
        let _: EmptyResponse = try await APIClient.shared.request(
            url: APIEndpoints.Customer.logout,
            method: "POST",
            token: token
        )
    }
}
