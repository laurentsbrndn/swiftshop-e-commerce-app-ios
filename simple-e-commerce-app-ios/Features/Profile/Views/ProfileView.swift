import SwiftUI

struct ProfileView: View {
    @EnvironmentObject private var sessionManager: SessionManager
    @State private var showLogoutAlert = false
    
    private var customerName: String {
        if let name = sessionManager.currentCustomer?.firstName, !name.isEmpty {
            return name
        }
        return "Pengguna"
    }
    
    private var customerEmail: String {
        sessionManager.currentCustomer?.email ?? "Tidak ada email"
    }
    
    private var initials: String {
        let trimmed = customerName.trimmingCharacters(in: .whitespacesAndNewlines)
        if let first = trimmed.first {
            return String(first).uppercased()
        }
        return "U"
    }
    
    var body: some View {
        List {
            Section {
                HStack(spacing: 16) {
                    Circle()
                        .fill(Color.accentColor.opacity(0.15))
                        .frame(width: 64, height: 64)
                        .overlay(
                            Text(initials)
                                .font(.title2.weight(.bold))
                                .foregroundStyle(Color.accentColor)
                        )
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(customerName)
                            .font(.title3.weight(.bold))
                        
                        Text(customerEmail)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        
                        if let customerID = sessionManager.currentCustomer?.customerID {
                            Text("ID: \(customerID.prefix(8))...")
                                .font(.caption2)
                                .foregroundStyle(.tertiary)
                        }
                    }
                }
                .padding(.vertical, 8)
            }
            
            Section("Account") {
                NavigationLink {
                    ShippingAddressView()
                } label: {
                    Label("Shipping Address", systemImage: "mappin.and.ellipse")
                }
            }
            
            Section("Information") {
                NavigationLink {
                    PrivacyPolicyView()
                } label: {
                    Label("Privacy Policy", systemImage: "hand.raised")
                }
                
                NavigationLink {
                    TermsAndConditionView()
                } label: {
                    Label("Terms and Condition", systemImage: "doc.text")
                }
                
                HStack {
                    Text("Application Version")
                    Spacer()
                    Text("1.0.0")
                        .foregroundStyle(.secondary)
                }
            }
            
            Section {
                Button(role: .destructive) {
                    showLogoutAlert = true
                } label: {
                    Text("Logout")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Profile")
        .alert("Logout", isPresented: $showLogoutAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Logout", role: .destructive) {
                Task {
                    await sessionManager.logout()
                }
            }
        } message: {
            Text("Are you sure you want to log out of your account?")
        }
    }
}
