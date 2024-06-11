//
//  ExpenseTypesViewModel.swift
//  xSpend
//
//  Created by Mike Paraskevopoulos on 11/6/24.
//

import Foundation

class ExpenseTypesViewModel:ObservableObject{
    private var fbViewModel : FirebaseViewModel?

    @Published var showingSheet:Bool = false
    @Published var showingErrAlert:Bool = false
    @Published var showSuccessToast:Bool = false
    @Published var successToastText = ""
    @Published var expenseTypeName = ""
    @Published var iconPickerPresented:Bool = false
    @Published var icon = Constants.icon.noIcon
    @Published var alertMessage = ""
    
    func configure(fbViewModel:FirebaseViewModel){
        self.fbViewModel = fbViewModel
        self.fbViewModel?.getExpenseTypes()
    }
    
    
    func addNewExpenseType() async {
        
        let result = await fbViewModel?.addNewExpenseType(expenseTypeName: expenseTypeName, icon: icon)
        DispatchQueue.main.async {
            switch result {
            case .success(true):
                self.showToast(text: Constants.strings.expenseCreated)
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
                    self.showingSheet = false
                }
            default:
                self.showAlert(message: self.expenseTypeName == "" ? Constants.strings.expenseNameFilled : Constants.strings.duplicateExpenseType)
            }
        }
    }
    
    func removeExpenseType(with docId:String) async{
        let res = await fbViewModel?.removeExpenseType(with: docId)
        DispatchQueue.main.async {
            switch res {
            case .success(true):
                self.showToast(text:Constants.strings.deleteExpenseType)
            default:
                self.showAlert(message: Constants.strings.deleteExpenseTypeError)
            }
        }
    }
    
    func editExpenseType(with docId:String) async {
        
    }
    
    func showToast(text:String){
        DispatchQueue.main.async {
            self.showSuccessToast = true
            self.successToastText = text
        }
    }
    
    func showAlert(message:String?) {
        DispatchQueue.main.async {
            self.alertMessage = message ?? ""
            self.showingErrAlert = true
        }
    }
}
