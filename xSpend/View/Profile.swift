//
//  Profile.swift
//  xSpend
//
//  Created by Mike Paraskevopoulos on 13/7/23.
//

import SwiftUI
import FirebaseAuth
import SymbolPicker

struct Profile: View {
    @AppStorage(Constants.appStorage.isDarkMode) private var isDarkMode = false
    @State private var logoutLink: Bool = false
    @State private var expenseTypesLink: Bool = false
    @AppStorage(Constants.appStorage.currencySelection) private var currencySelection: String = ""
    private var countryCurrencyCode = CountryCurrencyCode().countryCurrency
    @State private var uniqueCurrencyCodes = Set<String>()
    
    func signOut(){
        do {
            try Auth.auth().signOut()
            logoutLink.toggle()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
    func setUp() {
        uniqueCurrencyCodes = Set<String>(countryCurrencyCode.values)
    }
    
    
    var body: some View {
        VStack{
            Form{
                HeaderTitle(title: Constants.strings.profile)
                if let userEmail = Auth.auth().currentUser?.email{
                    HStack {
                        Image(systemName: Constants.icon.person).frame(width: 80,height: 80).font(.system(size: 50))
                        Text(userEmail)
                    }
                    LabeledContent(Constants.strings.userName, value: userEmail.components(separatedBy: "@")[0])
                }
                Section {
                    Toggle(Constants.strings.darkMode, isOn: $isDarkMode)
                    Picker(Constants.strings.country, selection: $currencySelection){
                        ForEach(countryCurrencyCode.sorted(by: <), id: \.key) { key, value in
                            Text(key)
                        }
                    }
                    LabeledContent(Constants.strings.currentCurrency, value: countryCurrencyCode[currencySelection] ?? "")
                } header: {
                    Text(Constants.strings.appSettings)
                }
                Button(role: .cancel) {expenseTypesLink.toggle()} label:{Text(Constants.strings.addExpenseType)}
                Section {
                    Button(role: .destructive) {signOut()} label:{
                        HStack{
                            Image(systemName: Constants.icon.logOut)
                            Text(Constants.strings.logOut)
                        }
                    }
                }
                .navigationDestination(isPresented: $logoutLink) {
                    LandingScreen()
                }
                .navigationDestination(isPresented: $expenseTypesLink) {
                    ExpenseTypes()
                }
            }.padding(.top,1)
            
        }.onAppear{setUp()}
    }
}

struct Profile_Previews: PreviewProvider {
    static var previews: some View {
        Profile()
    }
}
