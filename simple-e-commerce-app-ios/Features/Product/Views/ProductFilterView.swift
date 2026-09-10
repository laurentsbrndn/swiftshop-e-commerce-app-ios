//
//  ProductFilterView.swift
//  simple-e-commerce-app-ios
//
//  Created by Laurentius Brandon Vikario on 07/09/26.
//


import SwiftUI

struct ProductFilterView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: ProductViewModel
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Category")) {
                    Picker("Select Category", selection: $viewModel.selectedCategoryId) {
                        Text("All Categories").tag(String?.none)
                        
                        ForEach(viewModel.categories) { category in
                            Text(category.name).tag(String?(category.id))
                        }
                    }
                }
                
                Section(
                    header: Text("Price Range"),
                    footer: Text("Enter the manual minimum and maximum price to filter products.")
                ) {
                    HStack {
                        Text("Min")
                            .foregroundColor(.secondary)
                        TextField("e.g. 10000", text: $viewModel.minPriceText)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                    }
                    
                    HStack {
                        Text("Max")
                            .foregroundColor(.secondary)
                        TextField("e.g. 5000000", text: $viewModel.maxPriceText)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                    }
                }
            }
            .navigationTitle("Filter Options")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Reset") {
                        viewModel.resetFilters()
                        dismiss()
                    }
                    .foregroundColor(.red)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Apply") {
                        Task {
                            await viewModel.fetchProducts()
                        }
                        dismiss()
                    }
                    .fontWeight(.bold)
                }
            }
        }
    }
}
