//
//  ChartData.swift
//
//
//  Created by 賴柏宏 on 2024/1/13.
//

import Foundation

public struct ChartData: Codable, Equatable {
    public struct Split: Codable, Equatable {
        public let date: Date
        public let numerator: Double
        public let denominator: Double
        public let splitRatio: String

        public init(date: Date, numerator: Double, denominator: Double, splitRatio: String) {
            self.date = date
            self.numerator = numerator
            self.denominator = denominator
            self.splitRatio = splitRatio
        }
    }

    public struct MetaData: Codable, Equatable {
        public let currency: String
        public let symbol: String
        public let marketPrice: Double?
        public let previousClose: Double?
        public let gmtOffset: Int

        public init(currency: String, symbol: String, marketPrice: Double?, previousClose: Double?, gmtOffset: Int) {
            self.currency = currency
            self.symbol = symbol
            self.marketPrice = marketPrice
            self.previousClose = previousClose
            self.gmtOffset = gmtOffset
        }
    }

    public struct Indicator: Codable, Equatable {
        public let timestamp: Date
        public let open: Double
        public let high: Double
        public let low: Double
        public let close: Double

        public init(timestamp: Date, open: Double, high: Double, low: Double, close: Double) {
            self.timestamp = timestamp
            self.open = open
            self.high = high
            self.low = low
            self.close = close
        }
    }

    public let meta: MetaData
    public let indicators: [Indicator]
    public let splits: [Split]

    public init(meta: MetaData, indicators: [Indicator], splits: [Split] = []) {
        self.meta = meta
        self.indicators = indicators
        self.splits = splits
    }
}
