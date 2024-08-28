//
//  FirebaseError.swift
//  xSpend
//
//  Created by Mike Paraskevopoulos on 22/6/24.
//

import Foundation

enum FirebaseError:Error {
    case firebaseErrGetExpense
    case firebaseErrDelete
    case firebaseAddExpenseErr
    case firebaseUpdateExpenseErr
    case firebaseAddExpenseTypeErr
    case firebaseUpdateExpenseTypeErr
    case firebaseDeleteExpenseTypeErr
    case firebaseExpenseTypeFillErr(String)
    case firebaseExpenseMonthSumErr
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
        case .firebaseExpenseMonthSumErr:
            return err.firebaseExpenseMonthSumErr
        }
    }
}
