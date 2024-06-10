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

    
    func configure() {
        uniqueCurrencyCodes = Set<String>(countryCurrencyCode.values)
    }
    
    func signOut(){
        do {
            try Auth.auth().signOut()
            logoutLink.toggle()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
}
