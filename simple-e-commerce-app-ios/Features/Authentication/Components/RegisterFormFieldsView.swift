//
//  RegisterFormFieldsView.swift
//  simple-e-commerce-app-ios
//
//  Created by Laurentius Brandon Vikario on 04/09/26.
//

import SwiftUI

struct RegisterFormFieldsView: View {
    @Binding var firstName: String
    @Binding var lastName: String
    @Binding var phoneNumber: String
    @Binding var email: String
    @Binding var password: String
    var isLoading: Bool

    @State private var isPasswordVisible: Bool = false
    @FocusState private var focusedField: Field?

    private enum Field {
        case firstName, lastName, phone, email, password
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Create Account")
                    .font(.title2)
                    .fontWeight(.semibold)

                Text("Sign up to start shopping with SwiftShop.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            VStack(spacing: 16) {
                HStack(spacing: 12) {
                    Image(systemName: "person")
                        .foregroundStyle(.secondary)
                        .frame(width: 20)

                    TextField("First Name", text: $firstName)
                        .textContentType(.givenName)
                        .focused($focusedField, equals: .firstName)
                        .submitLabel(.next)
                        .onSubmit { focusedField = .lastName }
                }
                .padding(12)
                .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                .disabled(isLoading)

                HStack(spacing: 12) {
                    Image(systemName: "person.fill")
                        .foregroundStyle(.secondary)
                        .frame(width: 20)

                    TextField("Last Name", text: $lastName)
                        .textContentType(.familyName)
                        .focused($focusedField, equals: .lastName)
                        .submitLabel(.next)
                        .onSubmit { focusedField = .phone }
                }
                .padding(12)
                .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                .disabled(isLoading)

                HStack(spacing: 12) {
                    Image(systemName: "phone")
                        .foregroundStyle(.secondary)
                        .frame(width: 20)

                    TextField("Phone Number (Optional)", text: $phoneNumber)
                        .textContentType(.telephoneNumber)
                        .keyboardType(.phonePad)
                        .focused($focusedField, equals: .phone)
                        .submitLabel(.next)
                        .onSubmit { focusedField = .email }
                }
                .padding(12)
                .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                .disabled(isLoading)

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

                    ZStack(alignment: .leading) {
                        TextField("Password", text: $password)
                            .opacity(isPasswordVisible ? 1 : 0)
                            .disabled(!isPasswordVisible)

                        SecureField("Password", text: $password)
                            .opacity(isPasswordVisible ? 0 : 1)
                            .disabled(isPasswordVisible)
                    }
                    .textContentType(.newPassword)
                    .focused($focusedField, equals: .password)
                    .submitLabel(.done)

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
            }
        }
    }
}

#Preview {
    RegisterFormFieldsView(
        firstName: .constant(""),
        lastName: .constant(""),
        phoneNumber: .constant(""),
        email: .constant(""),
        password: .constant(""),
        isLoading: false
    )
    .padding()
}
