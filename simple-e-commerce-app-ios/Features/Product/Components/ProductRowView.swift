//
//  ProductRowView.swift
//  simple-e-commerce-app-ios
//
//  Created by Laurentius Brandon Vikario on 03/09/26.
//

import SwiftUI

struct ProductRowView: View {
    let product: Product

    private var imageURL: URL? {
        guard let urlString = product.images.first?.imageURL else {
            return nil
        }
        return URL(string: urlString)
    }

    var body: some View {
        HStack(spacing: 16) {

            AsyncImage(url: imageURL) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                case .failure:
                    Image(systemName: "photo")
                        .font(.title2)
                        .foregroundStyle(.secondary)
                @unknown default:
                    Image(systemName: "photo")
                        .font(.title2)
                        .foregroundStyle(.secondary)
                }
            }
            .frame(width: 72, height: 72)
            .background(Color(.secondarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 10))

            VStack(alignment: .leading, spacing: 4) {

                Text(product.name)
                    .font(.headline)
                    .lineLimit(2)

                if let category = product.category {
                    Text(category.name)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                Text(
                    product.price,
                    format: .currency(code: product.currency)
                )
                .font(.subheadline)
                .foregroundStyle(.secondary)
                
                if let inventory = product.inventory {
                    Text("Stock: \(inventory.quantityAvailable)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }

            Spacer()
            
        }
        .padding(.vertical, 8)
    }
}
