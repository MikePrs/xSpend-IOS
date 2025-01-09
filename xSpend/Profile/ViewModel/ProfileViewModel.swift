//
//  ProfileViewModel.swift
//  xSpend
//
//  Created by Mike Paraskevopoulos on 10/6/24.
//

import Foundation
import FirebaseAuth
import WidgetKit

public class ProfileViewModel:ObservableObject{
    @Published var logoutLink: Bool = false
    @Published var expenseTypesLink: Bool = false
    @Published var countryCurrencyCode = CountryCurrencyCode().countryCurrency
    @Published private var uniqueCurrencyCodes = Set<String>()
    @Published var showMonthGoalAlert = false
    @Published var exchangeRates = ExchangeRatesViewModel()
    @Published var monthlyGoal = ""
    private var fbViewModel : FirebaseViewModel?
    
    func configure(fbViewModel:FirebaseViewModel) async {
        self.fbViewModel = fbViewModel
        getMonthGoal()
    }
    
    func signOut() -> Bool{
        do {
            try Auth.auth().signOut()
            return true
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
            return false
        }
    }
    
    func getMonthGoal(){
        fbViewModel?.getUserTarget { value in
            self.monthlyGoal = value ?? "0"
        }
    }
    
    func setUsersGoal(oldValue:String,newValue:String) async {
        if let amount = Double(monthlyGoal), let currencyFrom = self.countryCurrencyCode[oldValue], let currencyTo = self.countryCurrencyCode[newValue]{
            
            let convertedResult = await exchangeRates.getExchangeRate(baseCurrencyAmount: amount, from: currencyFrom, to: currencyTo)
            
            switch convertedResult {
            case .success(let convertedAmount):
                await updateUsersGoal(amount: convertedAmount)
            default:
                print(Constants.error.retrieveUserTargetErr)
            }
        }
    }
    
    func setUserGoalManualy(newValue:Double) async {
        await updateUsersGoal(amount: newValue)
    }
    
    func updateUsersGoal(amount: Double) async{
        let res = await fbViewModel?.setUsersTarget(target: String(format: "%.2f", amount))
        switch res {
        case .success(_):
            print("User target OK")
            DispatchQueue.main.async {
                self.monthlyGoal = String(format: "%.2f", amount)
            }
            Utilities().setUserDefaults(for:"userTarget", with: monthlyGoal)
        case .failure(let err):
            print(err.localizedDescription)
        case .none:
            print(Constants.error.retrieveUserTargetErr)
        }
    }
}
