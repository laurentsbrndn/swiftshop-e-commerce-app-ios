//
//  ProductDetailView.swift
//  simple-e-commerce-app-ios
//
//  Created by Laurentius Brandon Vikario on 03/09/26.
//

import SwiftUI

struct ProductDetailView: View {
    let productId: String
    @State private var product: Product?
    @State private var isLoading = true
    @State private var errorMessage: String?
    @State private var showFullDescription = false
    
    @EnvironmentObject var cartViewModel: CartViewModel
    @State private var selectedQuantity: Int = 1
    @State private var isAddingToCart = false
    
    @EnvironmentObject var sessionManager: SessionManager
    
    private let repository = ProductRepository()
    
    var body: some View {
        Group {
            if isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let product = product {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        
                        if let firstImageURL = product.images.first?.imageURL, let url = URL(string: firstImageURL) {
                            AsyncImage(url: url) { phase in
                                switch phase {
                                case .empty:
                                    ProgressView()
                                        .frame(maxWidth: .infinity, minHeight: 300)
                                case .success(let image):
                                    image
                                        .resizable()
                                        .scaledToFill()
                                        .frame(maxWidth: .infinity, maxHeight: 350)
                                        .clipped()
                                case .failure:
                                    Image(systemName: "photo")
                                        .font(.largeTitle)
                                        .foregroundColor(.secondary)
                                        .frame(maxWidth: .infinity, minHeight: 300)
                                @unknown default:
                                    EmptyView()
                                }
                            }
                            .background(Color(.secondarySystemBackground))
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text(product.name)
                                .font(.title2)
                                .fontWeight(.bold)
                            
                            HStack {
                                Text("\(product.currency) \(product.price.formatted(.number.precision(.fractionLength(2))))")
                                    .font(.title3)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.primary)
                                
                                Spacer()
                                
                                if let inventory = product.inventory {
                                    Text("Stock: \(inventory.quantityAvailable)")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                            }
                            
                            Text(product.status.capitalized)
                                .font(.caption)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color(.systemGray5))
                                .cornerRadius(6)
                        }
                        .padding(.horizontal)
                        
                        Divider()
                            .padding(.horizontal)
                        
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Description")
                                .font(.headline)
                            
                            if let shortDesc = product.shortDescription, !shortDesc.isEmpty,
                               let fullDesc = product.description, !fullDesc.isEmpty {
                                
                                Text(showFullDescription ? fullDesc : shortDesc)
                                    .font(.body)
                                    .foregroundColor(showFullDescription ? .primary : .secondary)
                                
                                Button(action: {
                                    withAnimation(.easeInOut) {
                                        showFullDescription.toggle()
                                    }
                                }) {
                                    Text(showFullDescription ? "Show Less" : "Read More")
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                }
                                
                            } else if let fullDesc = product.description, !fullDesc.isEmpty {
                                Text(fullDesc)
                                    .font(.body)
                            } else if let shortDesc = product.shortDescription, !shortDesc.isEmpty {
                                Text(shortDesc)
                                    .font(.body)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 30)
                    }
                }
                .navigationTitle("Product Detail")
                .navigationBarTitleDisplayMode(.inline)
                .safeAreaInset(edge: .bottom) {
                    VStack(spacing: 12) {
                        Divider()
                        
                        HStack {
                            Text("Quantity")
                                .font(.headline)
                            Spacer()
                            QuantityInputView(
                                quantity: $selectedQuantity,
                                maxStock: product.inventory?.quantityAvailable ?? 0
                            )
                        }
                        .padding(.horizontal)
                        
                        Button(action: {
                            Task {
                                isAddingToCart = true
                                let success = await cartViewModel.addToCart(
                                    product: product,
                                    quantity: selectedQuantity,
                                    customerID: sessionManager.customerID ?? "",
                                    token: sessionManager.token
                                )
                                isAddingToCart = false
                                if success {
                                    let generator = UINotificationFeedbackGenerator()
                                    generator.notificationOccurred(.success)
                                }
                            }
                        }) {
                            HStack {
                                if isAddingToCart {
                                    ProgressView().tint(.white)
                                } else {
                                    Text("Add to Cart")
                                }
                            }
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background((product.inventory?.quantityAvailable ?? 0) > 0 ? Color.accentColor : Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                        }
                        .disabled((product.inventory?.quantityAvailable ?? 0) == 0 || isAddingToCart)
                        .padding(.horizontal)
                        .padding(.bottom, 8)
                    }
                    .background(.regularMaterial)
                }
            }
        }
        .task {
            await fetchDetail()
        }
    }
    
    private func fetchDetail() async {
        isLoading = true
        errorMessage = nil
        do {
            product = try await repository.fetchProductDetail(id: productId)
            print("✅ Product detail loaded successfully: \(product?.name ?? "")")
        } catch {
            print("❌ Failed to fetch product detail error:")
            print(error)
            errorMessage = "Failed to fetch product detail: \(error.localizedDescription)"
        }
        isLoading = false
    }
    
    
}
