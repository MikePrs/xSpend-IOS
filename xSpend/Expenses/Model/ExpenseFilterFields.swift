//
//  Model.swift
//  xSpend
//
//  Created by Mike Paraskevopoulos on 13/6/24.
//

import Foundation

enum ExpenseFilterFields {
    case min,max
    
    var next:ExpenseFilterFields{
        switch self {
        case .min:
            return .max
        case .max:
            return .min
        }
    }
}
