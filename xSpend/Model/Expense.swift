//
//  Expense.swift
//  xSpend
//
//  Created by Mike Paraskevopoulos on 25/7/23.
//

import SwiftUI

struct Expense {
    var title:String
    var amount:Float
    var type:String
    var note:String
}

struct ExpenseType:Identifiable {
    var id:String
    var name:String
    var icon:String
}
