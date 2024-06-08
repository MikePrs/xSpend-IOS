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
    let standardTypes = Constants.staticList.standardStringType
    var sectioned = [String:[Expense]]()
    @Published var expenseSectioned = [SectionedExpenses]()
    @Published var alltypesValueIcon : [String:String] =  Constants.staticList.alltypesValueIcon
    
    func getExpenseTypes(){
        db.collection(Constants.firebase.expenseTypes)
            .whereField(Constants.firebase.user, isEqualTo: Auth.auth().currentUser?.email! as Any)
            .addSnapshotListener { [self] querySnapshot, error in
                if error != nil {
                    print("Error geting Expense types")
                }else{
                    if let snapshotDocuments = querySnapshot?.documents{
                        alltypesValues=standardTypes
                        for doc in snapshotDocuments{
                            let data = doc.data()
                            if let name = data[Constants.firebase.name] as? String , let icon = data[Constants.firebase.icon] as? String{
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
        self.db.collection(Constants.firebase.expenses)
            .addDocument(data: newExpense){ err in
                if let err = err {
                    success = false
                    print("Error writing document: \(err)")
                }
            }
        return success
    }
    
    func getExpenses(from:Date , to:Date, category:String, min:Float? = nil, max:Float? = nil ) {
        var query = db.collection(Constants.firebase.expenses)
            .whereField(Constants.firebase.user, isEqualTo: Auth.auth().currentUser?.email! as Any)
            .whereField(Constants.firebase.timestamp, isLessThanOrEqualTo: to.timeIntervalSince1970)
            .whereField(Constants.firebase.timestamp, isGreaterThanOrEqualTo: from.timeIntervalSince1970)
        
        if let minAmount = min , minAmount != 0  {
            query = query.whereField(Constants.firebase.amount,isGreaterThanOrEqualTo: minAmount)
        }
        
        if let maxAmount = max , maxAmount != 0 {
            query = query.whereField(Constants.firebase.amount,isLessThanOrEqualTo: maxAmount)
        }
        
        if(category != Constants.strings.any){
            query = query.whereField(Constants.firebase.type,isEqualTo: category)
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
                        print(doc.documentID)
                        let exp = Expense(id: doc.documentID, title: data[Constants.firebase.title] as! String, amount: data[Constants.firebase.amount] as! Float, type: data[Constants.firebase.type] as! String, note:data[Constants.firebase.notes] as! String, date: data[Constants.firebase.date] as! String, currency: data[Constants.firebase.currency] as! String )
                        //                                    expenses.append(exp)
                        print(exp)
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

