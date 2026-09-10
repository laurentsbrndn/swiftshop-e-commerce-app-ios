//
//  RegisterButtonView 2.swift
//  simple-e-commerce-app-ios
//
//  Created by Laurentius Brandon Vikario on 04/09/26.
//

import SwiftUI

struct RegisterButtonView: View {
    var isLoading: Bool
    var isDisabled: Bool
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Group {
                if isLoading {
                    ProgressView()
                        .tint(.white)
                } else {
                    Text("Sign Up")
                        .fontWeight(.semibold)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
        }
        .buttonStyle(.borderedProminent)
        .disabled(isDisabled || isLoading)
        .accessibilityLabel(isLoading ? "Signing up" : "Sign Up")
    }
}

#Preview {
    VStack(spacing: 16) {
        RegisterButtonView(isLoading: false, isDisabled: false, action: {})
        RegisterButtonView(isLoading: false, isDisabled: true, action: {})
        RegisterButtonView(isLoading: true, isDisabled: false, action: {})
    }
    .padding()
}
