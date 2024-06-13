//
//  AddNewExpense.swift
//  xSpend
//
//  Created by Mike Paraskevopoulos on 13/7/23.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import AlertToast

struct AddNewExpense: View {
    @Environment(\.colorScheme) var colorScheme
    @AppStorage(Constants.appStorage.currencySelection) private var currencySelection: String = ""
    @ObservedObject var fbViewModel = FirebaseViewModel()
    @ObservedObject var addNewExpenseViewModel = AddNewExpenseViewModel()
    
    func onAppear() {
        fbViewModel.getExpenseTypes()
        if currencySelection == "" {
            if let usersCountryCode = Locale.current.region?.identifier{
                if let name = (Locale.current as NSLocale).displayName(forKey: .countryCode, value:usersCountryCode ){
                    self.currencySelection = name
                }
            }
        }
        addNewExpenseViewModel.configure(fbViewModel: fbViewModel)
    }
    
    var body: some View {
        VStack {
            ExpenseDetail(addNewExpenseViewModel: addNewExpenseViewModel,fbViewModel: fbViewModel, viewType: .add
//                          expensesViewModel: expensesViewModel
            )
        }.onAppear{onAppear()}
    }
}
