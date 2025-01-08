//
//  ExpenseTypes.swift
//  xSpend
//
//  Created by Mike Paraskevopoulos on 1/8/23.
//

import SwiftUI
import SymbolPicker
import FirebaseAuth
import FirebaseFirestore
import AlertToast


struct ExpenseTypes: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) private var dismiss
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var fbViewModel: FirebaseViewModel
    @StateObject var expenseTypesViewModel = ExpenseTypesViewModel()
    @EnvironmentObject var router: Router
    
    func setUp()  {
        expenseTypesViewModel.configure(fbViewModel: fbViewModel)
    }
    
    func isStandartType(_ type:ExpenseType) -> Bool{
        return Constants.staticList.standardTypes.contains(where: { $0.name == type.name })
    }
    
    var body: some View {
            List{
                ForEach(fbViewModel.allTypes) {type in
                    HStack{
                        Text(type.name).foregroundColor(isStandartType(type) ? .gray : .none)
                        Spacer()
                        Image(systemName: type.icon).resizable()
                            .frame(width: 25, height: 25).foregroundColor((isStandartType(type) ? .gray : .none))
                        
                    }.frame(height: 40)
                        .swipeActions {
                            if !(isStandartType(type)){
                                Button(Constants.strings.delete) {
                                    expenseTypesViewModel.expenseTypeId = type.id
                                    expenseTypesViewModel.showingDeleteAlert = true
                                }
                                .tint(.red)
                                
                                Button(Constants.strings.edit) {
                                    Task{
                                        expenseTypesViewModel.showingSheet = true
                                        expenseTypesViewModel.icon = type.icon
                                        expenseTypesViewModel.expenseTypeName = type.name
                                        expenseTypesViewModel.expenseTypeId = type.id
                                        expenseTypesViewModel.action = .update
                                    }
                                }
                                .tint(Utils.getPurpleColor(colorScheme))
                            }
                        }
                }
            }
            .navigationTitle(Text(Constants.strings.expenseTypes))
            .navigationBarBackButtonHidden(true)
            .alert(Constants.strings.expensetypeDelete, isPresented: $expenseTypesViewModel.showingDeleteAlert) {
                Button(Constants.strings.no, role: .cancel) { 
                    expenseTypesViewModel.expenseTypeId = ""
                }
                Button(Constants.strings.delete, role: .destructive) { 
                    Task{
                        await expenseTypesViewModel.removeExpenseType()
                    }
                }
            }
            .toast(isPresenting: $expenseTypesViewModel.showSuccessToast) {
                AlertToast(type: .systemImage(Constants.icon.trash,.gray), title: expenseTypesViewModel.successToastText, style: .style(titleColor: .white))
            }
            .toolbar {
                ToolbarItemGroup(placement: .topBarLeading) {
                    HStack{
                        Image(systemName: Constants.icon.left)
                            .foregroundColor(Utils.getPurpleColor(colorScheme))
                        Text(Constants.strings.back)
                            .foregroundColor(Utils.getPurpleColor(colorScheme))
                    }.onTapGesture {
                        dismiss()
                    }
                }
                ToolbarItemGroup(placement: .topBarTrailing) {
                    AddExpenseTypeSheet(expenseTypesViewModel: expenseTypesViewModel)
                }
            }.tint(Utils.getPurpleColor(colorScheme))
        .onAppear {
            setUp()
        }
    }
}

//struct ExpenseTypes_Previews: PreviewProvider {
//    static var previews: some View {
//        ExpenseTypes()
//    }
//}
