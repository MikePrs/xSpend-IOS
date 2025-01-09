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
    @StateObject var profileViewModel = ProfileViewModel()
    @AppStorage(Constants.appStorage.currencySelection) private var currencySelection: String = ""
    @EnvironmentObject var router: Router
    @EnvironmentObject var fbViewModel: FirebaseViewModel
    
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
                Button(role: .cancel) {
                    router.navigate(to: .expenseTypes)
                } label:{Text(Constants.strings.addExpenseType)}
                Section {
                    Button(role: .destructive) {
                        if profileViewModel.signOut() {
                            router.navigate(to: .landingScreen)
                        }
                    } label:{
                        HStack{
                            Image(systemName: Constants.icon.logOut)
                            Text(Constants.strings.logOut)
                        }
                    }
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
                        await profileViewModel.setUserGoalManualy(newValue: Double(profileViewModel.monthlyGoal) ?? 0.0)
                    }
                    profileViewModel.showMonthGoalAlert = false
                }
                .buttonStyle(.borderedProminent)
                .tint(Utils.getPurpleColor(.light))
            }.presentationDetents([.fraction(0.2)])
        }

    }
}

//struct Profile_Previews: PreviewProvider {
//    static var previews: some View {
//        Profile()
//    }
//}
