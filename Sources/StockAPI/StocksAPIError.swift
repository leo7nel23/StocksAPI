//
//  StocksAPIError.swift
//  
//
//  Created by 賴柏宏 on 2024/1/12.
//

import Foundation

public struct ErrorResponse: Sendable, Codable {

    public let code: String
    public let description: String

    public init(code: String, description: String) {
        self.code = code
        self.description = description
    }
}

public enum StocksAPIError: CustomNSError {

    case invalidURL
    case invalidResponseType
    case httpStatusCodeFailed(statusCode: Int, error: ErrorResponse?)


    public static var errorDomain: String {
        "StocksAPIErrorDomain"
    }

    public var errorCode: Int {
        switch self {
        case .invalidURL:
            return 0
        case .invalidResponseType: 
            return 1
        case .httpStatusCodeFailed: 
            return 2

        }
    }

    public var errorUserInfo: [String : Any] {

        let text: String
        switch self {
        case .invalidURL:
            text = "Invalid URL"
        case .invalidResponseType:
            text = "Invalid Response Type"
        case let .httpStatusCodeFailed(statusCode, error):
            if let error = error {
                text = "Error: Status Code: \(statusCode), message \(error.description)"
            } else {
                text = "Error: Status Code: \(statusCode)"
            }
        }
        return [NSLocalizedDescriptionKey: text]
    }

}
