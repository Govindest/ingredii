import SwiftUI

struct PantryListView: View {
    @ObservedObject var viewModel: PantryViewModel
    @State private var showingAddItem = false

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.items) { item in
                    NavigationLink(destination: ItemDetailView(item: item)) {
                        Text("\(item.name) - \(item.quantity)")
                    }
                }
                .onDelete(perform: viewModel.removeItems)
            }
            .navigationTitle("Ingredii")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddItem = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddItem) {
                AddItemView { item in
                    viewModel.addItem(item)
                }
            }
        }
    }
}

struct PantryListView_Previews: PreviewProvider {
    static var previews: some View {
        PantryListView(viewModel: PantryViewModel())
    }
}
