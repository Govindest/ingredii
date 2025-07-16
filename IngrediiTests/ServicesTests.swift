import XCTest
@testable import Ingredii

final class ServicesTests: XCTestCase {
    func testPersistenceSaveAndLoad() {
        let service = PersistenceService()
        let items = [PantryItem(name: "Tea", quantity: 1, expiry: nil)]
        service.save(items: items)
        let loaded = service.load()
        XCTAssertEqual(loaded.first?.name, "Tea")
    }
}

