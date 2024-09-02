//
//  ProgressBarGoalWidget.swift
//  xSpend
//
//  Created by Mike Paraskevopoulos on 2/9/24.
//

import WidgetKit
import SwiftUI

struct ProgressBarGoalWidgetEntryView : View {
    var entry: Provider.Entry
    @State var percentage = ""
    @State var percentageValue = 0.0
    
    func onAppear(){
        guard let month = Double(entry.configuration.monthGoal) else { return }
        guard let current = Double(entry.configuration.userCurentExpense) else { return }
        guard month != 0 else {return}
        
        self.percentage = String(format: "%.1f",(current * 100) / month)
        self.percentageValue = Double(Float(current) / Float(month))
    }

    var body: some View {
        VStack {
            HStack{
                Text("\(entry.configuration.userCurentExpense) \(entry.configuration.currency) / \(entry.configuration.monthGoal) \(entry.configuration.currency) ").frame(alignment: .leading)
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
                        LinearGradient(gradient: Gradient(colors: [Color.clear, Color.purple]),
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

struct ProgressBarGoalWidget: Widget {
    let kind: String = "GoalWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            ProgressBarGoalWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }.supportedFamilies([.systemMedium, .systemSmall])
    }
}
