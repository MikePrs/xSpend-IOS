//
//  ExpensesScreenViewModel.swift
//  xSpend
//
//  Created by Mike Paraskevopoulos on 9/6/24.
//

import Foundation
import SwiftUI


class ExpensesViewModel: ObservableObject {
    private var fbViewModel : FirebaseViewModel?
    
    @ObservedObject var exchangeRates = ExchangeRatesViewModel()
    @Published var startDate = Calendar.current.date(byAdding: .weekOfYear, value: -2, to: Date.now)!
    @Published var filterType = Constants.strings.any
    @Published var limitDate = Date.now
    @Published var currency = ""
    @Published var enableFilters:Bool=false
    @Published var minPrice:Float? = nil
    @Published var maxPrice:Float? = nil
    @Published var filtersSize:CGFloat = 130
    @Published var emptytext = ""
    @Published var isLoading = true
    @Published var showSuccessToast = false
    @Published var successToastText = ""
    @Published var expenseId = ""
    @Published var showingErrAlert:Bool = false
    @Published var alertMessage = ""
    @Published var openDetails = false
    @Published var expenseList = [SectionedExpenses]()

    
    private var countryCurrencyCode = CountryCurrencyCode().countryCurrency

    func configure(fbViewModel:FirebaseViewModel,currencySelection:String?=nil) async{
        self.fbViewModel = fbViewModel
        
        isLoading = true
//        await exchangeRates.fetchExchangeRates()
        if let currencySelection {
            currency = countryCurrencyCode[currencySelection] ?? ""
        }
        fbViewModel.getExpenseTypes()
        expenseList = await getExpenses(
            from: startDate,
            to: limitDate,
            category: Constants.strings.any,
            min: minPrice,
            max: maxPrice,
            currency: currency
        )
        
        if expenseList.map({return $0.expenses}).flatMap({$0}).map({$0.amountConverted}).contains(Constants.error.apiError) {
            showAlert(message:Constants.error.apiErrorLimitReached)
        }
        
        isLoading = false
    }
    
    func removeExpense() async {
        isLoading = true
        
        let res = await fbViewModel?.firebaseDelete(with: expenseId, at: Constants.firebase.expenses)
        DispatchQueue.main.async {
            switch res {
            case .success(true):
                self.showToast(text:Constants.strings.deleteExpense)
            case .failure(let err):
                self.showAlert(message: err.errString)
            default:
                self.showAlert(message: FirebaseError.unknown.errString)
            }
            self.expenseId = ""
        }
        
        if let fbVM = fbViewModel {
            expenseList = await getExpenses(
                from: startDate,
                to: limitDate,
                category: Constants.strings.any,
                min: minPrice,
                max: maxPrice,
                currency: currency
            )
        }
        isLoading = false    }
    
    func showToast(text:String){
        DispatchQueue.main.async {
            self.showSuccessToast = true
            self.successToastText = text
        }
    }
    
    func showAlert(message:String?) {
        DispatchQueue.main.async {
            self.alertMessage = message ?? ""
            self.showingErrAlert = true
        }
    }
    
    func loadMoreExpenses(){
        isLoading = true
        let olderEx = Calendar.current.date(byAdding: .weekOfYear, value: -2, to: startDate)!
        // by changing startDate fbViewModel?.getExpenses is triggered
        startDate = olderEx
        isLoading = false
    }
    
    func filterExpensesDate(_ filterStartDate:Date, _ filterEndDate:Date, _ newFilterCategory:String) async {
        isLoading = true
        if let fbVM = fbViewModel {
            expenseList = await getExpenses(
                from: filterStartDate,
                to: filterEndDate,
                category: newFilterCategory,
                min: minPrice,
                max: maxPrice,
                currency: currency
            )
        }
        isLoading = false
    }
    
    func setPriceRange(_ filterStartDate:Date, _ filterEndDate:Date, _ newFilterCategory:String) async{
        isLoading = true
        hideKeyboard()
        if let fbVM = fbViewModel {
            expenseList = await getExpenses(
                from: filterStartDate,
                to:filterEndDate,
                category: newFilterCategory,
                min: minPrice,
                max: maxPrice,
                currency: currency
            )
        }
        isLoading = false
    }
    
    
    func getExpenses(from:Date , to:Date, category:String, min:Float? = nil, max:Float? = nil, currency: String) async -> [SectionedExpenses] {
        if let fbVM = fbViewModel {
            let result = await fbVM.fetchExpenses(
                from: from,
                to:to,
                category: category,
                min: minPrice,
                max: maxPrice,
                currency: currency)
            
            switch result {
            case .success(let expenses):
                return expenses
            case .failure(let err):
                showAlert(message: err.errString)
                return []
            }
        }else{
            showAlert(message: Constants.error.firebaseViewModelErr)
            return []
        }
    }
    
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
}
