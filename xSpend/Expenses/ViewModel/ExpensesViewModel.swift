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

    
    private var countryCurrencyCode = CountryCurrencyCode().countryCurrency

    func configure(fbViewModel:FirebaseViewModel,currencySelection:String?=nil) async{
        self.fbViewModel = fbViewModel
        
        
        isLoading = true
        await exchangeRates.fetchExchangeRates()
        if let currencySelection {
            currency = countryCurrencyCode[currencySelection] ?? ""
        }
        fbViewModel.getExpenseTypes()
        fbViewModel.sectioned = [:]
        fbViewModel.getExpenses(
            from: startDate,
            to: limitDate,
            category: Constants.strings.any,
            min: minPrice,
            max: maxPrice,
            currency: currency
        )
        isLoading = false
    }
    
    func removeExpense() async {
        let res = await fbViewModel?.firebaseDelete(with: expenseId, at: Constants.firebase.expenses)
        DispatchQueue.main.async {
            switch res {
            case .success(true):
                self.showToast(text:Constants.strings.deleteExpense)
            default:
                self.showAlert(message: Constants.strings.deleteExpenseError)
            }
            self.expenseId = ""
        }
    }
    
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
        fbViewModel?.getExpenses(from: olderEx, to:limitDate, category: filterType, currency: currency)
        startDate = olderEx
        isLoading = false
    }
    
    func filterExpensesDate(_ filterStartDate:Date, _ filterEndDate:Date, _ newFilterCategory:String) {
        isLoading = true
        fbViewModel?.getExpenses(from: filterStartDate, to:filterEndDate, category: newFilterCategory, currency: currency)
        isLoading = false
    }
    
    func setPriceRange(_ filterStartDate:Date, _ filterEndDate:Date, _ newFilterCategory:String){
        isLoading = true
        hideKeyboard()
        fbViewModel?.getExpenses(from: filterStartDate, to:filterEndDate, category: newFilterCategory, min: minPrice, max: maxPrice, currency: currency)
        isLoading = false
    }
    
    
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
}
