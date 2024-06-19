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
    @Environment(\.dismiss) private var dismiss
    @AppStorage(Constants.appStorage.currencySelection) private var currencySelection: String = ""
    @State var viewType: ExpenseDetailViewType
   

    var body: some View {
        if viewType != .add{
            HStack {
                Image(systemName: Constants.icon.left)
                    .foregroundStyle(Utils.getPurpleColor(colorScheme))
                Button(Constants.strings.back) {
                    dismiss()
                }.tint(Utils.getPurpleColor(colorScheme))
                Spacer()
                Button(viewType.isDisabled ? Constants.strings.edit : Constants.strings.cancel) {
                    viewType =  viewType == .view ? .update : .view
                }.tint(viewType.isDisabled ? Utils.getPurpleColor(colorScheme) : .red)
            }.padding()
        }
        Form {
            Text(viewType.title)
                .font(.title)
                .fontWeight(.bold)
                
            HStack{
                Text(Constants.strings.title+": ")
                TextField("", text: $addNewExpenseViewModel.expenseTitle)
                    .focused($focusedField, equals: .title)
            }
            
            HStack{
                Text(Constants.strings.amountSpace)
                TextField(Constants.strings.amount, value: $addNewExpenseViewModel.expenseAmount,format:.number)
                .keyboardType(.decimalPad)
                .onReceive(NotificationCenter.default.publisher(for: UITextField.textDidBeginEditingNotification)) { obj in
                    if let textField = obj.object as? UITextField {
                        textField.selectedTextRange = textField.textRange(from: textField.beginningOfDocument, to: textField.endOfDocument)
                    }
                }
                .focused($focusedField, equals: .amount)
            }
            
            QuickAmounts()
            
            Picker(Constants.strings.type, selection: $addNewExpenseViewModel.expenseType){
                ForEach(fbViewModel.alltypesValues, id: \.self) { value in
                    Text(value).tag(value)
                }
            }
            .pickerStyle(DefaultPickerStyle())
        
            
            DatePicker(selection: $addNewExpenseViewModel.expenseDate, in: ...Date.now, displayedComponents: .date) {
                Text(Constants.strings.selectDate)
            }.tint(Constants.colors.lightPurpleColor)
            TextField(Constants.strings.notes, text: $addNewExpenseViewModel.expenseNotes, axis: .vertical)
                .frame(height: 200)
                .focused($focusedField, equals: .notes)
            
            if viewType != .view {
                Section {
                    Button(role: .cancel) {
                        Task{
                            if viewType == .add {
                                await addNewExpenseViewModel.addNewExpense(currencySelection: currencySelection)
                            }else if (viewType == .update){
                                await addNewExpenseViewModel.updateExpense(currencySelection: currencySelection)
                            }
                        }
                    } label:{
                        Text(viewType.butotnLabel)
                            .foregroundColor(Utils.getPurpleColor(colorScheme))
                    }
                }
            }
            
        }
        .disabled(viewType.isDisabled).opacity(viewType.isDisabled ? 0.7 : 1)
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
            AlertToast(type: .complete(.gray), title:addNewExpenseViewModel.successToastTitle , style: .style(titleColor: colorScheme == .light ? .black: .white))
        }
        .alert(Constants.strings.titleAmountErr, isPresented: $addNewExpenseViewModel.showingAlert) {
            Button(Constants.strings.ok, role: .cancel) { }
        }
    }
}

