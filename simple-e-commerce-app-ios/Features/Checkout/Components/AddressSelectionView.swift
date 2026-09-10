//
//  AddressSelectionView.swift
//  simple-e-commerce-app-ios
//
//  Created by Laurentius Brandon Vikario on 09/09/26.
//


import SwiftUI

struct AddressSelectionView: View {
    @Environment(\.dismiss) private var dismiss
    let addresses: [CustomerAddressResponse]
    @Binding var selectedAddress: CustomerAddressResponse?
    
    var body: some View {
        List(addresses, id: \.id) { address in
            Button {
                selectedAddress = address
                dismiss()
            } label: {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(address.label)
                            .font(.caption).bold()
                            .foregroundStyle(.blue)
                        
                        Text(address.recipientName)
                            .font(.headline)
                            .foregroundStyle(.primary)
                        
                        Text("\(address.addressLine), \(address.city)")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    
                    Spacer()
                    
                    if selectedAddress?.id == address.id {
                        Image(systemName: "checkmark")
                            .foregroundStyle(.blue)
                            .fontWeight(.bold)
                    }
                }
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
        }
        .navigationTitle("Select Address")
        .navigationBarTitleDisplayMode(.inline)
    }
}
