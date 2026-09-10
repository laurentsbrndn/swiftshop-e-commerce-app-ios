//
//  ProductSearchBar.swift
//  simple-e-commerce-app-ios
//
//  Created by Laurentius Brandon Vikario on 07/09/26.
//


import SwiftUI

struct ProductSearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack(spacing: 12) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.secondary)
                
                TextField("Search product...", text: $text)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                
                if !text.isEmpty {
                    Button(action: { text = "" }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .padding(8)
            .background(Color(.systemGray6))
            .cornerRadius(10)
            
            Menu {
                Section("Filter Price") {
                    Button("Lowest to Highest") { /* Action */ }
                    Button("Highest to Lowest") { /* Action */ }
                }
                Section("Filter Category") {
                    Button("All Categories") { /* Action */ }
                }
            } label: {
                Image(systemName: "ellipsis.circle")
                    .font(.title2)
                    .foregroundColor(.accentColor)
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
}
