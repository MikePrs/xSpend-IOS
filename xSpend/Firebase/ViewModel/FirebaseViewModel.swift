//
//  FirebaseViewModel.swift
//  xSpend
//
//  Created by Mike Paraskevopoulos on 29/10/23.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

public class FirebaseViewModel: ObservableObject {
    let db = Firestore.firestore()
    @Published var alltypesValues = [String]()
    let standardTypesString = Constants.staticList.standardStringType
    let standardTypes = Constants.staticList.standardTypes
    @Published var alltypesValueIcon : [String:String] =  Constants.staticList.alltypesValueIcon
    @Published var allTypes = [ExpenseType]()
    @Published var exchangeRates = ExchangeRatesViewModel()

//    let shared = FirebaseViewModel()
    
    public init(){}
    
    func getExpenseTypes(){
        db.collection(Constants.firebase.expenseTypes)
            .whereField(Constants.firebase.user, isEqualTo: Auth.auth().currentUser?.email! as Any)
            .addSnapshotListener { [self] querySnapshot, error in
                if error != nil {
                    print("Error geting Expense types")
                }else{
                    if let snapshotDocuments = querySnapshot?.documents{
                        alltypesValues=standardTypesString
                        allTypes=standardTypes
                        for doc in snapshotDocuments{
                            let data = doc.data()
                            if let name = data[Constants.firebase.name] as? String , let icon = data[Constants.firebase.icon] as? String{
                                alltypesValues.append(name)
                                alltypesValueIcon[name] = icon
                                allTypes.append(ExpenseType(id:doc.documentID,
                                    name:name, icon:icon
                                ))
                            }
                        }
                    }
                }
            }
    }
    
    func getUserTarget(completion: @escaping (String?) -> Void){
        db.collection(Constants.firebase.usersTargets).document((Auth.auth().currentUser?.email)!)
            .addSnapshotListener { querySnapshot, error in
                if error != nil {
                    print("Error geting Expense types: \(String(describing: error))")
                }else{
                    if let userTarget = querySnapshot?.data()?["target"] as? String {
                        completion(userTarget)
                    }
                }
            }
    }
    
    func setUsersTarget(target:String) async -> Result<Bool, FirebaseError> {
            if let email = (Auth.auth().currentUser?.email) {
            do {
                let _ = try await self.db.collection(Constants.firebase.usersTargets)
                    .document(email as String)
                    .setData(["target": target])
                return .success(true)
            }catch{
                return .failure(.firebaseAddExpenseErr)
            }
        }else{
            return .failure(.firebaseAddExpenseErr)
        }
    }
    
    func firebaseDelete(with docId:String, at collectionName:String) async -> Result<Bool, FirebaseError> {
        do{
            let _ = try await db.collection(collectionName).document(docId).delete()
            return .success(true)
        }catch{
            return .failure(.firebaseErrDelete)
        }
    }
    
    func addNewExpense(newExpense:[String:Any]) async -> Result<Bool, FirebaseError> {
        do {
            let _ = try await self.db.collection(Constants.firebase.expenses)
                .addDocument(data: newExpense)
            return .success(true)
        }catch{
            return .failure(.firebaseAddExpenseErr)
        }
    }
    
    func addNewExpenseType(expenseTypeName:String, icon:String) async -> Result<Bool, FirebaseError> {
        if (expenseTypeName == "" || alltypesValues.contains(expenseTypeName)){
            return .failure(.firebaseExpenseTypeFillErr(expenseTypeName))
        }else{
            do {
               _ = try await self.db.collection(Constants.firebase.expenseTypes)
                    .addDocument(data: [
                        Constants.firebase.name:expenseTypeName,
                        Constants.firebase.icon:icon,
                        Constants.firebase.user:Auth.auth().currentUser?.email as Any
                    ])
                return .success(true)
            }catch{
                return .failure(.firebaseAddExpenseTypeErr)
            }
        }
    }
    
    func updateExpenseType(expenseTypeName:String, icon:String, docId:String) async -> Result<Bool, FirebaseError> {
        if (expenseTypeName == "" || alltypesValues.contains(expenseTypeName)){
            return .success(false)
        }else{
            do {
               _ = try await self.db.collection(Constants.firebase.expenseTypes).document(docId)
                    .updateData([
                        Constants.firebase.name:expenseTypeName,
                        Constants.firebase.icon:icon,
                        Constants.firebase.user:Auth.auth().currentUser?.email as Any
                    ])
                return .success(true)
            }catch{
                return .failure(.firebaseUpdateExpenseTypeErr)
            }
        }
    }
    
    func updateExpense(docId:String, expense:[String:Any]) async -> Result<Bool, FirebaseError> {
        do {
            _ = try await self.db.collection(Constants.firebase.expenses).document(docId)
                .updateData(expense)
            return .success(true)
        }catch{
            return .failure(.firebaseUpdateExpenseErr)
        }
    }
    
    func getConvertedValue(baseCurrencyAmount:Double, from: String, to: String) async -> (String) {
       let res = await exchangeRates.getExchangeRate(baseCurrencyAmount: baseCurrencyAmount, from: from, to: to)
        
        switch res {
        case .success(let conversion):
            return String(format: "%.2f", conversion)
        case .failure(let err):
            return err.errString
        }
    }
    
    func fetchExpenses(from:Date , to:Date, category:String, min:Float? = nil, max:Float? = nil, currency: String) async -> Result<[SectionedExpenses], FirebaseError> {
        var sectioned = [String:[Expense]]()
        
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
        
        do {
            let snapshot = try await query.getDocuments()
                
                for data in snapshot.documents {
                    
                    var convertedAmount = ""
                    if data[Constants.firebase.currency] as! String != currency {
                        convertedAmount = await getConvertedValue(
                            baseCurrencyAmount: Double( data[Constants.firebase.amount] as! Float),
                            from: data[Constants.firebase.currency] as! String, to: currency
                        )
                    }
                    
                    let exp = Expense(
                        id: data.documentID,
                        title: data[Constants.firebase.title] as! String,
                        amount: data[Constants.firebase.amount] as! Float,
                        type: data[Constants.firebase.type] as! String,
                        note: data[Constants.firebase.notes] as! String,
                        date: data[Constants.firebase.date] as! String,
                        currency: data[Constants.firebase.currency] as! String,
                        amountConverted: convertedAmount
                    )
                    
                    sectioned[exp.date, default: []].append(exp)
                }
            return .success(self.formatExpenseData(sectioned: sectioned))
        } catch {
            return .failure(.firebaseErrGetExpense)
        }
    }
    
    func formatExpenseData(sectioned:[String:[Expense]]) -> [SectionedExpenses] {
        var expenseSect = [SectionedExpenses]()
        for expense in sectioned.values {
            expenseSect.append(SectionedExpenses(id: expense[0].date, expenses: expense))
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        expenseSect = expenseSect.sorted{dateFormatter.date(from: $0.id)! > dateFormatter.date(from: $1.id)!}
        
        return expenseSect
    }
}

