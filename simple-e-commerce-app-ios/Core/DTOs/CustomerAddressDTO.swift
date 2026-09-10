//
//  CustomerAddressDTO.swift
//  simple-e-commerce-app-ios
//
//  Created by Laurentius Brandon Vikario on 08/09/26.
//

import Foundation

struct CreateCustomerAddressRequest: Codable {
    let label: String
    let recipientName: String
    let recipientPhone: String
    let addressLine: String
    let city: String
    let state: String
    let postalCode: String
    let countryCode: String
    let isDefault: Bool?
}

struct UpdateCustomerAddressRequest: Codable {
    var label: String?
    var recipientName: String?
    var recipientPhone: String?
    var addressLine: String?
    var city: String?
    var state: String?
    var postalCode: String?
    var countryCode: String?
    var isDefault: Bool?
}

struct CustomerAddressResponse: Codable, Identifiable, Hashable {
    let id: String
    let label: String
    let recipientName: String
    let recipientPhone: String
    let addressLine: String
    let city: String
    let state: String
    let postalCode: String
    let countryCode: String
    let isDefault: Bool
}

//struct EmptyResponse: Decodable {}
