import Foundation

class PantryViewModel: ObservableObject {
    @Published var items: [PantryItem] = []
    private let persistenceService = PersistenceService()

    init() {
        load()
    }

    func load() {
        items = persistenceService.load()
        if items.isEmpty {
            loadSampleData()
        }
    }

    func loadSampleData() {
        if let url = Bundle.main.url(forResource: "sample_inventory", withExtension: "json"),
           let data = try? Data(contentsOf: url),
           let sampleItems = try? JSONDecoder().decode([PantryItem].self, from: data) {
            items = sampleItems
            save()
        }
    }

    func addItem(_ item: PantryItem) {
        items.append(item)
        save()
    }

    func addItem(name: String, quantity: Int, expiry: Date?) {
        let newItem = PantryItem(name: name, quantity: quantity, expiry: expiry)
        addItem(newItem)
    }

    func removeItems(at offsets: IndexSet) {
        items.remove(atOffsets: offsets)
        save()
    }

    func save() {
        persistenceService.save(items: items)
    }
}
