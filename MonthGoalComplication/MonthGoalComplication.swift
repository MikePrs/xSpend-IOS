//
//  MonthGoalComplication.swift
//  MonthGoalComplication
//
//  Created by Mike Paraskevopoulos on 11/1/25.
//

import WidgetKit
import SwiftUI

@main
struct MonthGoalComplication: Widget {
    let kind: String = "MonthGoalComplication"
    
    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            MonthGoalComplicationEntryView(entry: entry)
                .containerBackground(.fill, for: .widget)
        }
    }
}

struct MonthGoalComplicationEntryView : View {
    var entry: Provider.Entry
    @State var progress : Double = 0.5 // default value 
    
    func onAppear(){
        guard let month = Double(entry.configuration.monthGoal) else { return }
        guard let current = Double(entry.configuration.userCurentExpense) else { return }
        guard month != 0 else {return}
        
        self.progress = (current / month)
    }
    
    var body: some View {
        VStack{
            CurvedBarView(progress: progress)
        }.onAppear{onAppear()}
    }
}


struct CurvedBarView: View {
    var progress: Double // Progress value (0.0 to 1.0)
    
    var body: some View {
        ZStack{
            Text(String(format: "%.0f",progress * 100)+"%")
                .widgetCurvesContent()
        }.widgetLabel{
            Gauge(value: progress) {}
            currentValueLabel: {}
            minimumValueLabel: {}
            maximumValueLabel: {}
        }
        
    }
}
