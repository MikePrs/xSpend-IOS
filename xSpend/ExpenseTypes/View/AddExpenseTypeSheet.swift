//
//  AddExpenseTypeSheet.swift
//  xSpend
//
//  Created by Mike Paraskevopoulos on 12/6/24.
//

import SwiftUI
import SymbolPicker
import AlertToast

enum ExpenseTypeAction {
    case add, update
}

struct AddExpenseTypeSheet: View {
    @Environment(\.colorScheme) var colorScheme

    @ObservedObject var expenseTypesViewModel : ExpenseTypesViewModel
    
    var body: some View {
        Button {
            expenseTypesViewModel.showingSheet = true
            expenseTypesViewModel.action = .add
            expenseTypesViewModel.icon = Constants.icon.noIcon
            expenseTypesViewModel.expenseTypeName = ""
        } label: {
            Label(Constants.strings.add, systemImage: Constants.icon.plus).padding(.trailing).font(.system(size: 24)).foregroundColor(colorScheme == .light ? .black : .white)
        }
        .sheet(isPresented: $expenseTypesViewModel.showingSheet) {
            VStack(spacing: 20){
                HStack {
                    Button(Constants.strings.back) {
                        expenseTypesViewModel.showingSheet = false
                    }
                    Spacer()
                }.padding(.vertical)
                Spacer()
                Text(expenseTypesViewModel.action == .add ? Constants.strings.newExpenseType : Constants.strings.updateExpenseType)
                    .font(.system(size: 30))
                HStack {
                    TextField(Constants.strings.enterExpenseType, text: $expenseTypesViewModel.expenseTypeName)
                        .frame(height: 45)
                        .textFieldStyle(PlainTextFieldStyle())
                        .padding([.horizontal], 4)
                        .cornerRadius(10)
                        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.gray))
                        .padding([.horizontal], 4)
                    Button {
                        expenseTypesViewModel.iconPickerPresented = true
                    } label: {
                        ZStack{
                            Rectangle()
                                .fill(.gray)
                                .frame(width: 45, height:45).cornerRadius(10)
                            Image(systemName: expenseTypesViewModel.icon).resizable().frame(width: 30,height: 30).foregroundColor(.white)
                        }
                    }
                    .sheet(isPresented: $expenseTypesViewModel.iconPickerPresented) {
                        SymbolPicker(symbol: $expenseTypesViewModel.icon)
                    }
                }
                Button(expenseTypesViewModel.action == .add ? Constants.strings.add : Constants.strings.update){
                    Task{
                        expenseTypesViewModel.action == .add ?
                        await expenseTypesViewModel.addNewExpenseType()
                        :
                        await expenseTypesViewModel.editExpenseType(with: expenseTypesViewModel.expenseTypeId)
                    }
                }.buttonStyle(.bordered).foregroundColor(colorScheme == .light ? Constants.colors.purpleColor: .white)
                Spacer()
            }.padding(.horizontal,40)
                .toast(isPresenting: $expenseTypesViewModel.showSuccessToast) {
                    AlertToast(type: .complete(.gray), title: expenseTypesViewModel.successToastText, style: .style(titleColor: .white))
                }
                .alert(expenseTypesViewModel.alertMessage, isPresented: $expenseTypesViewModel.showingErrAlert) {
                    Button(Constants.strings.ok, role: .cancel) { }
                }
        }
    }
}

