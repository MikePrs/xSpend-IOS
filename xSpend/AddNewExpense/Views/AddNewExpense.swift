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
    @FocusState private var focusedField: AddExpensesField?
    
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
    
    func addNewExpense() async {
        await addNewExpenseViewModel.addNewExpense(currencySelection: currencySelection)
        focusedField = .end
    }
    
    var body: some View {
        VStack {
            Form {
                HeaderTitle(title: Constants.strings.addNewExpense)
                TextField(Constants.strings.title, text: $addNewExpenseViewModel.expenseTitle)
                    .focused($focusedField, equals: .title)
                HStack{
                    Text(Constants.strings.amountSpace)
                    TextField(Constants.strings.amount, value: $addNewExpenseViewModel.expenseAmount,format:.number).keyboardType(.decimalPad).onReceive(NotificationCenter.default.publisher(for: UITextField.textDidBeginEditingNotification)) { obj in
                        if let textField = obj.object as? UITextField {
                            textField.selectedTextRange = textField.textRange(from: textField.beginningOfDocument, to: textField.endOfDocument)
                        }
                    }
                    .focused($focusedField, equals: .amount)
                }
                Picker(Constants.strings.type, selection: $addNewExpenseViewModel.expenseType){
                    ForEach(fbViewModel.alltypesValues, id: \.self) { value in
                        Text(value).tag(value)
                    }
                }.pickerStyle(.navigationLink)
                DatePicker(selection: $addNewExpenseViewModel.expenseDate, in: ...Date.now, displayedComponents: .date) {
                    Text(Constants.strings.selectDate)
                }.tint(Constants.colors.lightPurpleColor)
                TextField(Constants.strings.notes, text: $addNewExpenseViewModel.expenseNotes, axis: .vertical).frame(height: 200).focused($focusedField, equals: .notes)
                Section {
                    Button(role: .cancel) {
                        Task{
                            await addNewExpense()
                        }
                    } label:{Text(Constants.strings.add).foregroundColor(Utils.getPurpleColor(colorScheme))}
                }
            }
            .scrollDismissesKeyboard(.immediately)
            .toolbar {
                ToolbarItem(placement: .keyboard) {
                    HStack{
                        Spacer()
                        Button(action: {
                            if focusedField == .notes {
                                Task{
                                    await addNewExpense()
                                }
                            }else{
                                focusedField = focusedField?.next
                            }
                        }) {
                            Text(focusedField == .notes ? Constants.strings.add : Constants.strings.next).foregroundStyle(Utils.getPurpleColor(colorScheme))
                        }
                    }
                }
            }.toast(isPresenting: $addNewExpenseViewModel.showSuccessToast) {
                AlertToast(type: .complete(.gray), title: Constants.strings.expenseCreated, style: .style(titleColor: colorScheme == .light ? .black: .white))
            }
            .alert(Constants.strings.titleAmountErr, isPresented: $addNewExpenseViewModel.showingAlert) {
                Button(Constants.strings.ok, role: .cancel) { }
            }
        }.onAppear{onAppear()}
    }
}
