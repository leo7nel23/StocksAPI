//
//  Chart.swift
//  
//
//  Created by Le Bon B' Bauma on 28/02/2023.
//

import Foundation

extension YahooModel {
    struct ChartResponse: Decodable {

        let data: [YahooModel.ChartData]?
        let error: ErrorResponse?

        enum CodingKeys: CodingKey {
            case chart
        }

        enum ChartKeys: CodingKey {
            case result
            case error
        }

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            if let chartContainer = try? container.nestedContainer(keyedBy: ChartKeys.self, forKey: .chart) {
                data = try? chartContainer.decodeIfPresent([YahooModel.ChartData].self, forKey: .result)
                error = try? chartContainer.decodeIfPresent(ErrorResponse.self, forKey: .error)
            } else {
                data = nil
                error = nil

            }

        }

        init(data: [ChartData]?, error: ErrorResponse?) {
            self.data = data
            self.error = error
        }
    }

    struct ChartData: Decodable {
        let meta: YahooModel.ChartMeta
        let indicators: [Indicator]

        enum CodingKeys: CodingKey {
            case meta
            case timestamp
            case indicators
        }

        enum IndicatorKeys: CodingKey {
            case quote
        }

        enum QuoteKeys: CodingKey {
            case close
            case high
            case low
            case open
        }

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            meta = try container.decode(YahooModel.ChartMeta.self, forKey: .meta)

            let timestamps = try container.decodeIfPresent([Date].self, forKey: .timestamp) ?? []

            if let indicatorsContainer = try? container.nestedContainer(keyedBy: IndicatorKeys.self, forKey: .indicators),
               var quotes = try? indicatorsContainer.nestedUnkeyedContainer(forKey: .quote),
               let quoteContainer = try? quotes.nestedContainer(keyedBy: QuoteKeys.self) {

                let highs = try quoteContainer.decodeIfPresent([Double?].self, forKey: .high) ?? []
                let lows = try quoteContainer.decodeIfPresent([Double?].self, forKey: .low) ?? []
                let opens = try quoteContainer.decodeIfPresent([Double?].self, forKey: .open) ?? []
                let closes = try quoteContainer.decodeIfPresent([Double?].self, forKey: .close) ?? []

                indicators = timestamps.enumerated().compactMap { (offset, timestamp) in
                    guard
                        let open = opens[offset],
                        let low = lows[offset],
                        let close = closes[offset],
                        let high = highs[offset]
                    else { return nil }
                    return .init(timestamp: timestamp, open: open, high: high, low: low, close: close)
                }
            } else {
                self.indicators = []
            }
        }
        init(meta: YahooModel.ChartMeta, indicators: [Indicator]) {
            self.meta = meta
            self.indicators = indicators
        }
    }



    struct ChartMeta: Decodable {
        let currency: String
        let symbol: String
        let regularMarketPrice: Double?
        let previousClose: Double?
        let gmtoffset: Int
        let regularTradingPeriodStartDate: Date
        let regularTradingPeriodEndDate: Date

        enum CodingKeys: CodingKey {
            case currency
            case symbol
            case regularMarketPrice
            case previousClose
            case gmtoffset
            case currentTraidingPeriod
        }

        enum CurrentTraidingKeys: CodingKey {
            case pre
            case regular
            case post
        }

        enum TraidingPeriodKeys: CodingKey {
            case start
            case end
        }

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.currency = try container.decodeIfPresent(String.self, forKey: .currency) ?? ""
            self.symbol = try container.decodeIfPresent(String.self, forKey: .symbol) ?? ""
            self.regularMarketPrice = try container.decodeIfPresent(Double.self, forKey: .regularMarketPrice)
            self.previousClose = try container.decodeIfPresent(Double.self, forKey: .previousClose)
            self.gmtoffset = try container.decodeIfPresent(Int.self, forKey: .gmtoffset) ?? 0

            let currentTraidingPeriodContainer = try? container.nestedContainer(keyedBy: CurrentTraidingKeys.self, forKey: .currentTraidingPeriod)

            let regularTradingPeriodContainer = try? currentTraidingPeriodContainer?.nestedContainer(keyedBy: TraidingPeriodKeys.self, forKey: .regular)

            self.regularTradingPeriodStartDate = try regularTradingPeriodContainer?.decodeIfPresent(Date.self, forKey: .start) ?? Date()

            self.regularTradingPeriodEndDate = try regularTradingPeriodContainer?.decodeIfPresent(Date.self, forKey: .end) ?? Date()
        }

    }

    struct Indicator: Codable {
        let timestamp: Date
        let open: Double
        let high: Double
        let low: Double
        let close: Double
    }
}
