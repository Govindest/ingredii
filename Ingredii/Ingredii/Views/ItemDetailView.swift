import SwiftUI

struct ItemDetailView: View {
    var item: PantryItem

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(item.name).font(.largeTitle)
            Text("Quantity: \(item.quantity)")
            if let expiry = item.expiry {
                Text("Expires on: \(expiry.formatted(date: .abbreviated, time: .omitted))")
            } else {
                Text("No expiry date")
            }
            Spacer()
        }
        .padding()
    }
}

struct ItemDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ItemDetailView(item: PantryItem(name: "Sugar", quantity: 1, expiry: nil))
    }
}
