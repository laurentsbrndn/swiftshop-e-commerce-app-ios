//
//  ProductListView.swift
//  simple-e-commerce-app-ios
//
//  Created by Laurentius Brandon Vikario on 03/09/26.
//

import SwiftUI

struct ProductListView: View {
    @StateObject private var viewModel = ProductViewModel()
    
    @State private var searchText = ""
    @State private var isShowingFilter = false
    
    var filteredProducts: [Product] {
        if searchText.isEmpty {
            return viewModel.products
        } else {
            return viewModel.products.filter { product in
                product.name.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        Group {
            if viewModel.isLoading && viewModel.products.isEmpty {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let errorMessage = viewModel.errorMessage {
                ErrorStateView(message: errorMessage) {
                    Task { await loadData() }
                }
            } else if filteredProducts.isEmpty {
                ContentUnavailableView(
                    "No Products Found",
                    systemImage: "magnifyingglass",
                    description: Text("Try adjusting your search or filter options.")
                )
            } else {
                List(filteredProducts) { product in
                    NavigationLink(destination: ProductDetailView(productId: product.id)) {
                        ProductRowView(product: product)
                    }
                }
                .listStyle(.plain)
                .refreshable {
                    await loadData()
                }
            }
        }
        .navigationTitle("Product Catalog")
        
        .searchable(text: $searchText, prompt: "Search product...")
        
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    isShowingFilter = true
                }) {
                    Image(systemName: "ellipsis")
                        .font(.body)
                }
            }
        }
        
        .sheet(isPresented: $isShowingFilter) {
            ProductFilterView(viewModel: viewModel)
                .presentationDetents([.large])
        }
        .task {
            if viewModel.categories.isEmpty {
                await viewModel.fetchCategories()
            }
            if viewModel.products.isEmpty {
                await viewModel.fetchProducts()
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .checkoutDidSucceed)) { _ in
            Task {
                await viewModel.fetchProducts()
            }
        }
    }
    
    private func loadData() async {
        await viewModel.fetchCategories()
        await viewModel.fetchProducts()
    }
}
