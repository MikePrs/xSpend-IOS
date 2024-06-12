//
//  ExpenseDetail.swift
//  xSpend
//
//  Created by Mike Paraskevopoulos on 12/6/24.
//

import SwiftUI
import AlertToast

struct ExpenseDetail: View {
    @FocusState private var focusedField: AddExpensesField?
    @ObservedObject var addNewExpenseViewModel : AddNewExpenseViewModel
    @ObservedObject var fbViewModel : FirebaseViewModel
    @Environment(\.colorScheme) var colorScheme
    @AppStorage(Constants.appStorage.currencySelection) private var currencySelection: String = ""

    
    
    
    var body: some View {
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
                        await addNewExpenseViewModel.addNewExpense(currencySelection: currencySelection)
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
                                await addNewExpenseViewModel.addNewExpense(currencySelection: currencySelection)
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
    }
}

