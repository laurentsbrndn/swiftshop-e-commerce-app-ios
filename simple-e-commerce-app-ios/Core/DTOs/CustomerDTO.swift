//
//  CustomerDTO.swift
//  simple-e-commerce-app-ios
//
//  Created by Laurentius Brandon Vikario on 03/09/26.
//

import Foundation

struct RegisterRequest: Codable {
    let email: String
    let password: String
    let firstName: String
    let lastName: String
    let phoneNumber: String?
}

struct AuthResponse: Codable {
    let token: String
    let customerID: String
    let email: String
    let firstName: String
}

struct AuthRequest: Codable {
    let email: String
    let password: String
}
