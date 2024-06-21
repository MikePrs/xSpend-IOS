//
//  FetchError.swift
//  xSpend
//
//  Created by Mike Paraskevopoulos on 22/6/24.
//

import Foundation

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
