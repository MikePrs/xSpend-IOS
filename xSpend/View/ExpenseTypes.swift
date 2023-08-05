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
    let db = Firestore.firestore()
    @State private var showingAlert = false
    @State private var showingErrAlert = false
    @State var showSuccessToast = false
    @State private var ExpenseTypeName = ""
    @State private var iconPickerPresented = false
    @State private var icon = "questionmark.square.dashed"
    @State var standardTypes = [
        ExpenseType(id: "0", name:"Coffee",icon:"cup.and.saucer.fill"),
        ExpenseType(id: "1", name:"Gas",icon:"fuelpump.circle"),
        ExpenseType(id: "2", name:"Rent",icon:"house.circle"),
        ExpenseType(id: "3", name:"Electricity",icon:"bolt.circle")
    ]
    @State var allTypes = [ExpenseType]()
    let purpleColor = Color(red: 0.37, green: 0.15, blue: 0.80)

    func setUp() {
        getExpenseTypes()
    }
    
    func addNewExpenseType() {
        if (ExpenseTypeName == ""){
            showingErrAlert = true
        }else{
            self.db.collection("ExpenseTypes")
                .addDocument(data: [
                    "name":ExpenseTypeName,
                    "icon":icon,
                    "user":Auth.auth().currentUser?.email as Any
                ]){ err in
                    if let err = err {
                        print("Error writing document: \(err)")
                    } else {
                        showSuccessToast = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
                            showingAlert = false
                        }
                        print("Document successfully written!")
                    }
                }
        }
    }
    
    func getExpenseTypes(){
        db.collection("ExpenseTypes")
            .whereField("user", isEqualTo: Auth.auth().currentUser?.email! as Any)
            .addSnapshotListener { querySnapshot, error in
                if error != nil {
                    print("Error geting Expense types")
                }else{
                    if let snapshotDocuments = querySnapshot?.documents{
                        allTypes=standardTypes
                        for doc in snapshotDocuments{
                            let data = doc.data()
                            allTypes.append(ExpenseType(id:doc.documentID, name:data["name"] as! String, icon:data["icon"] as! String))
                        }
                    }
                }
            }
    }
    
    func removeExpenseType(with docId:String){
        db.collection("ExpenseTypes").document(docId).delete() { err in
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
                                Button("Delete") {
                                    removeExpenseType(with: type.id)
                                }
                                .tint(.red)
                            }
                    }
                }
            }
            .navigationTitle(Text("Expense Types"))
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button {
                        showingAlert = true
                    } label: {
                        Label("Add", systemImage: "plus").padding(.trailing).font(.system(size: 24)).foregroundColor(colorScheme == .light ? .black : .white)
                    }
                    .sheet(isPresented: $showingAlert) {
                        VStack(spacing: 20){
                            HStack {
                                Button("Back") {
                                    showingAlert = false
                                }
                                Spacer()
                            }.padding(.vertical)
                            Spacer()
                            Text("New Expense type").font(.system(size: 30))
                            HStack {
                                TextField("Enter new expense type name", text: $ExpenseTypeName)
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
                            Button("Add"){addNewExpenseType()}.buttonStyle(.bordered).foregroundColor(colorScheme == .light ? purpleColor: .white)
                            Spacer()
                        }.padding(.horizontal,40)
                        .toast(isPresenting: $showSuccessToast) {
                            AlertToast(type: .complete(.gray), title: "Expense Created", style: .style(titleColor: .white))
                        }
                        .alert("Expense name should be filled.", isPresented: $showingErrAlert) {
                            Button("OK", role: .cancel) { }
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
