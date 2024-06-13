//
//  Model.swift
//  xSpend
//
//  Created by Mike Paraskevopoulos on 13/6/24.
//

import Foundation

enum AddExpensesField: Hashable {
    case title,amount,type,date,notes,end
    
    var next:AddExpensesField? {
        switch self {
        case .title:
            return .amount
        case .amount:
            return .notes
        default:
            return nil
        }
    }
}
