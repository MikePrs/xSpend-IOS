//
//  ProgressBarGoalWidgetEntryView.swift
//  xSpend
//
//  Created by Mike Paraskevopoulos on 11/1/25.
//


import WidgetKit
import SwiftUI



struct ProgressBarGoalWidgetEntryView : View {
    @State var percentage: String? = nil
    @State var percentageValue: Double? = nil
    @State var monthGoal: String = ""
    @State var userCurentExpense: String = ""
    @State var currency: String = ""
    
    @State var color: ColorChoice
    var data : ProgressBarData
    
    func onAppear() {
        guard
            let monthString = data.monthGoal,
            let month = Double(monthString),
            let currentString = data.userCurentExpense,
            let current = Double(currentString),
            month != 0,
            let currency = data.currency
        else {
            return
        }

        self.percentage = String(format: "%.1f", (current * 100) / month)
        self.percentageValue = current / month
        self.monthGoal = String(format: "%.2f", month)
        self.userCurentExpense = String(format: "%.2f", current)
        self.currency = currency
    }

    var body: some View {
        VStack {
            HStack{
                Text("\(userCurentExpense) \(currency) / \(monthGoal) \(currency)")
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
                        .frame(width: CGFloat(self.percentageValue ?? 0.0) * geometry.size.width, height: geometry.size.height)
                        .cornerRadius(8.0)
                        Spacer()
                    }
                }
            }.frame(height: 10)
            HStack{
                Spacer()
                Text("\(percentage ?? "0")%").frame( alignment: .leading)
            }.padding()
            
        }
        .onAppear{onAppear()}
        .onChange(of: data) { _,_ in
            onAppear()
        }
    }
}
