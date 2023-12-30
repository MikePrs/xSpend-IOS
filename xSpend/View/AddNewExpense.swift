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
    @ObservedObject var exchangeRates = ExchangeRatesViewModel()
    @State private var expenseTitle: String = ""
    @State private var expenseType: String = "Coffee"
    @State private var expenseDate = Date.now
    @State private var expenseNotes: String = ""
    @State private var expenseAmount: Float = 0.0
    @State var showingAlert = false
    @State var showSuccessToast = false
    @AppStorage("currencySelection") private var currencySelection: String = ""
    let purpleColor = Color(red: 0.37, green: 0.15, blue: 0.80)
    
    @ObservedObject var fbViewModel = FirebaseViewModel()

    
    func onAppear() {
        if currencySelection == "" {
            if let usersCountryCode = Locale.current.region?.identifier{
                if let name = (Locale.current as NSLocale).displayName(forKey: .countryCode, value:usersCountryCode ){
                    currencySelection = name
                }
            }
        }
        fbViewModel.getExpenseTypes()
    }
    
    func addNewExpense() {
        if (expenseAmount == 0){
            showingAlert = true
        }else{
            let formatter4 = DateFormatter()
            formatter4.dateFormat = "d/M/YYYY"
            let newExpense = [
                "title":expenseTitle,
                "amount":expenseAmount,
                "type":expenseType,
                "notes":expenseNotes,
                "user":Auth.auth().currentUser?.email as Any,
                "timestamp": expenseDate.timeIntervalSince1970,
                "date":formatter4.string(from: expenseDate),
                "currency": CountryCurrencyCode().countryCurrency[currencySelection]!
            ]
            let addSuccess = fbViewModel.addNewExpense(newExpense: newExpense)
            if addSuccess {
                expenseTitle = ""
                expenseType = ""
                expenseNotes = ""
                expenseAmount = 0.0
                showSuccessToast = true
            }
        }
    }
    
    var body: some View {
        NavigationView{
            ZStack{
                Form {
                    TextField("Title", text: $expenseTitle)
                    HStack{
                        Text("Amount:   ")
                        TextField("Amount", value: $expenseAmount,format:.number).keyboardType(.decimalPad).onReceive(NotificationCenter.default.publisher(for: UITextField.textDidBeginEditingNotification)) { obj in
                            if let textField = obj.object as? UITextField {
                                textField.selectedTextRange = textField.textRange(from: textField.beginningOfDocument, to: textField.endOfDocument)
                            }
                        }
                    }
                    Picker("Type", selection: $expenseType){
                        ForEach(fbViewModel.alltypesValues, id: \.self) { value in
                            Text(value).tag(value)
                        }
                    }.pickerStyle(.navigationLink)
                    DatePicker(selection: $expenseDate, in: ...Date.now, displayedComponents: .date) {
                        Text("Select a date")
                    }
                    TextField("Notes", text: $expenseNotes, axis: .vertical).frame(height: 200)
                    Section {
                        Button(role: .cancel) {addNewExpense()} label:{Text("Add").foregroundColor(purpleColor)}
                    }
                }.scrollDismissesKeyboard(.immediately)
            }.toast(isPresenting: $showSuccessToast) {
                AlertToast(type: .complete(.gray), title: "Expense Created", style: .style(titleColor: colorScheme == .light ? .black: .white))
            }
            .alert("Title and Amout should be filled.", isPresented: $showingAlert) {
                Button("OK", role: .cancel) { }
            }
            .navigationBarTitle(Text("Add new expense"))
        }.onAppear{onAppear()}
    }
}

struct AddNewExpense_Previews: PreviewProvider {
    static var previews: some View {
        AddNewExpense()
    }
}
