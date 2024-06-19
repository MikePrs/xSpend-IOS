//
//  QuickAmounts.swift
//  xSpend
//
//  Created by Paraskevopoulos, Michail on 19/6/24.
//

import SwiftUI

struct QuickAmounts: View {
    
    func quickBtnAction(_ value:String ){
        print(value)
    }
    
    var body: some View {
        
        HStack{
            Spacer(minLength: 1)
            QuickAmountButton(value: "1", buttonAction: quickBtnAction )
            QuickAmountButton(value: "2", buttonAction: quickBtnAction)
            QuickAmountButton(value: "5", buttonAction: quickBtnAction)
            QuickAmountButton(value: "10", buttonAction: quickBtnAction)
            QuickAmountButton(value: "20", buttonAction: quickBtnAction)
            QuickAmountButton(value: "50", buttonAction: quickBtnAction)
            Spacer(minLength: 1)
        }
    }

}


struct QuickAmountButton: View {
    var value: String
    var buttonAction: (_ value:String) -> Void
    
    var body: some View {
        HStack{
            Button(action: {
                buttonAction(value)
            }) {
                Text("+\(value)").padding(10).tint(.white)
            }
            .background(Constants.colors.lightPurpleColor)
            .cornerRadius(10)
        }
    }
}
