import SwiftUI

struct PantryListView: View {
    var items: [PantryItem]

    var body: some View {
        List(items) { item in
            NavigationLink(destination: ItemDetailView(item: item)) {
                Text("\(item.name) - \(item.quantity)")
            }
        }
    }
}

struct PantryListView_Previews: PreviewProvider {
    static var previews: some View {
        PantryListView(items: [])
    }
}
