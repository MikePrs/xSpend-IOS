//
//  ProgressBarGoalWidgetEntryView.swift
//  xSpend
//
//  Created by Mike Paraskevopoulos on 11/1/25.
//


import WidgetKit
import SwiftUI

struct ProgressBarData:Equatable {
    var monthGoal: String
    var userCurentExpense: String
    var currency: String

}

struct ProgressBarGoalWidgetEntryView : View {
    @State var percentage: String? = nil
    @State var percentageValue: Double? = nil
    
    @State var color: ColorChoice
    var data : ProgressBarData
    
    func onAppear(){
        guard let month = Double(data.monthGoal) else { return }
        guard let current = Double(data.userCurentExpense) else { return }
        guard month != 0 else {return}
        
        self.percentage = String(format: "%.1f",(current * 100) / month)
        self.percentageValue = Double(Float(current) / Float(month))
    }

    var body: some View {
        VStack {
            HStack{
                Text("\(data.userCurentExpense) \(data.currency) / \(data.monthGoal) \(data.currency) ").frame(alignment: .leading)
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
