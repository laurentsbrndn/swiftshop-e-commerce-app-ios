//
//  SignUpPromptView.swift
//  simple-e-commerce-app-ios
//
//  Created by Laurentius Brandon Vikario on 03/09/26.
//

import SwiftUI

struct SignUpPromptView: View {
    var isLoading: Bool
    var action: () -> Void

    var body: some View {
        HStack(spacing: 4) {
            Text("Don't have an account?")
                .font(.footnote)
                .foregroundStyle(.secondary)

            Button("Sign Up", action: action)
                .font(.footnote)
                .fontWeight(.semibold)
                .disabled(isLoading)
        }
    }
}

#Preview {
    SignUpPromptView(isLoading: false, action: {})
}
