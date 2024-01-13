//
//  Quote.swift
//  
//
//  Created by Le Bon B' Bauma on 28/02/2023.
//

import Foundation

extension YahooModel {
    struct QuoteResponse: Decodable {
        
        let data: [YahooModel.Quote]?
        let error: ErrorResponse?
        
        enum CodingKeys: CodingKey {
            case quoteResponse
            case finance
        }
        
        enum ResponseKeys: CodingKey {
            case result
            case error
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            if let quoteResponseContainer = try? container.nestedContainer(keyedBy: ResponseKeys.self, forKey: .quoteResponse) {
                self.data = try? quoteResponseContainer.decodeIfPresent([YahooModel.Quote].self, forKey: .result)
                self.error = try? quoteResponseContainer.decodeIfPresent(ErrorResponse.self, forKey: .error)
            } else if let financeResponseContainer = try? container.nestedContainer(keyedBy: ResponseKeys.self, forKey: .finance) {
                self.data = nil
                self.error = try? financeResponseContainer.decodeIfPresent(ErrorResponse.self, forKey: .error)
            } else {
                self.data = nil
                self.error = nil
            }
        }
    }
    
    struct Quote: Decodable, Hashable {
        let symbol: String
        
        let currency: String?
        let marketState: String?
        
        let fullExchangeName: String?
        let displayName: String?
        
        let regularMarketPrice: Double?
        let regularMarketChange: Double?
        let regularMarketChangePercent: Double?
        let regularMarketChangePreviousClose: Double?
        let regularMarketTime: Date?
        
        let postMarketPrice: Double?
        let postMarketChange: Double?
        
        let regularMarketOpen: Double?
        let regularMarketDayHigh: Double?
        let regularMarketDayLow: Double?
        
        let regularMarketVolume: Double?
        let trailingPE: Double?
        let marketCap: Double?
        
        let fiftyTwoWeekLow: Double?
        let fiftyTwoWeekHigh: Double?
        let averageDailyVolume3Month: Double?
        
        let trailingAnnualDividendYield: Double?
        let epsTrailingTwelveMonths: Double?
    }
}
