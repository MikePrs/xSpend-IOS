//
//  swift
//  xSpend
//
//  Created by Mike Paraskevopoulos on 9/6/24.
//

import Foundation
import FirebaseAuth

enum AddExpensesField: Hashable {
    case title,amount,type,date,notes,end
    
    var next:AddExpensesField? {
        switch self {
        case .title:
            return .amount
        case .amount:
            return .notes
        default:
            return nil
        }
    }
}

class AddNewExpenseViewModel: ObservableObject {
    private var fbViewModel : FirebaseViewModel?
    
    @Published var expenseTitle: String = ""
    @Published var expenseType: String = "Coffee"
    @Published var expenseDate = Date.now
    @Published var expenseNotes: String = ""
    @Published var expenseAmount: Float? = nil
    @Published var showingAlert = false
    @Published var showSuccessToast = false
    
    func configure(fbViewModel:FirebaseViewModel){
        self.fbViewModel = fbViewModel
    }
    
    func addNewExpense(currencySelection:String) async {
        if (expenseAmount == 0 || expenseAmount == nil ){
            showingAlert = true
        }else{
            let formatter4 = DateFormatter()
            formatter4.dateFormat = "d/M/YYYY"
            let newExpense = [
                Constants.firebase.title : expenseTitle,
                Constants.firebase.amount : expenseAmount ?? 0,
                Constants.firebase.type : expenseType,
                Constants.firebase.notes : expenseNotes,
                Constants.firebase.user : Auth.auth().currentUser?.email as Any,
                Constants.firebase.timestamp :  expenseDate.timeIntervalSince1970,
                Constants.firebase.date : formatter4.string(from: expenseDate),
                Constants.firebase.currency :  CountryCurrencyCode().countryCurrency[currencySelection] as Any
            ]
            let result = await self.fbViewModel?.addNewExpense(newExpense: newExpense as [String : Any])
            switch result {
            case .success(true):
                DispatchQueue.main.async {
                    self.expenseTitle = ""
                    self.expenseType = ""
                    self.expenseNotes = ""
                    self.expenseAmount = nil
                    self.showSuccessToast = true
                }
            default:
                DispatchQueue.main.async {
                    self.showingAlert = true
                }
            }
            
        }
    }
}
