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
                    Button {
                        expenseTypesViewModel.showingSheet = true
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
                            Text(Constants.strings.newExpenseType).font(.system(size: 30))
                            HStack {
                                TextField(Constants.strings.enterNewExpenseType, text: $expenseTypesViewModel.expenseTypeName)
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
                            Button(Constants.strings.add){
                                Task{
                                    await expenseTypesViewModel.addNewExpenseType()
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
