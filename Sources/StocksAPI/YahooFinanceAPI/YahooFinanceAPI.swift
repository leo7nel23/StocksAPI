//
//  YahooFinanceAPI.swift
//
//
//  Created by 賴柏宏 on 2024/1/12.
//

import Foundation

struct YahooFinanceAPI {
    private let session = URLSession.shared
    private let jsonDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        return decoder
    }()

    private let baseURL = "https://query1.finance.yahoo.com"
    init() {}


    func fetchChartData(
        symbol: String,
        from: Date,
        to: Date,
        interval: YahooModel.Interval
    ) async throws -> YahooModel.ChartData? {
        guard var urlComponents = URLComponents(string:  "\(baseURL)/v8/finance/chart/\(symbol)") else {
            throw StocksAPIError.invalidURL
        }
        urlComponents.queryItems = [
            .init(name: "interval", value: interval.rawValue),
            .init(name: "indicators", value: "quote"),
            .init(name: "includeTimestamps", value: "true"),
            .init(name: "period1", value: "\(Int(from.timeIntervalSince1970))"),
            .init(name: "period2", value: "\(Int(to.timeIntervalSince1970))")
        ]
        guard let url = urlComponents.url else {
            throw StocksAPIError.invalidURL
        }

        let (response, statusCode): (YahooModel.ChartResponse, Int) = try await fetch(url: url)
        if let error = response.error {
            throw StocksAPIError.httpStatusCodeFailed(statusCode: statusCode, error: error )
        }
        return response.data?.first
    }
  
    func searchTickers(query: String, isEquityTypeOnly: Bool = false) async throws -> [YahooModel.Ticker] {
        guard var urlComponents = URLComponents(string:  "\(baseURL)/v1/finance/search") else {
            throw StocksAPIError.invalidURL
        }
        urlComponents.queryItems = [
            .init(name: "q", value: query),
            .init(name: "quotesCount", value: "20"),
            .init(name: "lang", value: "en-US")
        ]
        guard let url = urlComponents.url else {
            throw StocksAPIError.invalidURL
        }

        let (response, statusCode): (YahooModel.SearchTickerResponse, Int) = try await fetch(url: url)
        if let error = response.error {
            throw StocksAPIError.httpStatusCodeFailed(statusCode: statusCode, error: error)
        }

        if isEquityTypeOnly {
            return (response.data ?? [])
                .filter{ ($0.quoteType ?? "").localizedCaseInsensitiveCompare("equity") == .orderedSame }
        } else {
            return response.data ?? []
        }
    }

    func fetchQuotes(symbols: String) async throws -> [YahooModel.Quote] {
        guard var urlComponents = URLComponents(string:  "\(baseURL)/v7/finance/quote") else {
            throw StocksAPIError.invalidURL
        }
        urlComponents.queryItems = [.init(name: "symbols", value: symbols)]
        guard let url = urlComponents.url else {
            throw StocksAPIError.invalidURL
        }

        let (response, statusCode): (YahooModel.QuoteResponse, Int) = try await fetch(url: url)
        if let error = response.error {
            throw StocksAPIError.httpStatusCodeFailed(statusCode: statusCode, error: error)
        }
        return response.data ?? []
    }



    private func fetch<D: Decodable>(url: URL) async throws -> (D, Int) {
        let (data, response) = try await session.data(from: url)
        let statusCode = try validateHTTPResponse(response)
        return(try jsonDecoder.decode(D.self, from: data), statusCode)
    }

    private func validateHTTPResponse(_ response: URLResponse) throws -> Int {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw StocksAPIError.invalidResponseType
        }

        guard 200...299 ~= httpResponse.statusCode ||
                400...499 ~= httpResponse.statusCode
        else {
            throw StocksAPIError.httpStatusCodeFailed(statusCode: httpResponse.statusCode, error: nil)
        }

        return httpResponse.statusCode
    }

}

enum YahooModel {}
