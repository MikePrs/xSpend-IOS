//
//  ExpenseDetail.swift
//  xSpend
//
//  Created by Mike Paraskevopoulos on 12/6/24.
//

import SwiftUI
import AlertToast

enum ExpenseDetailViewType {
    case add, update, view
    
    var title : String{
        switch self {
        case .add:
            return Constants.strings.addNewExpense
        case .update:
            return Constants.strings.updateExpense
        case .view:
            return Constants.strings.reviewExpense
        }
    }
    
    var butotnLabel:String{
        switch self {
        case . add:
            return Constants.strings.add
        case .update:
            return Constants.strings.update
        case .view:
            return Constants.strings.edit
        }
    }
    
    var isDisabled:Bool{
        switch self {
        case .add, .update:
            return false
        default:
            return true
        }
    }
}

struct ExpenseDetail: View {
    @FocusState private var focusedField: AddExpensesField?
    @ObservedObject var addNewExpenseViewModel : AddNewExpenseViewModel
    @ObservedObject var fbViewModel : FirebaseViewModel
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) private var dismiss
    @AppStorage(Constants.appStorage.currencySelection) private var currencySelection: String = ""
    @State var viewType: ExpenseDetailViewType
    
    var body: some View {
        Form {
            if viewType != .add{
                HStack {
                    Button(Constants.strings.back) {
                        dismiss()
                    }.tint(Utils.getPurpleColor(colorScheme))
                    Spacer()
                }.padding(.vertical)
            }
            
            Text(viewType.title)
                .font(.title)
                .fontWeight(.bold)
            HStack{
                Text(Constants.strings.title+": ")
                TextField("", text: $addNewExpenseViewModel.expenseTitle)
                    .focused($focusedField, equals: .title).disabled(viewType.isDisabled)
            }
            
            HStack{
                Text(Constants.strings.amountSpace)
                TextField(Constants.strings.amount, value: $addNewExpenseViewModel.expenseAmount,format:.number)
                .keyboardType(.decimalPad)
                .disabled(viewType.isDisabled)
                .onReceive(NotificationCenter.default.publisher(for: UITextField.textDidBeginEditingNotification)) { obj in
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
            }.pickerStyle(.navigationLink).disabled(viewType.isDisabled)
            DatePicker(selection: $addNewExpenseViewModel.expenseDate, in: ...Date.now, displayedComponents: .date) {
                Text(Constants.strings.selectDate)
            }.disabled(viewType.isDisabled).tint(Constants.colors.lightPurpleColor)
            TextField(Constants.strings.notes, text: $addNewExpenseViewModel.expenseNotes, axis: .vertical).disabled(viewType.isDisabled)
                .frame(height: 200).focused($focusedField, equals: .notes)
                Section {
                    Button(role: .cancel) {
                        Task{
                            if viewType == .add {
                                await addNewExpenseViewModel.addNewExpense(currencySelection: currencySelection)
                            }else if (viewType == .update){
                                
                            }else {
                                viewType = .update
                            }
                        }
                    } label:{
                        Text(viewType.butotnLabel)
                            .foregroundColor(Utils.getPurpleColor(colorScheme))
                    }
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

