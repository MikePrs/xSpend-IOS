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
    let standardTypes = ["Coffee","Gas","Rent","Electricity"]

    
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

}

