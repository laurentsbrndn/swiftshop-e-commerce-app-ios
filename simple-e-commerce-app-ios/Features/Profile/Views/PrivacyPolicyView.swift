//
//  PrivacyPolicyView.swift
//  simple-e-commerce-app-ios
//
//  Created by Laurentius Brandon Vikario on 09/09/26.
//


import SwiftUI

struct PrivacyPolicyView: View {
    var body: some View {
        List {
            Section {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Privacy Policy")
                        .font(.title2.weight(.bold))
                    
                    Text("Last updated: September 9, 2026")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    
                    Text("We respect your privacy and are committed to protecting your personal data. This privacy policy explains how we handle your information when you use our app.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .padding(.top, 4)
                }
                .padding(.vertical, 4)
            }
            
            Section("1. Information We Collect") {
                VStack(alignment: .leading, spacing: 8) {
                    Text("We collect personal information that you provide to us when registering, such as your name, email address, phone number, and shipping address.")
                        .font(.subheadline)
                    
                    Text("We also collect transaction details required to process your purchases and maintain transaction history.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .padding(.vertical, 2)
            }
            
            Section("2. How We Use Your Data") {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Your data is strictly used for order processing, shipping logistics, payment verification, and sending order-related notifications.")
                        .font(.subheadline)
                    
                    Text("We do not sell or trade your personal data to third parties.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .padding(.vertical, 2)
            }
            
            Section("3. Data Security") {
                Text("We implement industry-standard security measures including encrypted authentication tokens (JWT) and secure Keychain storage to prevent unauthorized access.")
                    .font(.subheadline)
                    .padding(.vertical, 2)
            }
            
            Section("4. Your Rights") {
                Text("You have the right to review, update, or request the deletion of your personal account data at any time through our customer support.")
                    .font(.subheadline)
                    .padding(.vertical, 2)
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Privacy Policy")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        PrivacyPolicyView()
    }
}