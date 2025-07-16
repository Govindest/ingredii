import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = PantryViewModel()

    var body: some View {
        PantryListView(viewModel: viewModel)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
