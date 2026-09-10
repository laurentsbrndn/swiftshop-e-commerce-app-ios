//
//  LoginView.swift
//  simple-e-commerce-app-ios
//
//  Created by Laurentius Brandon Vikario on 03/09/26.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject private var sessionManager: SessionManager
    @StateObject private var viewModel = AuthViewModel()
    @State private var showRegister = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 32) {
                    BrandingHeaderView()
                        .padding(.top, 40)

                    LoginFormFieldsView(
                        email: $viewModel.email,
                        password: $viewModel.password,
                        isLoading: viewModel.isLoading,
                        onForgotPassword: {
                            // TODO: hook up forgot password flow
                        }
                    )

                    if let errorMessage = viewModel.errorMessage {
                        Text(errorMessage)
                            .font(.footnote)
                            .foregroundStyle(.red)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .accessibilityLabel("Error: \(errorMessage)")
                    }

                    VStack(spacing: 20) {
                        SignInButtonView(
                            isLoading: viewModel.isLoading,
                            isDisabled: viewModel.email.isEmpty || viewModel.password.isEmpty,
                            action: {
                                Task {
                                    if let response = await viewModel.login() {
                                        sessionManager.login(response: response)
                                    }
                                }
                            }
                        )

                        SignUpPromptView(
                            isLoading: viewModel.isLoading,
                            action: {
                                showRegister = true
                            }
                        )
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 24)
            }
            .scrollDismissesKeyboard(.interactively)
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(isPresented: $showRegister) {
                RegisterView()
            }
        }
    }
}

#Preview {
    LoginView()
        .environmentObject(SessionManager())
}
