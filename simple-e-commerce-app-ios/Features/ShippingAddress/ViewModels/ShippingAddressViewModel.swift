////
////  ShippingAddressViewModel.swift
////  simple-e-commerce-app-ios
////
////  Created by Laurentius Brandon Vikario on 08/09/26.
////

import SwiftUI
internal import Combine

@MainActor
class ShippingAddressViewModel: ObservableObject {
    @Published var addresses: [CustomerAddressResponse] = []
    @Published var isLoading = false
    @Published var showError = false
    @Published var errorMessage: String = ""
    
    private let repository: CustomerAddressRepositoryProtocol
    
    init(repository: CustomerAddressRepositoryProtocol = CustomerAddressRepository()) {
        self.repository = repository
    }
    
    func fetchAddresses(token: String) async {
        guard !token.isEmpty else { return }
        isLoading = true
        do {
            addresses = try await repository.fetchAddresses(token: token)
        } catch {
            showErrorAlert(message: "Failed to load addresses. Please try again.")
        }
        isLoading = false
    }
    
    func saveAddress(token: String, request: CreateCustomerAddressRequest, editingID: String? = nil) async -> Bool {
        guard !token.isEmpty else { return false }
        isLoading = true
        do {
            if let id = editingID {
                let updateRequest = UpdateCustomerAddressRequest(
                    label: request.label, recipientName: request.recipientName,
                    recipientPhone: request.recipientPhone, addressLine: request.addressLine,
                    city: request.city, state: request.state,
                    postalCode: request.postalCode, countryCode: request.countryCode,
                    isDefault: request.isDefault
                )
                _ = try await repository.updateAddress(token: token, addressId: id, request: updateRequest)
            } else {
                _ = try await repository.createAddress(token: token, request: request)
            }
            await fetchAddresses(token: token)
            isLoading = false
            return true
        } catch {
            isLoading = false
            showErrorAlert(message: "Failed to save address. Please check your data.")
            return false
        }
    }
    
    func deleteAddress(token: String, id: String) async -> Bool {
        guard !token.isEmpty else { return false }
        do {
            try await repository.deleteAddress(token: token, addressId: id)
            await fetchAddresses(token: token)
            return true
        } catch {
            showErrorAlert(message: "Cannot delete your only address. You must maintain at least one.")
            return false
        }
    }
    
    private func showErrorAlert(message: String) {
        errorMessage = message
        showError = true
    }
}
