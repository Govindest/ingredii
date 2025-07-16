import Foundation

class PantryViewModel: ObservableObject {
    @Published var items: [PantryItem] = []

    func loadSampleData() {
        if let url = Bundle.main.url(forResource: "sample_inventory", withExtension: "json"),
           let data = try? Data(contentsOf: url),
           let sampleItems = try? JSONDecoder().decode([PantryItem].self, from: data) {
            items = sampleItems
        }
    }
}
