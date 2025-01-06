//
//  ExpenseDetailViewType.swift
//  xSpend
//
//  Created by Mike Paraskevopoulos on 13/6/24.
//

import Foundation

enum ExpenseDetailViewType:Hashable {
    case add, update, view
    
    var title : String{
        switch self {
        case .add:
            return Constants.strings.addNewExpense
        case .update:
            return Constants.strings.updateExpense
        case .view:
            return Constants.strings.reviewExpense
        }
    }
    
    var butotnLabel:String{
        switch self {
        case . add:
            return Constants.strings.add
        case .update:
            return Constants.strings.update
        case .view:
            return Constants.strings.edit
        }
    }
    
    var isDisabled:Bool{
        switch self {
        case .add, .update:
            return false
        case .view:
            return true
        }
    }

}
