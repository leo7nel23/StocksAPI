//
//  Ticker.swift
//  
//
//  Created by Le Bon B' Bauma on 28/02/2023.
//

import Foundation

extension YahooModel {
    struct SearchTickerResponse: Decodable {
        let data: [YahooModel.Ticker]?
        let error: ErrorResponse?

        enum CodingKeys: CodingKey {
            case quotes
            case finance
        }

        enum FinanceKeys : CodingKey {
            case error
        }

        init(from decoder: Decoder) throws {
            let conatiner = try decoder.container(keyedBy: CodingKeys.self)
            data = try conatiner.decodeIfPresent([YahooModel.Ticker].self, forKey: .quotes)
            error = try? conatiner.nestedContainer(keyedBy: FinanceKeys.self , forKey: .finance)
                .decodeIfPresent(ErrorResponse.self, forKey: .error)
        }
    }

    struct Ticker: Codable, Equatable {
        let symbol: String
        let quoteType: String?
        let shortname: String?
        let longname: String?
        let sector: String?
        let industry: String?
        let exchDisp: String?
    }
}
