//
//  RegisterView.swift
//  simple-e-commerce-app-ios
//
//  Created by Laurentius Brandon Vikario on 03/09/26.
//

import SwiftUI

struct RegisterView: View {
    @StateObject private var viewModel = RegisterViewModel()
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                BrandingHeaderView()
                    .padding(.top, 40)

                RegisterFormFieldsView(
                    firstName: $viewModel.firstName,
                    lastName: $viewModel.lastName,
                    phoneNumber: $viewModel.phoneNumber,
                    email: $viewModel.email,
                    password: $viewModel.password,
                    isLoading: viewModel.isLoading
                )

                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .font(.footnote)
                        .foregroundStyle(.red)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .accessibilityLabel("Error: \(errorMessage)")
                }

                VStack(spacing: 20) {
                    RegisterButtonView(
                        isLoading: viewModel.isLoading,
                        isDisabled: !viewModel.isFormValid,
                        action: {
                            Task { await viewModel.register() }
                        }
                    )

                    SignInPromptView(
                        isLoading: viewModel.isLoading,
                        action: {
                            dismiss()
                        }
                    )
                }
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 24)
        }
        .scrollDismissesKeyboard(.interactively)
        .navigationBarBackButtonHidden(true)
        .onChange(of: viewModel.isRegistered) { newValue in
            if newValue {
                dismiss()
            }
        }
    }
}

#Preview {
    NavigationStack {
        RegisterView()
    }
}
