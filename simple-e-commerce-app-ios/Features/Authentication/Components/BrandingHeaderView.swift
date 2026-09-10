//
//  BrandingHeaderView.swift
//  simple-e-commerce-app-ios
//
//  Created by Laurentius Brandon Vikario on 03/09/26.
//

import SwiftUI

struct BrandingHeaderView: View {
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: "bag.fill")
                .font(.title2)
                .foregroundStyle(.tint)
                .accessibilityHidden(true)

            Text("SwiftShop")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundStyle(.primary)

            Text("Everything you need, in one place.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .multilineTextAlignment(.center)
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    BrandingHeaderView()
        .padding()
}
