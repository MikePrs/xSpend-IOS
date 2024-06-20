//
//  ExchangeRate.swift
//  xSpend
//
//  Created by Mike Paraskevopoulos on 30/12/23.
//

import SwiftUI

struct ExchangeRate:Codable {
    var data = [String:Double]()
}

struct APIError:Codable {
    var message:String
}

enum FetchError: Error {
    case badURL
    case networkError(Error)
    case decodingError(Error)
    case apiError(String)
    case unknown
    
    
    var errString:String{
        switch self {
        case .badURL: "Bad Url"
        case .networkError(_): "Network Error"
        case .decodingError(_): "Decoding Error"
        case .apiError(_): "Api Error"
        case .unknown: "Unknown"
        }
    }
}
