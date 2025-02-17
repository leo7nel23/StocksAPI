//
//  Ticker.swift
//
//
//  Created by 賴柏宏 on 2024/1/12.
//

import Foundation

public struct Ticker: Sendable, Codable, Hashable, Equatable, Identifiable {
    public var id: String { symbol }
    
    public let symbol: String
    public let shortName: String?
    public let longName: String?
    public let exchangeDisp: String
    public let quoteType: String
    
    public init(
        symbol: String,
        shortName: String?,
        longName: String?,
        exchangeDisp: String,
        quoteType: String
    ) {
        self.symbol = symbol
        self.shortName = shortName
        self.longName = longName
        self.exchangeDisp = exchangeDisp
        self.quoteType = quoteType
    }
}
