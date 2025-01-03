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
    
    public init() {}
    
    func configure(fbViewModel:FirebaseViewModel) async {
        self.fbViewModel = fbViewModel
        getMonthGoal()
    }
    
    func signOut(){
        do {
            try Auth.auth().signOut()
            logoutLink.toggle()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
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
            case .success(let conversion):
                monthlyGoal = String(format: "%.2f", conversion)
                let res = await fbViewModel?.setUsersTarget(target: self.monthlyGoal)
                switch res {
                case .success(_):
                    print("User target OK")
                    Utilities().setUserDefaults(for:"userTarget", with: monthlyGoal)
                case .failure(let err):
                    print(err.localizedDescription)
                case .none:
                    print(Constants.error.retrieveUserTargetErr)
                }
            default:
                print(Constants.error.retrieveUserTargetErr)
            }
            
            
        }
    }
}
