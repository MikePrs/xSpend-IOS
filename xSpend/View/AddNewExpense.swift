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

enum AddExpensesField: Hashable {
    case title,amount,type,date,notes,end
    
    var next:AddExpensesField? {
        switch self {
        case .title:
            return .amount
        case .amount:
            return .notes
        default:
            return nil
        }
    }
}

struct AddNewExpense: View {
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var exchangeRates = ExchangeRatesViewModel()
    @State private var expenseTitle: String = ""
    @State private var expenseType: String = "Coffee"
    @State private var expenseDate = Date.now
    @State private var expenseNotes: String = ""
    @State private var expenseAmount: Float? = nil
    @State var showingAlert = false
    @State var showSuccessToast = false
    @AppStorage(Constants.appStorage.currencySelection) private var currencySelection: String = ""
    @EnvironmentObject var fbViewModel : FirebaseViewModel
    @FocusState private var focusedField: AddExpensesField?
    
    
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
        if (expenseAmount == 0 || expenseAmount == nil ){
            showingAlert = true
        }else{
            let formatter4 = DateFormatter()
            formatter4.dateFormat = "d/M/YYYY"
            let newExpense = [
                Constants.firebase.title : expenseTitle,
                Constants.firebase.amount : expenseAmount ?? 0,
                Constants.firebase.type : expenseType,
                Constants.firebase.notes : expenseNotes,
                Constants.firebase.user : Auth.auth().currentUser?.email as Any,
                Constants.firebase.timestamp :  expenseDate.timeIntervalSince1970,
                Constants.firebase.date : formatter4.string(from: expenseDate),
                Constants.firebase.currency :  CountryCurrencyCode().countryCurrency[currencySelection]!
            ]
            let addSuccess = fbViewModel.addNewExpense(newExpense: newExpense as [String : Any])
            if addSuccess {
                expenseTitle = ""
                expenseType = ""
                expenseNotes = ""
                expenseAmount = nil
                showSuccessToast = true
            }
        }
    }
    
    var body: some View {
        VStack {
            Form {
                HeaderTitle(title: Constants.strings.addNewExpense)
                TextField(Constants.strings.title, text: $expenseTitle)
                    .focused($focusedField, equals: .title)
                HStack{
                    Text(Constants.strings.amountSpace)
                    TextField(Constants.strings.amount, value: $expenseAmount,format:.number).keyboardType(.decimalPad).onReceive(NotificationCenter.default.publisher(for: UITextField.textDidBeginEditingNotification)) { obj in
                        if let textField = obj.object as? UITextField {
                            textField.selectedTextRange = textField.textRange(from: textField.beginningOfDocument, to: textField.endOfDocument)
                        }
                    }
                    .focused($focusedField, equals: .amount)
                }
                Picker(Constants.strings.type, selection: $expenseType){
                    ForEach(fbViewModel.alltypesValues, id: \.self) { value in
                        Text(value).tag(value)
                    }
                }.pickerStyle(.navigationLink)
                DatePicker(selection: $expenseDate, in: ...Date.now, displayedComponents: .date) {
                    Text(Constants.strings.selectDate)
                }.tint(Constants.colors.lightPurpleColor)
                TextField(Constants.strings.notes, text: $expenseNotes, axis: .vertical).frame(height: 200).focused($focusedField, equals: .notes)
                Section {
                    Button(role: .cancel) {addNewExpense()} label:{Text(Constants.strings.add).foregroundColor(colorScheme == .light ? Constants.colors.purpleColor : Constants.colors.lightPurpleColor)}
                }
            }
            .scrollDismissesKeyboard(.immediately)
            .toolbar {
                ToolbarItem(placement: .keyboard) {
                    HStack{
                        Spacer()
                        Button(action: {
                            if focusedField == .notes {
                                addNewExpense()
                            }else{
                                focusedField = focusedField?.next
                            }
                        }) {
                            Text(focusedField == .notes ? Constants.strings.add : Constants.strings.next).foregroundStyle(colorScheme == .light ? Constants.colors.purpleColor : Constants.colors.lightPurpleColor)
                        }
                    }
                }
            }.toast(isPresenting: $showSuccessToast) {
                AlertToast(type: .complete(.gray), title: Constants.strings.expenseCreated, style: .style(titleColor: colorScheme == .light ? .black: .white))
            }
            .alert(Constants.strings.titleAmountErr, isPresented: $showingAlert) {
                Button(Constants.strings.ok, role: .cancel) { }
            }
        }.onAppear{onAppear()}
    }
}

struct AddNewExpense_Previews: PreviewProvider {
    static var previews: some View {
        AddNewExpense()
    }
}
