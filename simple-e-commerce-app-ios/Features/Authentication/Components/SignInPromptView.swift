//
//  SignInPromptView.swift
//  simple-e-commerce-app-ios
//
//  Created by Laurentius Brandon Vikario on 04/09/26.
//

import SwiftUI
struct SignInPromptView: View {
    var isLoading: Bool
    var action: () -> Void

    var body: some View {
        HStack(spacing: 4) {
            Text("Already have an account?")
                .font(.footnote)
                .foregroundStyle(.secondary)

            Button("Sign In", action: action)
                .font(.footnote)
                .fontWeight(.semibold)
                .disabled(isLoading)
        }
    }
}

#Preview {
    SignInPromptView(isLoading: false, action: {})
}
