import Foundation

struct PantryItem: Identifiable, Codable {
    /// Unique identifier for the pantry item. When decoding from JSON the `id`
    /// field is optional so a new identifier will be generated if one is not
    /// provided.
    var id: UUID = UUID()

    /// Display name for the ingredient.
    var name: String

    /// Quantity the user currently has in their pantry.
    var quantity: Int

    /// Optional expiry date stored using a short `yyyy-MM-dd` format in JSON.
    var expiry: Date?

    /// Keys used when encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case id, name, quantity, expiry
    }

    init(id: UUID = UUID(), name: String, quantity: Int, expiry: Date?) {
        self.id = id
        self.name = name
        self.quantity = quantity
        self.expiry = expiry
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = (try? container.decode(UUID.self, forKey: .id)) ?? UUID()
        name = try container.decode(String.self, forKey: .name)
        quantity = try container.decode(Int.self, forKey: .quantity)

        if let expiryString = try? container.decode(String.self, forKey: .expiry) {
            expiry = Date.from(string: expiryString)
        } else {
            expiry = try? container.decode(Date.self, forKey: .expiry)
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(quantity, forKey: .quantity)

        if let expiry = expiry {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            let dateString = formatter.string(from: expiry)
            try container.encode(dateString, forKey: .expiry)
        }
    }
}
