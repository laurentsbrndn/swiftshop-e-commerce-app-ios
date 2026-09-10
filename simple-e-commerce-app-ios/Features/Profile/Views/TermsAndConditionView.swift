//
//  TermsAndConditionView.swift
//  simple-e-commerce-app-ios
//
//  Created by Laurentius Brandon Vikario on 09/09/26.
//


import SwiftUI

struct TermsAndConditionView: View {
    var body: some View {
        List {
            Section {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Terms & Conditions")
                        .font(.title2.weight(.bold))
                    
                    Text("Last updated: September 9, 2026")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    
                    Text("Please read these terms and conditions carefully before using our e-commerce platform.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .padding(.top, 4)
                }
                .padding(.vertical, 4)
            }
            
            Section("1. User Account") {
                Text("You are responsible for maintaining the confidentiality of your account login credentials and for all activities that occur under your account.")
                    .font(.subheadline)
                    .padding(.vertical, 2)
            }
            
            Section("2. Orders & Payments") {
                VStack(alignment: .leading, spacing: 8) {
                    Text("All orders placed are subject to product availability and confirmation of the order price.")
                        .font(.subheadline)
                    
                    Text("Payments must be completed in full before order processing and shipment dispatched.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .padding(.vertical, 2)
            }
            
            Section("3. Shipping & Delivery") {
                Text("Delivery times may vary based on shipping location. We are not liable for delays caused by third-party logistics providers or force majeure events.")
                    .font(.subheadline)
                    .padding(.vertical, 2)
            }
            
            Section("4. Returns & Cancellations") {
                Text("Orders can be cancelled prior to payment completion. Once paid, return and refund requests are subject to our standard store verification policy.")
                    .font(.subheadline)
                    .padding(.vertical, 2)
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Terms & Conditions")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        TermsAndConditionView()
    }
}