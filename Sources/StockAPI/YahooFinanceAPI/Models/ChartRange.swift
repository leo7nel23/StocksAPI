//
//  ChartRange.swift
//  
//
//  Created by Le Bon B' Bauma on 02/03/2023.
//

import Foundation

extension YahooModel {
    enum ChartRange: String, CaseIterable {
        case oneDay = "1d"
        case oneWeek = "5d"
        case oneMonth = "1mo"
        case threeMonth = "3mo"
        case sixMonth = "6mo"
        case ytd
        case oneYear = "1y"
        case twoYear = "2y"
        case fiveYear = "5y"
        case tenYear = "10y"
        case max
    }
    
    enum Interval: String, CaseIterable {
        case oneDay = "1d"
        case oneWeek = "1wk"
        case oneMonth = "1mo"

        init(interval: ChartInterval) {
            switch interval {
            case .oneDay:
                self = .oneDay
            case .oneWeek:
                self = .oneWeek
            case .oneMonth:
                self = .oneMonth
            }
        }
    }
}
