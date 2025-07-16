import Foundation

class PersistenceService {
    private let defaults = UserDefaults.standard

    func save(items: [PantryItem]) {
        if let data = try? JSONEncoder().encode(items) {
            defaults.set(data, forKey: AppConstants.itemsKey)
        }
    }

    func load() -> [PantryItem] {
        if let data = defaults.data(forKey: AppConstants.itemsKey),
           let items = try? JSONDecoder().decode([PantryItem].self, from: data) {
            return items
        }
        return []
    }
}
