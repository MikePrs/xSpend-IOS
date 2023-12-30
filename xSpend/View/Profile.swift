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
    @AppStorage("isDarkMode") private var isDarkMode = false
    @State private var logoutLink: Bool = false
    @State private var expenseTypesLink: Bool = false
    @AppStorage("currencySelection") private var currencySelection: String = ""
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
        NavigationView {
            Form{
                if let userEmail = Auth.auth().currentUser?.email{
                    HStack {
                        Image(systemName: "person.circle").frame(width: 80,height: 80).font(.system(size: 50))
                        Text(userEmail)
                    }
                    LabeledContent("Username", value: userEmail.components(separatedBy: "@")[0])
                }
                Section {
                    Toggle("Dark Mode", isOn: $isDarkMode)
                    Picker("Country", selection: $currencySelection){
                        ForEach(countryCurrencyCode.sorted(by: <), id: \.key) { key, value in
                            Text(key)
                        }
                    }
                    LabeledContent("Current Currency", value: countryCurrencyCode[currencySelection] ?? "")
                } header: {
                    Text("App Settings")
                }
                Button(role: .cancel) {expenseTypesLink.toggle()} label:{Text("Add new expense type")}
                Section {
                    Button(role: .destructive) {signOut()} label:{Text("Log Out")}
                }
            }
            .navigationBarTitle(Text("Profile"))
            .navigationDestination(isPresented: $logoutLink) {
                LandingScreen()
            }
            .navigationDestination(isPresented: $expenseTypesLink) {
                ExpenseTypes()
            }
        }.onAppear{setUp()}
    }
}

struct Profile_Previews: PreviewProvider {
    static var previews: some View {
        Profile()
    }
}
