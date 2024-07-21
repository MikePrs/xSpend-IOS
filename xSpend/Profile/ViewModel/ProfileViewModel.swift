//
//  ProfileViewModel.swift
//  xSpend
//
//  Created by Mike Paraskevopoulos on 10/6/24.
//

import Foundation
import FirebaseAuth

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
    
    func setUsersGoal() async {
        let res = await fbViewModel?.setUsersTarget(target: self.monthlyGoal)
        switch res {
        case .success(_):
            print("User target OK")
        case .failure(let err):
            print(err.localizedDescription)
        case .none:
            print("Something went wrong retrieving user terget")
        }
    }
}
