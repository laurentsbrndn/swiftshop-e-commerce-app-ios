//
//  QuantityInputView.swift
//  simple-e-commerce-app-ios
//
//  Created by Laurentius Brandon Vikario on 07/09/26.
//


import SwiftUI

struct QuantityInputView: View {
    @Binding var quantity: Int
    let maxStock: Int
    
    var body: some View {
        HStack(spacing: 8) {
            Button(action: {
                if quantity > 1 { quantity -= 1 }
            }) {
                Image(systemName: "minus.circle.fill")
                    .foregroundColor(quantity > 1 ? .accentColor : .gray.opacity(0.5))
                    .font(.title2)
            }
            .buttonStyle(.plain)
            
            TextField("", value: $quantity, format: .number)
                .keyboardType(.numberPad)
                .multilineTextAlignment(.center)
                .frame(width: 44)
                .padding(4)
                .background(Color(.systemGray6))
                .cornerRadius(6)
                .onChange(of: quantity) { newValue in
                    if newValue < 1 {
                        quantity = 1
                    } else if newValue > maxStock {
                        quantity = maxStock
                    }
                }
            
            Button(action: {
                if quantity < maxStock { quantity += 1 }
            }) {
                Image(systemName: "plus.circle.fill")
                    .foregroundColor(quantity < maxStock ? .accentColor : .gray.opacity(0.5))
                    .font(.title2)
            }
            .buttonStyle(.plain)
        }
    }
}