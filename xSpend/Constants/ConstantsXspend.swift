//
//  Constants.swift
//  xSpend
//
//  Created by Mike Paraskevopoulos on 2/6/24.
//

import SwiftUI

public struct Constants {
    static var groupName = "group.co.mikePrs.xSpend"
    
    struct firebase {
        // Collections
        static var expenses = "Expenses"
        static var expenseTypes = "ExpenseTypes"
        // add expense fields
        static var title = "title"
        static var amount = "amount"
        static var type = "type"
        static var notes = "notes"
        static var user = "user"
        static var timestamp = "timestamp"
        static var date = "date"
        static var currency = "currency"
        static var usersTargets = "usersTargets"
        
        // add expense type
        static var name = "name"
        static var icon = "icon"
    }
    
    struct appStorage {
        static var currencySelection = "currencySelection"
        static var isDarkMode = "isDarkMode"
        static var monthGoal = "monthGoal"
        
    }
    
    struct colors {
        static let purpleColor = Color(red: 0.37, green: 0.15, blue: 0.80)
        static let lightPurpleColor = Color(red: 0.6, green: 0.6, blue: 1.0)
        
    }
    
    struct icon {
        static var expenses = "expensesIcon"
        static var eye = "eye"
        static var slashEye = "eye.slash"
        static var ckeckMarkFill = "checkmark.circle.fill"
        static var xMarkFill = "xmark.circle.fill"
        static var person = "person.circle"
        static var plus = "plus"
        static var up = "chevron.up"
        static var down = "chevron.down"
        static var right = "chevron.right"
        static var left = "chevron.left"
        static var houseFill = "house.fill"
        static var plusFill = "plus.circle.fill"
        static var personFill = "person.fill"
        static var house = "house"
        static var personSimple = "person"
        static var noIcon = "questionmark.square.dashed"
        static var logOut = "arrowshape.turn.up.backward"
        static var trash = "trash"
        
    }
    
    struct staticList {
        static var standardTypes = [
            ExpenseType(id: "0", name:"Coffee",icon:"cup.and.saucer.fill"),
            ExpenseType(id: "1", name:"Gas",icon:"fuelpump.circle"),
            ExpenseType(id: "2", name:"Rent",icon:"house.circle"),
            ExpenseType(id: "3", name:"Electricity",icon:"bolt.circle")
        ]
        
        static var standardStringType = ["Coffee","Gas","Rent","Electricity"]
        
        static var alltypesValueIcon : [String:String] = ["Coffee":"cup.and.saucer.fill","Gas":"fuelpump.circle","Rent":"house.circle","Electricity":"bolt.circle"]
    }
    
    struct error {
        static var amountAmountErr = "Amout should be filled."
        static let passwordErr = "Password change error."
        static let emailFillErr = "Fill email error."
        static var deleteExpenseTypeError = "Error deleting expense type"
        static var addExpenseTypeError = "Error adding expense type"
        static var updateExpenseTypeError = "Error updating expense type"
        static var deleteExpenseError = "Error deleting expense"
        static var apiErrorLimitReached = "Api Error Limit Reached"
        static var apiError = "Api Error"
        static var unknown = "Unknown"
        static var addingExpenseErr = "Error adding expense"
        static var updatingExpenseErr = "Error updating expense"
        static var expenseNameFilled = "Expense name should be filled."
        static var duplicateExpenseType = "This expense type already exists."
        static var getExpensesErr = "Error getting expenses"
        static var firebaseViewModelErr = "Error with firebase view model."
        static var retrieveUserTargetErr = "Something went wrong retrieving user terget"
        static var firebaseExpenseMonthSumErr = "Something went wrong summarizing month expenses"
    }
    
    
    struct strings {
        static let welcomTo = "Welcome to "
        static let signUp = "SignUp"
        static let loginTo = "Login to "
        static let login = "Login"
        static let xSpend = "xSpend"
        static let userNameEmail = "User name (email address)"
        static let password = "Password"
        static var ok = "ok"
        static var no = "no"
        static var cancel = "Cancel"
        static var forgotPassword = "Forgot password"
        static var passwordsDontMatch = "Passwords don't match"
        static var confirmPassword = "Confirm Password"
        static var title = "Title"
        static var amountSpace = "Amount:   "
        static var amount = "Amount"
        static var type = "Type"
        static var selectDate = "Select a date"
        static var notes = "Notes"
        static var add = "Add"
        static var update = "Update"
        static var save = "Save"
        static var next = "Next"
        static var expenseCreated = "Expense Created"
        static var expenseUpdated = "Expense Updated"
        static var darkMode = "Dark Mode"
        static var country = "Country"
        static var currentCurrency = "Current Currency"
        static var appSettings = "App Settings"
        static var addExpenseType = "Add new expense type"
        static var logOut = "Log Out"
        static var userName = "Username"
        static var user = "user"
        static var delete = "Delete"
        static var edit = "Edit"
        static var back = "Back"
        static var newExpenseType = "New Expense type"
        static var updateExpenseType = "Update Expense Type"
        static var enterExpenseType = "Enter expense type name"
        static var any = "Any"
        static var filters = "FILTERS"
        static var category = "Category"
        static var startDate = "Start Date"
        static var endDate = "End Date"
        static var priceRange = "PRICE RANGE"
        static var min = "min"
        static var max = "max"
        static var set = "set"
        static var loadMore = "Load More"
        static var noExpense = "No Expenses"
        static var profile = "Profile"
        static var expenses = "Expenses"
        static var expenseTypes = "Expense Types"
        static var addNewExpense = "Add new expense"
        static var updateExpense = "Update expense"
        static var reviewExpense = "Review expense"
        static var deleteExpenseType = "Expense type Deleted"
        static var deleteExpense = "Expense deleted"
        static var expensetypeDelete = "Are you sure you want to delete this expense type?"
        static var expenseDelete = "Are you sure you want to delete this expense ?"
        static var monthGoal = "Monthly spending goal."
        

    }
}
