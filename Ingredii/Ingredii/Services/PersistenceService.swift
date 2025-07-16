import Foundation

class PersistenceService {
    private let defaults = UserDefaults.standard

    func save(items: [PantryItem]) {
        if let data = try? JSONEncoder().encode(items) {
            defaults.set(data, forKey: "pantry_items")
        }
    }

    func load() -> [PantryItem] {
        if let data = defaults.data(forKey: "pantry_items"),
           let items = try? JSONDecoder().decode([PantryItem].self, from: data) {
            return items
        }
        return []
    }
}
