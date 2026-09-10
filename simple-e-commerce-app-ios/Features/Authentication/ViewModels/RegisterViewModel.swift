//
//  RegisterViewModel.swift
//  simple-e-commerce-app-ios
//
//  Created by Laurentius Brandon Vikario on 03/09/26.
//


import Foundation
internal import Combine

@MainActor
class RegisterViewModel: ObservableObject {
    @Published var firstName = ""
    @Published var lastName = ""
    @Published var phoneNumber = ""
    @Published var email = ""
    @Published var password = ""
    
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var isRegistered = false
    
    private let repository: AuthRepositoryProtocol
    
    init(repository: AuthRepositoryProtocol = AuthRepository()) {
        self.repository = repository
    }
    
    var isFormValid: Bool {
        !firstName.isEmpty && !lastName.isEmpty && !email.isEmpty && !password.isEmpty
    }
    
    func register() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let request = RegisterRequest(
                email: email,
                password: password,
                firstName: firstName,
                lastName: lastName,
                phoneNumber: phoneNumber.isEmpty ? nil : phoneNumber
            )
            
            let _ = try await repository.register(request: request)
            
            isRegistered = true
        } catch {
            errorMessage = "Pendaftaran gagal. Silakan periksa koneksi atau coba email lain."
        }
        
        isLoading = false
    }
}
