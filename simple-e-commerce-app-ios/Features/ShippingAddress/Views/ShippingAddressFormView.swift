import SwiftUI

struct ShippingAddressFormView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: ShippingAddressViewModel
    let editingAddress: CustomerAddressResponse?
    let token: String
    
    @State private var label = ""
    @State private var recipientName = ""
    @State private var recipientPhone = ""
    @State private var addressLine = ""
    @State private var city = ""
    @State private var state = ""
    @State private var postalCode = ""
    @State private var countryCode = "ID"
    @State private var isDefault = false
    
    @State private var showingDeleteConfirmation = false
    
    var body: some View {
        Form {
            Section("Contact Information") {
                TextField("Recipient Name", text: $recipientName)
                    .textContentType(.name)
                
                TextField("Phone Number", text: $recipientPhone)
                    .keyboardType(.phonePad)
                    .textContentType(.telephoneNumber)
            }
            
            Section("Address Details") {
                TextField("Address Label (e.g., Home)", text: $label)
                
                TextField("Street Address", text: $addressLine, axis: .vertical)
                    .lineLimit(2...4)
                    .textContentType(.fullStreetAddress)
                
                TextField("City", text: $city)
                    .textContentType(.addressCity)
                
                TextField("State / Province", text: $state)
                    .textContentType(.addressState)
                
                TextField("Postal Code", text: $postalCode)
                    .keyboardType(.numberPad)
                    .textContentType(.postalCode)
                
                TextField("Country Code", text: $countryCode)
            }
            
            Section {
                Toggle("Set as Default Address", isOn: $isDefault)
                    .tint(.accentColor)
            } footer: {
                Text("Default addresses are automatically selected during checkout.")
            }
            
            if let _ = editingAddress {
                Section {
                    Button(role: .destructive) {
                        showingDeleteConfirmation = true
                    } label: {
                        HStack {
                            Spacer()
                            Text("Delete Address")
                            Spacer()
                        }
                    }
                }
            }
        }
        .navigationTitle(editingAddress == nil ? "New Address" : "Edit Address")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") { dismiss() }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    saveAction()
                }
                .disabled(isFormIncomplete || viewModel.isLoading)
            }
        }
        .onAppear {
            populateFields()
        }
        .onChange(of: editingAddress) { _ in
            populateFields()
        }
        .alert(
            "Delete Address",
            isPresented: $showingDeleteConfirmation
        ) {
            Button("Cancel", role: .cancel) {}
            Button("Delete", role: .destructive) {
                deleteAction()
            }
        } message: {
            Text("Are you sure you want to delete this address?")
        }
    }
    
    private func populateFields() {
        if let addr = editingAddress {
            label = addr.label
            recipientName = addr.recipientName
            recipientPhone = addr.recipientPhone
            addressLine = addr.addressLine
            city = addr.city
            state = addr.state
            postalCode = addr.postalCode
            countryCode = addr.countryCode
            isDefault = addr.isDefault
        }
    }
    
    private var isFormIncomplete: Bool {
        label.isEmpty || recipientName.isEmpty || recipientPhone.isEmpty || addressLine.isEmpty || city.isEmpty || state.isEmpty || postalCode.isEmpty
    }
    
    private func saveAction() {
        let request = CreateCustomerAddressRequest(
            label: label, recipientName: recipientName, recipientPhone: recipientPhone,
            addressLine: addressLine, city: city, state: state,
            postalCode: postalCode, countryCode: countryCode, isDefault: isDefault
        )
        
        Task {
            let success = await viewModel.saveAddress(token: token, request: request, editingID: editingAddress?.id)
            if success { dismiss() }
        }
    }
    
    private func deleteAction() {
        guard let id = editingAddress?.id else { return }
        Task {
            let success = await viewModel.deleteAddress(token: token, id: id)
            if success { dismiss() }
        }
    }
}
