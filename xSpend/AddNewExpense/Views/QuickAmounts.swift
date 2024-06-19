//
//  QuickAmounts.swift
//  xSpend
//
//  Created by Paraskevopoulos, Michail on 19/6/24.
//

import SwiftUI

struct QuickAmounts: View {
    @ObservedObject var addNewExpenseViewModel:AddNewExpenseViewModel
    
    func quickBtnAction(_ value:String ){
        if let floatValue = Float(value) {
            addNewExpenseViewModel.expenseAmount =
            (addNewExpenseViewModel.expenseAmount ?? 0) + floatValue
        }
    }
    
    var body: some View {
        HStack{
            QuickAmountButton(value: "1") {quickBtnAction("1")}
            QuickAmountButton(value: "2") {quickBtnAction("2")}
            QuickAmountButton(value: "5") {quickBtnAction("5")}
            QuickAmountButton(value: "10") {quickBtnAction("10")}
            QuickAmountButton(value: "20") {quickBtnAction("20")}
            QuickAmountButton(value: "50") {quickBtnAction("50")}
        }

    }

}


struct QuickAmountButton: View {
    var value: String
    var action: () -> Void
    
    var body: some View {
        Button(action: {
            action()
        }) {
            Text("+\(value)").padding(10).tint(.white)
        }
        .background(Constants.colors.lightPurpleColor)
        .cornerRadius(10)
    }
}


