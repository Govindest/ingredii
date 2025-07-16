import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = PantryViewModel()

    var body: some View {
        NavigationView {
            PantryListView(items: viewModel.items)
                .navigationTitle("Ingredii")
        }
        .onAppear {
            viewModel.loadSampleData()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
