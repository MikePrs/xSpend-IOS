//
//  MainScreen.swift
//  xSpendWatch Watch App
//
//  Created by Mike Paraskevopoulos on 10/1/25.
//

import SwiftUI

struct MainScreen: View {
    @State var amount: Int = 0
    var currency:String = "EUR"
    @State var selectedType:String = ""
    
    var body: some View {
        VStack(spacing:0) {
            
            HStack{
                Image(Constants.icon.expenses).resizable().frame(width: 30,height: 30).padding(.bottom,10)
                Spacer()
                Text(Constants.strings.amount + ": " + String(amount) ).tint(.white)
                
                Text(currency).tint(.white).font(.footnote)
            }.padding(.top,-20)
            
            QuickAmounts { selectedAmount in
                amount = amount + (Int(selectedAmount) ?? 0)
            }
            
            Picker("", selection: $selectedType) {
                ForEach(Constants.staticList.standardStringType, id: \.self) { type in
                    Text(type)
                }
            }.focusBorderHidden().pickerStyle(.wheel)
            
            Image(systemName: Constants.icon.plusFill)
                .foregroundColor(Constants.colors.purpleColor)
                .font(.system(size: 30))
                .onTapGesture {
                    print("add")
                }
                .padding(.top,10)
            
        }
    }
}


extension Picker {
    func focusBorderHidden() -> some View {
        let isWatchOS7: Bool = {
            if #available(watchOS 7, *) {
                return true
            }

            return false
        }()

        let padding: EdgeInsets = {
            if isWatchOS7 {
                return .init(top: 17, leading: 0, bottom: 0, trailing: 0)
            }

            return .init(top: 8.5, leading: 0.5, bottom: 8.5, trailing: 0.5)
        }()

        return self
            .overlay(
                RoundedRectangle(cornerRadius: isWatchOS7 ? 9 : 7)
                    .stroke(Color.black, lineWidth: 8)
                    .offset(y: isWatchOS7 ? 0 : 8)
                    .padding(padding)
            )
    }
}
