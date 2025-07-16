import SwiftUI

struct AddItemView: View {
    @Environment(\.presentationMode) private var presentationMode
    @State private var name = ""
    @State private var quantity = 1
    @State private var expiry = Date()

    var onSave: (PantryItem) -> Void

    var body: some View {
        NavigationView {
            Form {
                TextField("Name", text: $name)
                Stepper(value: $quantity, in: 1...100) {
                    Text("Quantity: \(quantity)")
                }
                DatePicker("Expiry", selection: $expiry, displayedComponents: .date)
            }
            .navigationTitle("Add Item")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { presentationMode.wrappedValue.dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let item = PantryItem(name: name, quantity: quantity, expiry: expiry)
                        onSave(item)
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}

struct AddItemView_Previews: PreviewProvider {
    static var previews: some View {
        AddItemView { _ in }
    }
}
