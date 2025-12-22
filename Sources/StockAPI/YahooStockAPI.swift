//
//  YahooStockAPI.swift
//
//
//  Created by 賴柏宏 on 2024/1/12.
//

import Foundation

enum YahooStockAPI: StockAPIProtocol {
    private static let API = YahooFinanceAPI()
    static func search(for ticker: String) async throws -> [Ticker] {
        try await API.searchTickers(query: ticker, isEquityTypeOnly: true).map {
           Ticker(
                symbol: $0.symbol,
                shortName: $0.shortname,
                longName: $0.longname,
                exchangeDisp: $0.exchDisp ?? "",
                quoteType: $0.quoteType ?? ""
            )
        }
    }

    static func chartData(for ticker: String, from: Date, to: Date, interval: ChartInterval) async throws -> ChartData? {
        let chartData = try await API.fetchChartData(
            symbol: ticker,
            from: from,
            to: to,
            interval: YahooModel.Interval(interval: interval)
        )
        return chartData?.toChartData()
    }
}

private extension YahooModel.ChartData {
    func toChartData() -> ChartData {
        ChartData(
            meta: ChartData.MetaData(
                currency: meta.currency,
                symbol: meta.symbol,
                marketPrice: meta.regularMarketPrice ?? indicators.last?.close,
                previousClose: indicators.count >= 2 ? indicators[indicators.count - 2].close : meta.previousClose,
                gmtOffset: meta.gmtoffset
            ),
            indicators: indicators.map {
                ChartData.Indicator(
                    timestamp: $0.timestamp,
                    open: $0.open,
                    high: $0.high,
                    low: $0.low,
                    close: $0.close
                )
            },
            splits: (events?.splits.map { Array($0.values) } ?? []).map {
                ChartData.Split(
                    date: $0.date,
                    numerator: $0.numerator,
                    denominator: $0.denominator,
                    splitRatio: $0.splitRatio
                )
            }
        )
    }
}
