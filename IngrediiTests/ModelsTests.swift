import XCTest
@testable import Ingredii

final class ModelsTests: XCTestCase {
    func testPantryItemDecoding() throws {
        let json = "{""name"": ""Sugar"", ""quantity"":1}".data(using: .utf8)!
        let item = try JSONDecoder().decode(PantryItem.self, from: json)
        XCTAssertEqual(item.name, "Sugar")
    }
    func testPantryItemDecodesExpiryString() throws {
        let json = "{\"name\":\"Flour\",\"quantity\":1,\"expiry\":\"2030-12-31\"}".data(using: .utf8)!
        let item = try JSONDecoder().decode(PantryItem.self, from: json)
        let comps = Calendar.current.dateComponents([.year, .month, .day], from: item.expiry!)
        XCTAssertEqual(comps.year, 2030)
        XCTAssertEqual(comps.month, 12)
        XCTAssertEqual(comps.day, 31)
    }
}


