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
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var fbViewModel = FirebaseViewModel()
    @ObservedObject var expenseTypesViewModel = ExpenseTypesViewModel()

    func setUp()  {
        expenseTypesViewModel.configure(fbViewModel: fbViewModel)
    }
    
    var body: some View {
        NavigationStack{
            List{
                ForEach(fbViewModel.allTypes) {type in
                    if Constants.staticList.standardTypes.contains(where: { $0.name == type.name }){
                        HStack{
                            Text(type.name).foregroundColor(.gray)
                            Spacer()
                            Image(systemName: type.icon).resizable().foregroundColor(.gray)
                                .frame(width: 25, height: 25)
                            
                        }.frame(height: 40)
                    }else{
                        HStack{
                            Text(type.name)
                            Spacer()
                            Image(systemName: type.icon).resizable()
                                .frame(width: 25, height: 25)
                            
                        }.frame(height: 40)
                            .swipeActions {
                                Button(Constants.strings.delete) {
                                    Task{
                                        await expenseTypesViewModel.removeExpenseType(with: type.id)
                                    }
                                }
                                .tint(.red)
                            }
                    }
                }
            }
            .navigationTitle(Text(Constants.strings.expenseTypes))
            .toast(isPresenting: $expenseTypesViewModel.showSuccessToast) {
                AlertToast(type: .systemImage("trash",.gray), title: expenseTypesViewModel.successToastText, style: .style(titleColor: .white))
            }
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    AddExpenseTypeSheet(expenseTypesViewModel: expenseTypesViewModel)
                    }
            }
        }.onAppear {
            setUp()
        }
    }
}

struct ExpenseTypes_Previews: PreviewProvider {
    static var previews: some View {
        ExpenseTypes()
    }
}
