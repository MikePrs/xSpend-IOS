//
//  GaudgeGoalWidget.swift
//  xSpend
//
//  Created by Mike Paraskevopoulos on 2/9/24.
//

import WidgetKit
import SwiftUI

struct GaudgeGoalWidget: Widget {
    let kind: String = "GoalWidgetGaudge"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            GaudgeGoalWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }.supportedFamilies([.systemSmall])
    }
}

struct GaudgeGoalWidgetEntryView : View {
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
            Text("Hello")
            HStack{
                Spacer()
                Text("\(percentage)%").frame( alignment: .leading)
            }.padding()
            
        }.onAppear{onAppear()}
            
    }
}
