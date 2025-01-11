//
//  QuickAmounts.swift
//  xSpend
//
//  Created by Paraskevopoulos, Michail on 19/6/24.
//

import SwiftUI

struct QuickAmounts: View {
    
    var quickBtnAction: (String) -> Void
    
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
    @Environment(\.colorScheme) var colorScheme
    var value: String
    var action: () -> Void
    
    var body: some View {
        Button(action: {
            action()
        }) {
#if os(watchOS)
            Text("+\(value)")
                .font(.system(size: 9)).tint(.white)
#else
            Text("+\(value)").padding(10).tint(.white)
#endif
        }
        .background(Utils.getPurpleColor(colorScheme))
#if os(watchOS)
        .frame(width:30,height:30)
#endif
        .cornerRadius(10)
    }
}


