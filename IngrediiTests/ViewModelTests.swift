import XCTest
@testable import Ingredii

final class ViewModelTests: XCTestCase {
    func testLoadSampleData() {
        let viewModel = PantryViewModel()
        viewModel.loadSampleData()
        XCTAssertFalse(viewModel.items.isEmpty)
    }
}
