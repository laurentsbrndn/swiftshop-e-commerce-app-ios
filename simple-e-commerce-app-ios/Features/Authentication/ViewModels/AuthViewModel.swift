//
//  AuthViewModel.swift
//  simple-e-commerce-app-ios
//
//  Created by Laurentius Brandon Vikario on 03/09/26.
//

import SwiftUI
internal import Combine

@MainActor
class AuthViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var isAuthenticated = false
    
    private let repository: AuthRepositoryProtocol
    
    init(repository: AuthRepositoryProtocol = AuthRepository()) {
        self.repository = repository
    }
    
    @discardableResult
    func login() async -> AuthResponse? {
        isLoading = true
        errorMessage = nil
        
        do {
            let request = AuthRequest(email: email, password: password)
            let response = try await repository.login(request: request)
            isAuthenticated = true
            isLoading = false
            return response
        } catch {
            errorMessage = "Login failed. Please check your email and password"
            isLoading = false
            return nil
        }
    }
}
