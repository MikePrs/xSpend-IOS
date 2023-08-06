//
//  Expenses.swift
//  xSpend
//
//  Created by Mike Paraskevopoulos on 22/7/23.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct Expenses: View {
    let db = Firestore.firestore()
    @State private var expenses = [Expense]()
    
    func setUp() {
        getExpenses()
        print(expenses)
    }
    
    func getExpenses(){
        db.collection("Expenses")
            .whereField("user", isEqualTo: Auth.auth().currentUser?.email! as Any)
            .addSnapshotListener { querySnapshot, error in
                if error != nil {
                    print("Error geting Expense types")
                }else{
                    if let snapshotDocuments = querySnapshot?.documents{
                        expenses=[]
                        for doc in snapshotDocuments{
                            let data = doc.data()
                            expenses.append(Expense(id: doc.documentID, title: data["title"] as! String, amount: data["amount"] as! Float, type: data["type"] as! String, note:data["notes"] as! String ))
                        }
                    }
                }
            }
    }

    
    
    var body: some View {
        ZStack{
            List{
                ForEach(expenses) {ex in
                    Text(ex.title)
                }
            }
        }.onAppear{setUp()}
    }
}

struct Expenses_Previews: PreviewProvider {
    static var previews: some View {
        Expenses()
    }
}
