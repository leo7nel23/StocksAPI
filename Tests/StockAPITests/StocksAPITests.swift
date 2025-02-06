import XCTest
@testable import StocksAPI

final class StocksAPITests: XCTestCase {
    func testSearch() async throws {
        let searchResult = try await StocksAPI.yahoo.search(for: "AAPL")

        XCTAssertEqual(searchResult.first?.symbol, "AAPL")
    }

    func testFetchChart() async throws {
        let chartResult = try await StocksAPI.yahoo.chartData(for: "NVDA")
        XCTAssertEqual(chartResult?.meta.currency, "USD")
        XCTAssertEqual(chartResult?.meta.symbol, "NVDA")
    }

  func test123() async throws {
    let quote = try await StocksAPI.yahoo.test()
    print(quote)
  }
}
