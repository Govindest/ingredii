import XCTest
@testable import Ingredii

final class ViewModelTests: XCTestCase {
    func testLoadSampleData() {
        let viewModel = PantryViewModel()
        viewModel.loadSampleData()
        XCTAssertFalse(viewModel.items.isEmpty)
    }

    func testAddItem() {
        let viewModel = PantryViewModel()
        let initialCount = viewModel.items.count
        viewModel.addItem(name: "Test", quantity: 1, expiry: nil)
        XCTAssertEqual(viewModel.items.count, initialCount + 1)
    }
}
