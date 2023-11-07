//
//  FirebaseViewModel.swift
//  xSpend
//
//  Created by Mike Paraskevopoulos on 29/10/23.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

class FirebaseViewModel: ObservableObject {
    let db = Firestore.firestore()
    @Published var alltypesValues = [String]()
//    @Published var expenses = [Expense]()
    let standardTypes = ["Coffee","Gas","Rent","Electricity"]
    var sectioned = [String:[Expense]]()
    @Published var expenseSectioned = [SectionedExpenses]()
    
    func getExpenseTypes(){
        print(Date.now)
        db.collection("ExpenseTypes")
            .whereField("user", isEqualTo: Auth.auth().currentUser?.email! as Any)
            .addSnapshotListener { [self] querySnapshot, error in
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

    func addNewExpense(newExpense:[String:Any])->Bool {
        var success = true
        self.db.collection("Expenses")
            .addDocument(data: newExpense){ err in
                if let err = err {
                    success = false
                    print("Error writing document: \(err)")
                }
            }
        return success
    }
    
    func getExpenses(from:Date , to:Date) {
//        print(to,to.timeIntervalSince1970)
//        print(from, from.timeIntervalSince1970)
        db.collection("Expenses")
            .whereField("user", isEqualTo: Auth.auth().currentUser?.email! as Any)
            .whereField("timestamp", isLessThanOrEqualTo: to.timeIntervalSince1970)
            .whereField("timestamp", isGreaterThanOrEqualTo: from.timeIntervalSince1970)
            .addSnapshotListener { [self] querySnapshot, error in
                
                    if error != nil {
                        print("Error geting Expenses")
                    }else{
                        if let snapshotDocuments = querySnapshot?.documents{
//                            expenses=[]
                            self.sectioned = [:]
                            for doc in snapshotDocuments{
//                                print("snapshot proccess")
                                let data = doc.data()
                                let exp = Expense(id: doc.documentID, title: data["title"] as! String, amount: data["amount"] as! Float, type: data["type"] as! String, note:data["notes"] as! String, date: data["date"] as! String )
//                                    expenses.append(exp)
                                self.sectioned[exp.date, default: []].append(exp)
                                
                            }
//                            print("format")
                            formatData()
                        }
                    }
                
            }
    }
    
    
    func formatData() {
        expenseSectioned=[]
        for expense in sectioned.values {
            expenseSectioned.append(SectionedExpenses(id: expense[0].date, expenses: expense))
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        expenseSectioned = expenseSectioned.sorted{dateFormatter.date(from: $0.id)! > dateFormatter.date(from: $1.id)!}
//        print(expenseSectioned)
    }
}

