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
    @ObservedObject var fbViewModel = FirebaseViewModel()
    @ObservedObject var profileViewModel = ProfileViewModel()
    @AppStorage(Constants.appStorage.currencySelection) private var currencySelection: String = ""
    
    func setUp() {
        profileViewModel.configure()
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
                        ForEach(profileViewModel.countryCurrencyCode.sorted(by: <), id: \.key) { key, value in
                            Text(key)
                        }
                    }
                    LabeledContent(Constants.strings.currentCurrency, value: profileViewModel.countryCurrencyCode[currencySelection] ?? "")
                } header: {
                    Text(Constants.strings.appSettings)
                }
                Button(role: .cancel) {profileViewModel.expenseTypesLink.toggle()} label:{Text(Constants.strings.addExpenseType)}
                Section {
                    Button(role: .destructive) {profileViewModel.signOut()} label:{
                        HStack{
                            Image(systemName: Constants.icon.logOut)
                            Text(Constants.strings.logOut)
                        }
                    }
                }
                .navigationDestination(isPresented: $profileViewModel.logoutLink) {
                    LandingScreen()
                }
                .navigationDestination(isPresented: $profileViewModel.expenseTypesLink) {
                    ExpenseTypes().environmentObject(fbViewModel)
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
