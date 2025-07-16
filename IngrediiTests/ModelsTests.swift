import XCTest
@testable import Ingredii

final class ModelsTests: XCTestCase {
    func testPantryItemDecoding() throws {
        let json = "{""name"": ""Sugar"", ""quantity"":1}".data(using: .utf8)!
        let item = try JSONDecoder().decode(PantryItem.self, from: json)
        XCTAssertEqual(item.name, "Sugar")
    }
}

