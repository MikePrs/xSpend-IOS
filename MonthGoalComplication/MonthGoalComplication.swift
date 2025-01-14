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

#Preview(as: .accessoryCorner) {
    MonthGoalComplication()
} timeline: {
    SimpleEntry(date: .now, configuration: .monthProgressBar, colorChoice: .cyan)
}

struct MonthGoalComplicationEntryView : View {
    var entry: Provider.Entry
    
    var body: some View {
        VStack{
            CurvedBarView(progress: 0.7)
        }
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
