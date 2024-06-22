//
//  Expense.swift
//  xSpend
//
//  Created by Mike Paraskevopoulos on 25/7/23.
//

import Foundation

struct Expense:Identifiable {
    var id:String
    var title:String
    var amount:Float
    var type:String
    var note:String
    var date:String
    var currency:String
    var amountConverted:String
}
