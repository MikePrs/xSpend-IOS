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
    @Environment(\.colorScheme) var colorScheme
    @AppStorage(Constants.appStorage.isDarkMode) private var isDarkMode = false
    @ObservedObject var fbViewModel = FirebaseViewModel()
    @ObservedObject var profileViewModel = ProfileViewModel()
    @AppStorage(Constants.appStorage.currencySelection) private var currencySelection: String = ""
//    @AppStorage(Constants.appStorage.monthGoal) private var monthGoal: String = ""
    
    func setUp() async {
        await profileViewModel.configure(fbViewModel: fbViewModel)
        Utilities().setUserDefaults(for:"userCurrency", with: profileViewModel.countryCurrencyCode[currencySelection] ?? "")
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
                        .onChange(of: currencySelection) { oldValue, newValue in
                            if oldValue != newValue {
                                Task{
                                    await profileViewModel.setUsersGoal(oldValue: oldValue, newValue: newValue)
//                                    await fbViewModel.setUsersTarget(target: newValue)
                                }
                                Utilities().setUserDefaults(for:"userCurrency", with: profileViewModel.countryCurrencyCode[currencySelection] ?? "")
                            }
                        }
                    
                    LabeledContent(Constants.strings.monthGoal, value: profileViewModel.monthlyGoal )
                        .onTapGesture {
                            profileViewModel.showMonthGoalAlert.toggle()
                            
                            
                    }
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
            
        }
        .background(Color(UIColor.systemGroupedBackground))
        .ignoresSafeArea(.all, edges: [.bottom, .trailing])
        .onAppear{Task{await setUp()}}
        .sheet( isPresented: $profileViewModel.showMonthGoalAlert) {
            VStack{
                HStack{
                    TextField(
                        "",
                        text: $profileViewModel.monthlyGoal
                    )
                    .keyboardType(.decimalPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: 200)
                    .multilineTextAlignment(.center)
                    .padding()
                }
                Button(Constants.strings.save, role: .none) {
                    Task{
                        await profileViewModel.setUsersGoal(oldValue: currencySelection, newValue: currencySelection)
                    }
                    profileViewModel.showMonthGoalAlert = false
                }
                .buttonStyle(.borderedProminent)
                .tint(Utils.getPurpleColor(.light))
            }.presentationDetents([.fraction(0.2)])
        }

    }
}

struct Profile_Previews: PreviewProvider {
    static var previews: some View {
        Profile()
    }
}
