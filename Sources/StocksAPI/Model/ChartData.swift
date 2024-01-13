//
//  ChartData.swift
//
//
//  Created by 賴柏宏 on 2024/1/13.
//

import Foundation

public struct ChartData: Equatable {
    public struct MetaData: Equatable {
        public let currency: String
        public let symbol: String
        public let marketPrice: Double?
        public let previousClose: Double?
        public let gmtOffset: Int
    }

    public struct Indicator: Equatable {
        public let timestamp: Date
        public let open: Double
        public let high: Double
        public let low: Double
        public let close: Double
    }

    public let meta: MetaData
    public let indicators: [Indicator]
}
