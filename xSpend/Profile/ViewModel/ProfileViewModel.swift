//
//  ProfileViewModel.swift
//  xSpend
//
//  Created by Mike Paraskevopoulos on 10/6/24.
//

import Foundation
import FirebaseAuth

class ProfileViewModel:ObservableObject{
    @Published var logoutLink: Bool = false
    @Published var expenseTypesLink: Bool = false
    @Published var countryCurrencyCode = CountryCurrencyCode().countryCurrency
    @Published private var uniqueCurrencyCodes = Set<String>()
    @Published var showMonthGoalAlert = false
    @Published var exchangeRates = ExchangeRatesViewModel()

    
    func configure(currencySelection:String) async {
//        await exchangeRates.fetchExchangeRates()
    }
    
    func signOut(){
        do {
            try Auth.auth().signOut()
            logoutLink.toggle()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
    func setMonthGoal(oldValue:String,newValue:String, monthGoal:String) async throws -> String{
        if let amount = Double(monthGoal), let currencyFrom = self.countryCurrencyCode[oldValue], let currencyTo = self.countryCurrencyCode[newValue]{
            
            let convertedResult = await exchangeRates.getExchangeRate(baseCurrencyAmount: amount, from: currencyFrom, to: currencyTo)
            
            
            switch convertedResult {
            case .success(let conversion):
                return String(format: "%.2f", conversion)
            default:
                return "Err"
            }
        }
        return " "
    }
}
