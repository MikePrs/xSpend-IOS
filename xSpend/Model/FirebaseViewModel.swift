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
    @Published var alltypesValueIcon : [String:String] = ["Coffee":"cup.and.saucer.fill","Gas":"fuelpump.circle","Rent":"house.circle","Electricity":"bolt.circle"]
    
    func getExpenseTypes(){
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
                            if let name = data["name"] as? String , let icon = data["icon"] as? String{
                                    alltypesValues.append(name)
                                    alltypesValueIcon[name] = icon
                            }
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
    
    func getExpenses(from:Date , to:Date, category:String ) {
        var query = db.collection("Expenses")
            .whereField("user", isEqualTo: Auth.auth().currentUser?.email! as Any)
            .whereField("timestamp", isLessThanOrEqualTo: to.timeIntervalSince1970)
            .whereField("timestamp", isGreaterThanOrEqualTo: from.timeIntervalSince1970)
                
        if(category != "Any"){
            query = query.whereField("type",isEqualTo: category)
        }
        
        query.addSnapshotListener { [self] querySnapshot, error in
                
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
    }
}

