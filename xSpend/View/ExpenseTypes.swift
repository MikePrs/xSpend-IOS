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

    let db = Firestore.firestore()
    @State private var showingAlert = false
    @State private var showingErrAlert = false
    @State var showSuccessToast = false
    @State private var ExpenseTypeName = ""
    @State private var iconPickerPresented = false
    @State private var icon = Constants.icon.noIcon
    @State private var alertMessage = ""
    @State private var alltypesValues = [String]()
    @State var standardTypes = Constants.staticList.standardTypes
    @State var allTypes = [ExpenseType]()

    func setUp() {
        getExpenseTypes()
    }
    
    func addNewExpenseType() async {
        
        let result = await fbViewModel.addNewExpenseType(expenseTypeName: ExpenseTypeName, icon: icon)
        
        switch result {
        case .success(true):
            showSuccessToast = true
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
                showingAlert = false
            }
        default:
            alertMessage = ExpenseTypeName == "" ? Constants.strings.expenseNameFilled : Constants.strings.duplicateExpenseType
            showingErrAlert = true
        }
        
    }
    
    func getExpenseTypes(){
        db.collection(Constants.firebase.expenseTypes)
            .whereField(Constants.strings.user, isEqualTo: Auth.auth().currentUser?.email! as Any)
            .addSnapshotListener { querySnapshot, error in
                if error != nil {
                    print("Error geting Expense types")
                }else{
                    if let snapshotDocuments = querySnapshot?.documents{
                        allTypes=standardTypes
                        for doc in snapshotDocuments{
                            let data = doc.data()
                            allTypes.append(ExpenseType(id:doc.documentID, name:data[Constants.firebase.name] as! String, icon:data[Constants.firebase.icon] as! String))
                            alltypesValues.append(data[Constants.firebase.name] as! String)
                        }
                    }
                }
            }
    }
    
    func removeExpenseType(with docId:String){
        db.collection(Constants.firebase.expenseTypes).document(docId).delete() { err in
            if let err = err {
              print("Error removing document: \(err)")
            }
            else {
              print("Document successfully removed!")
            }
          }
    }
    
    var body: some View {
        NavigationStack{
            List{
                ForEach(allTypes) {type in
                    if standardTypes.contains(where: { $0.name == type.name }){
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
                                    removeExpenseType(with: type.id)
                                }
                                .tint(.red)
                            }
                    }
                }
            }
            .navigationTitle(Text(Constants.strings.expenseTypes))
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button {
                        showingAlert = true
                    } label: {
                        Label(Constants.strings.add, systemImage: Constants.icon.plus).padding(.trailing).font(.system(size: 24)).foregroundColor(colorScheme == .light ? .black : .white)
                    }
                    .sheet(isPresented: $showingAlert) {
                        VStack(spacing: 20){
                            HStack {
                                Button(Constants.strings.back) {
                                    showingAlert = false
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
                            AlertToast(type: .complete(.gray), title: Constants.strings.expenseCreated, style: .style(titleColor: .white))
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
