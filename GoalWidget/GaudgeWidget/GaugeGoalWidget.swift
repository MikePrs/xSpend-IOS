//
//  GaudgeGoalWidget.swift
//  xSpend
//
//  Created by Mike Paraskevopoulos on 2/9/24.
//

import WidgetKit
import SwiftUI

struct GaugeGoalWidget: Widget {
    let kind: String = "GoalWidgetGaudge"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            GaugeGoalWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }.supportedFamilies([.systemSmall])
    }
}

struct GaugeGoalWidgetEntryView : View {
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
            CircularProgressBar(entry: entry, progress: percentageValue)
        }.onAppear{onAppear()}
    }
}

struct CircularProgressBar: View {
    var entry: Provider.Entry
    var progress: Double // Progress value between 0 and 1
    
    var body: some View {
        ZStack {
            // Background Circle
            Circle()
                .trim(from: 0.15, to: 0.85)
                .stroke(style: StrokeStyle(lineWidth: 8.0, lineCap: .round, lineJoin: .round))
                .opacity(0.3)
                .foregroundColor(Color.gray)
                .rotationEffect(Angle(degrees: 90.0))

            // Progress Circle
            Circle()
                .trim(from: 0.15, to: CGFloat(min(self.progress, 0.85)))
                .stroke(
                    AngularGradient(
                        gradient: Gradient(colors: [Color.clear, Color.purple]),
                        center: .center,
                        startAngle: .degrees(45),
                        endAngle: .degrees(315 * (progress * 0.7))
                    ),
                    style: StrokeStyle(lineWidth: 8.0, lineCap: .round, lineJoin: .round)
                )
                .foregroundColor(Color.purple)
                .rotationEffect(Angle(degrees: 90.0))
                .animation(.linear, value: progress) // Animate progress changes
            
            Text("\(entry.configuration.userCurentExpense)".split(separator: ".")[0])
                .font(.title)
                .bold()
                .foregroundColor(Color.purple)
            
            Text("\(entry.configuration.currency)")
                .font(.subheadline)
                .foregroundColor(Color.purple)
                .padding(.top, -40)
            
            // Progress Text
            Text(String(format: "%.0f%%", min(self.progress, 1.0) * 100.0))
                .font(.title2)
                .foregroundColor(Color.purple)
                .padding(.top, 70)

        }
        .padding(10)
    }
}
