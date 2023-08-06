//
//  AddNewExpense.swift
//  xSpend
//
//  Created by Mike Paraskevopoulos on 13/7/23.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import AlertToast

struct AddNewExpense: View {
    let db = Firestore.firestore()
    @State private var expenseTitle: String = ""
    @State private var expenseIcon: String = "eurosign.circle"
    @State private var expenseType: String = "Coffee"
    @State private var expenseNotes: String = ""
    @State private var expenseAmount: Float = 0.0
    @State var showingAlert = false
    @State var showSuccessToast = false
    @State private var alltypesValues = [String]()
    private let standardTypes = ["Coffee","Gas","Rent","Electricity"]
    let purpleColor = Color(red: 0.37, green: 0.15, blue: 0.80)
    
    func setUp(){
        getExpenseTypes()
    }
    
    func addNewExpense() {
        if (expenseAmount == 0){
            showingAlert = true
        }else{
            self.db.collection("Expenses")
                .addDocument(data: [
                    "title":expenseTitle,
                    "amount":expenseAmount,
                    "type":expenseType,
                    "notes":expenseNotes,
                    "user":Auth.auth().currentUser?.email as Any
                ]){ err in
                    if let err = err {
                        print("Error writing document: \(err)")
                    } else {
                        showSuccessToast = true
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
                        alltypesValues=standardTypes
                        for doc in snapshotDocuments{
                            let data = doc.data()
                            alltypesValues.append(data["name"] as! String)
                        }
                    }
                }
            }
    }
    
    
    var body: some View {
        NavigationView{
            ZStack{
                Form {
                    TextField("Title", text: $expenseTitle)
                    HStack{
                        Text("Amount:   ")
                        TextField("Amount", value: $expenseAmount,format:.number).keyboardType(.decimalPad).onReceive(NotificationCenter.default.publisher(for: UITextField.textDidBeginEditingNotification)) { obj in
                            if let textField = obj.object as? UITextField {
                                textField.selectedTextRange = textField.textRange(from: textField.beginningOfDocument, to: textField.endOfDocument)
                            }
                        }
                    }
                    Picker("Type", selection: $expenseType){
                        ForEach(alltypesValues, id: \.self) { value in
                            Text(value).tag(value)
                        }
                    }.pickerStyle(.navigationLink)
                    TextField("Notes", text: $expenseNotes, axis: .vertical).frame(height: 200)
                    Section {
                        Button(role: .cancel) {addNewExpense()} label:{Text("Add").foregroundColor(purpleColor)}
                            
                    }
                }.scrollDismissesKeyboard(.immediately)
            }.toast(isPresenting: $showSuccessToast) {
                AlertToast(type: .complete(.gray), title: "Expense Created", style: .style(titleColor: .white))
            }
            .alert("Title and Amout should be filled.", isPresented: $showingAlert) {
                Button("OK", role: .cancel) { }
            }
            .navigationBarTitle(Text("Add new expense"))
        }.onAppear{setUp()}
    }
}

struct AddNewExpense_Previews: PreviewProvider {
    static var previews: some View {
        AddNewExpense()
    }
}


extension View {
    func hideKeyboard() {
        let resign = #selector(UIResponder.resignFirstResponder)
        UIApplication.shared.sendAction(resign, to: nil, from: nil, for: nil)
    }
}

