//
//  SignInButtonView.swift
//  simple-e-commerce-app-ios
//
//  Created by Laurentius Brandon Vikario on 03/09/26.
//

import SwiftUI

struct SignInButtonView: View {
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
                    Text("Sign In")
                        .fontWeight(.semibold)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
        }
        .buttonStyle(.borderedProminent)
        .disabled(isDisabled || isLoading)
        .accessibilityLabel(isLoading ? "Signing in" : "Sign In")
    }
}

#Preview {
    VStack(spacing: 16) {
        SignInButtonView(isLoading: false, isDisabled: false, action: {})
        SignInButtonView(isLoading: false, isDisabled: true, action: {})
        SignInButtonView(isLoading: true, isDisabled: false, action: {})
    }
    .padding()
}
