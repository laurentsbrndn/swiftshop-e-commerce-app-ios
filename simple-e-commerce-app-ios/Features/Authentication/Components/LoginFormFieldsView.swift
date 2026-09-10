//
//  LoginFormFieldsView.swift
//  simple-e-commerce-app-ios
//
//  Created by Laurentius Brandon Vikario on 03/09/26.
//

import SwiftUI

struct LoginFormFieldsView: View {
    @Binding var email: String
    @Binding var password: String
    var isLoading: Bool
    var onForgotPassword: () -> Void

    @State private var isPasswordVisible: Bool = false
    @FocusState private var focusedField: Field?

    private enum Field {
        case email, password
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Welcome back")
                    .font(.title2)
                    .fontWeight(.semibold)

                Text("Sign in to continue shopping with SwiftShop.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            VStack(spacing: 16) {
                HStack(spacing: 12) {
                    Image(systemName: "envelope")
                        .foregroundStyle(.secondary)
                        .frame(width: 20)

                    TextField("Email", text: $email)
                        .textContentType(.emailAddress)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .focused($focusedField, equals: .email)
                        .submitLabel(.next)
                        .onSubmit { focusedField = .password }
                }
                .padding(12)
                .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                .disabled(isLoading)

                HStack(spacing: 12) {
                    Image(systemName: "lock")
                        .foregroundStyle(.secondary)
                        .frame(width: 20)

                    Group {
                        if isPasswordVisible {
                            TextField("Password", text: $password)
                        } else {
                            SecureField("Password", text: $password)
                        }
                    }
                    .textContentType(.password)
                    .focused($focusedField, equals: .password)
                    .submitLabel(.go)

                    Button {
                        isPasswordVisible.toggle()
                    } label: {
                        Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                            .foregroundStyle(.secondary)
                    }
                    .accessibilityLabel(isPasswordVisible ? "Hide password" : "Show password")
                }
                .padding(12)
                .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                .disabled(isLoading)

                HStack {
                    Spacer()
                    Button("Forgot Password?", action: onForgotPassword)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                        .disabled(isLoading)
                }
            }
        }
    }
}

#Preview {
    LoginFormFieldsView(
        email: .constant(""),
        password: .constant(""),
        isLoading: false,
        onForgotPassword: {}
    )
    .padding()
}
