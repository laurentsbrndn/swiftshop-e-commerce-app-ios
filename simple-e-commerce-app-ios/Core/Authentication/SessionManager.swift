//
//  SessionManager.swift
//  simple-e-commerce-app-ios
//
//  Created by Laurentius Brandon Vikario on 06/09/26.
//

import SwiftUI
internal import Combine
import Security

@MainActor
class SessionManager: ObservableObject {
    private static let tokenKey = "authToken"
    private static let customerKey = "savedCustomerProfile"
    
    @Published private(set) var isAuthenticated: Bool = false
    @Published private(set) var currentCustomer: AuthResponse?
    @Published private(set) var token: String = ""
    
    private let authRepository: AuthRepositoryProtocol = AuthRepository()
    
    var customerID: String? {
        currentCustomer?.customerID
    }
    
    init() {
        let savedToken = KeychainHelper.standard.read(service: Self.tokenKey, account: "userSession") ?? ""
        
        if !savedToken.isEmpty {
            self.token = savedToken
            self.isAuthenticated = true
            
            if let savedCustomerData = UserDefaults.standard.data(forKey: Self.customerKey),
               let customer = try? JSONDecoder().decode(AuthResponse.self, from: savedCustomerData) {
                self.currentCustomer = customer
            }
        }
    }
    
    func login(response: AuthResponse) {
        self.token = response.token
        self.currentCustomer = response
        self.isAuthenticated = true
        
        let tokenData = Data(response.token.utf8)
        KeychainHelper.standard.save(tokenData, service: Self.tokenKey, account: "userSession")
        
        if let encodedData = try? JSONEncoder().encode(response) {
            UserDefaults.standard.set(encodedData, forKey: Self.customerKey)
        }
    }
    
    func login(token: String, customer: AuthResponse? = nil) {
        self.token = token
        self.currentCustomer = customer
        self.isAuthenticated = true
        
        let tokenData = Data(token.utf8)
        KeychainHelper.standard.save(tokenData, service: Self.tokenKey, account: "userSession")
        
        if let customer = customer, let encodedData = try? JSONEncoder().encode(customer) {
            UserDefaults.standard.set(encodedData, forKey: Self.customerKey)
        }
    }
    
    func logout() async {
        let currentToken = self.token
        
        if !currentToken.isEmpty {
            do {
                try await authRepository.logout(token: currentToken)
            } catch {
                print("⚠️ Server logout failed or token already invalid:", error)
            }
        }
        
        self.token = ""
        self.currentCustomer = nil
        self.isAuthenticated = false
        
        KeychainHelper.standard.delete(service: Self.tokenKey, account: "userSession")
        UserDefaults.standard.removeObject(forKey: Self.customerKey)
    }
}

final class KeychainHelper {
    static let standard = KeychainHelper()
    private init() {}
    
    func save(_ data: Data, service: String, account: String) {
        delete(service: service, account: account)
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecValueData as String: data
        ]
        
        SecItemAdd(query as CFDictionary, nil)
    }
    
    func read(service: String, account: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        if status == errSecSuccess, let data = dataTypeRef as? Data {
            return String(data: data, encoding: .utf8)
        }
        return nil
    }
    
    func delete(service: String, account: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account
        ]
        
        SecItemDelete(query as CFDictionary)
    }
}
