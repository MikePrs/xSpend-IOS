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

struct ExpenseType:Identifiable {
    var id:String
    var name:String
    var icon:String
}

struct SectionedExpenses:Identifiable{
    var id:String
    var expenses:[Expense]
}

enum FirebaseError:Error {
    case firebaseErrGetExpense
    case firebaseErrDelete
    case firebaseAddExpenseErr
    case firebaseUpdateExpenseErr
    case firebaseAddExpenseTypeErr
    case firebaseUpdateExpenseTypeErr
    case firebaseDeleteExpenseTypeErr
    case firebaseExpenseTypeFillErr(String)
    case unknown
    
    var errString: String {
        
        let err = Constants.error.self
        
        switch self {
        case .firebaseErrGetExpense:
            return err.getExpensesErr
        case .firebaseErrDelete:
            return err.deleteExpenseError
        case .unknown:
            return err.unknown
        case .firebaseAddExpenseErr:
            return err.addingExpenseErr
        case .firebaseUpdateExpenseErr:
            return err.updatingExpenseErr
        case .firebaseAddExpenseTypeErr:
            return err.addExpenseTypeError
        case .firebaseUpdateExpenseTypeErr:
            return err.updateExpenseTypeError
        case .firebaseDeleteExpenseTypeErr:
            return err.deleteExpenseTypeError
        case .firebaseExpenseTypeFillErr(let title):
            return title != "" ? err.duplicateExpenseType :
            err.expenseNameFilled
        }
        
    }
}
