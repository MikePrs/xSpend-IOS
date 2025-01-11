//
//  ProgressBarGoalWidgetEntryView.swift
//  xSpend
//
//  Created by Mike Paraskevopoulos on 11/1/25.
//


import WidgetKit
import SwiftUI

struct ProgressBarGoalWidgetEntryView : View {
    @State var percentage = ""
    @State var percentageValue = 0.0
    
    @State var monthGoal: String
    @State var userCurentExpense: String
    @State var currency: String
    @State var color: ColorChoice
    
    func onAppear(){
        guard let month = Double(monthGoal) else { return }
        guard let current = Double(userCurentExpense) else { return }
        guard month != 0 else {return}
        
        self.percentage = String(format: "%.1f",(current * 100) / month)
        self.percentageValue = Double(Float(current) / Float(month))
    }

    var body: some View {
        VStack {
            HStack{
                Text("\(userCurentExpense) \(currency) / \(monthGoal) \(currency) ").frame(alignment: .leading)
                Spacer()
            }.padding()
            GeometryReader { geometry in
                ZStack{
                    LinearGradient(gradient: Gradient(colors: [.gray.opacity(0.2)]),
                                   startPoint: .leading,
                                   endPoint: .trailing)
                    .frame(width: 1 * geometry.size.width, height: geometry.size.height)
                    .cornerRadius(8.0)
                    
                    HStack{
                        LinearGradient(gradient: Gradient(colors: [Color.clear, color.uiColor]),
                                       startPoint: .leading,
                                       endPoint: .trailing)
                        .frame(width: CGFloat(self.percentageValue) * geometry.size.width, height: geometry.size.height)
                        .cornerRadius(8.0)
                        Spacer()
                    }
                }
            }.frame(height: 10)
            HStack{
                Spacer()
                Text("\(percentage)%").frame( alignment: .leading)
            }.padding()
            
        }.onAppear{onAppear()}
            
    }
}
