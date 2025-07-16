import Foundation

struct PantryItem: Identifiable, Codable {
    let id = UUID()
    var name: String
    var quantity: Int
    var expiry: Date?
}
