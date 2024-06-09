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
    @EnvironmentObject var fbViewModel : FirebaseViewModel

    @State private var showingSheet = false
    @State private var showingErrAlert = false
    @State var showSuccessToast = false
    @State var successToastText = ""
    @State private var ExpenseTypeName = ""
    @State private var iconPickerPresented = false
    @State private var icon = Constants.icon.noIcon
    @State private var alertMessage = ""

    func setUp()  {
        fbViewModel.getExpenseTypes()
    }
    
    func addNewExpenseType() async {
        
        let result = await fbViewModel.addNewExpenseType(expenseTypeName: ExpenseTypeName, icon: icon)
        
        switch result {
        case .success(true):
            showToast(text: Constants.strings.expenseCreated)
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
                showingSheet = false
            }
        default:
            showAlert(message: ExpenseTypeName == "" ? Constants.strings.expenseNameFilled : Constants.strings.duplicateExpenseType)
        }
        
    }
    
    func removeExpenseType(with docId:String) async{
       let res = await fbViewModel.removeExpenseType(with: docId)
        switch res {
        case .success(true):
            showToast(text:Constants.strings.deleteExpenseType)
        default:
            showAlert(message: Constants.strings.deleteExpenseTypeError)
        }
    }
    
    func showToast(text:String){
        showSuccessToast = true
        successToastText = Constants.strings.deleteExpenseType
    }
    
    func showAlert(message:String?) {
        alertMessage = message ?? ""
        showingErrAlert = true
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
                                        await removeExpenseType(with: type.id)
                                    }
                                }
                                .tint(.red)
                            }
                    }
                }
            }
            .navigationTitle(Text(Constants.strings.expenseTypes))
            .toast(isPresenting: $showSuccessToast) {
                AlertToast(type: .systemImage("trash",.gray), title: successToastText, style: .style(titleColor: .white))
            }
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button {
                        showingSheet = true
                    } label: {
                        Label(Constants.strings.add, systemImage: Constants.icon.plus).padding(.trailing).font(.system(size: 24)).foregroundColor(colorScheme == .light ? .black : .white)
                    }
                    .sheet(isPresented: $showingSheet) {
                        VStack(spacing: 20){
                            HStack {
                                Button(Constants.strings.back) {
                                    showingSheet = false
                                }
                                Spacer()
                            }.padding(.vertical)
                            Spacer()
                            Text(Constants.strings.newExpenseType).font(.system(size: 30))
                            HStack {
                                TextField(Constants.strings.enterNewExpenseType, text: $ExpenseTypeName)
                                    .frame(height: 45)
                                    .textFieldStyle(PlainTextFieldStyle())
                                    .padding([.horizontal], 4)
                                    .cornerRadius(10)
                                    .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.gray))
                                    .padding([.horizontal], 4)
                                Button {
                                    iconPickerPresented = true
                                } label: {
                                    ZStack{
                                        Rectangle()
                                            .fill(.gray)
                                            .frame(width: 45, height:45).cornerRadius(10)
                                        Image(systemName: icon).resizable().frame(width: 30,height: 30).foregroundColor(.white)
                                    }
                                }
                                .sheet(isPresented: $iconPickerPresented) {
                                    SymbolPicker(symbol: $icon)
                                }
                            }
                            Button(Constants.strings.add){
                                Task{
                                    await addNewExpenseType()
                                }
                            }.buttonStyle(.bordered).foregroundColor(colorScheme == .light ? Constants.colors.purpleColor: .white)
                            Spacer()
                        }.padding(.horizontal,40)
                        .toast(isPresenting: $showSuccessToast) {
                            AlertToast(type: .complete(.gray), title: successToastText, style: .style(titleColor: .white))
                        }
                        .alert(alertMessage, isPresented: $showingErrAlert) {
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
