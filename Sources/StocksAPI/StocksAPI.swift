

import Foundation

public enum ChartTimeRange {
    case day(Int)
    case month(Double)
    case year(Double)

    fileprivate var timeIntervalSinceToday: TimeInterval {
        switch self {
        case let .year(year):
            return year * 365 * 24 * 3600
        case let .month(month):
            return month * 31 * 24 * 3600
        case let .day(day):
            return Double(day) * 24 * 3600
        }
    }
}

public enum ChartInterval {
    case oneDay
    case oneWeek
    case oneMonth
}

protocol StocksAPIProtocol {
    func search(for ticker: String) async throws -> [Ticker]
    func chartData(for ticker: String, from: Date, to: Date, interval: ChartInterval) async throws -> ChartData?
}

public final class StocksAPI {
    public static let yahoo: StocksAPI = StocksAPI(type: .yahoo)

    enum APIType {
        case yahoo
    }

    let api: any StocksAPIProtocol

    private init(type: APIType) {
        api = YahooStocksAPI.shared
    }

    public func search(for ticker: String) async throws -> [Ticker] {
        try await api.search(for: ticker)
    }

    public func chartData(
        for ticker: String,
        timeRange: ChartTimeRange = .year(20),
        interval: ChartInterval = .oneDay
    ) async throws -> ChartData? {
        let today = Date()
        return try await api.chartData(
            for: ticker,
            from: today.addingTimeInterval(-timeRange.timeIntervalSinceToday),
            to: today,
            interval: interval
        )
    }

}
