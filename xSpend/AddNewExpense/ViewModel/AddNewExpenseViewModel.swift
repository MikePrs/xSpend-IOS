//
//  swift
//  xSpend
//
//  Created by Mike Paraskevopoulos on 9/6/24.
//

import Foundation
import FirebaseAuth

class AddNewExpenseViewModel: ObservableObject {
    private var fbViewModel : FirebaseViewModel?
    
    @Published var expenseTitle: String = ""
    @Published var expenseType: String = "Coffee"
    @Published var expenseCurrency: String = ""
    @Published var expenseDate = Date.now
    @Published var expenseNotes: String = ""
    @Published var expenseAmount: Float? = nil
    @Published var showingAlert = false
    @Published var alertMessage = ""
    @Published var showSuccessToast = false
    @Published var successToastTitle = ""
    @Published var expensedocId = ""
    @Published var expense : Expense?
    @Published var countryCourency = CountryCurrencyCode()
    @Published var detailViewType:ExpenseDetailViewType = .view
    
    func configure(fbViewModel:FirebaseViewModel, expense :Expense? = nil, currencySelection:String? = nil){
        self.fbViewModel = fbViewModel
        
        
        if let exp = expense {
            self.expensedocId = exp.id
            self.expenseTitle = exp.title
            self.expenseType = exp.type
            if let date = Utils.convertStringToDate(exp.date){
                self.expenseDate = date
            }
            self.expenseNotes = exp.note
            self.expenseAmount = exp.amount
            self.expenseCurrency = exp.currency
        }else{
            if let country = currencySelection{
                self.expenseCurrency = countryCourency.countryCurrency[country] ?? ""
            }
        }
        
    }
    
    func updateExpense(currencySelection:String) async {
        if (expenseAmount == 0 || expenseAmount == nil ){
            self.showAlert(message: Constants.error.amountAmountErr)
        }else{
            let result = await self.fbViewModel?.updateExpense(docId: expensedocId, expense:getExpense(currencySelection) as [String : Any] )
            switch result {
            case .success(true):
                DispatchQueue.main.async {
                    self.showSuccessToast = true
                    self.successToastTitle = Constants.strings.expenseUpdated
                }
            case .failure(let err):
                self.showAlert(message: err.errString)
            default:
                self.showAlert(message: "\(FirebaseError.unknown)")
            }
        }
    }
    
    func addNewExpense(currencySelection:String) async {
        if (expenseAmount == 0 || expenseAmount == nil ){
            self.showAlert(message: Constants.error.amountAmountErr)
        }else{
            let result = await self.fbViewModel?.addNewExpense(newExpense: getExpense(currencySelection) as [String : Any])
            switch result {
            case .success(true):
                DispatchQueue.main.async {
                    self.resetFields()
                    self.showSuccessToast = true
                    self.successToastTitle = Constants.strings.expenseCreated
                }
            case .failure(let err):
                self.showAlert(message: err.errString)
            default:
                self.showAlert(message: FirebaseError.unknown.errString)
            }
        }
    }
    
    private func getExpense(_ currencySelection:String) -> [String:Any]{
        let formatter4 = DateFormatter()
        formatter4.dateFormat = "d/M/YYYY"
        return [
            Constants.firebase.title : expenseTitle,
            Constants.firebase.amount : expenseAmount ?? 0,
            Constants.firebase.type : expenseType,
            Constants.firebase.notes : expenseNotes,
            Constants.firebase.user : Auth.auth().currentUser?.email as Any,
            Constants.firebase.timestamp : Utils.startOfDayTimestamp(for:   Date(timeIntervalSince1970:expenseDate.timeIntervalSince1970) ) ,
            Constants.firebase.date : formatter4.string(from: expenseDate),
            Constants.firebase.currency :  CountryCurrencyCode().countryCurrency[currencySelection] as Any
        ]
    }
    
    private func resetFields(){
            self.expenseTitle = ""
            self.expenseNotes = ""
            self.expenseAmount = nil
    }
    
    
    private func showAlert(message:String){
        DispatchQueue.main.async {
            self.showingAlert = true
            self.alertMessage = message
        }
    }
}
