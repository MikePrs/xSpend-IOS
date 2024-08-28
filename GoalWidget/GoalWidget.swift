//
//  GoalWidget.swift
//  GoalWidget
//
//  Created by Mike Paraskevopoulos on 18/7/24.
//

import WidgetKit
import SwiftUI

struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationAppIntent())
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: configuration)
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: .monthProgressBar)
            entries.append(entry)
        }

        return Timeline(entries: entries, policy: .atEnd)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationAppIntent
}

struct GoalWidgetEntryView : View {
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
                    
                    LinearGradient(gradient: Gradient(colors: [Color.clear, Color.purple]),
                                   startPoint: .leading,
                                   endPoint: .trailing)
                    .frame(width: CGFloat(self.percentageValue) * geometry.size.width, height: geometry.size.height)
                    .cornerRadius(8.0)
                }
            }.frame(height: 10)
            HStack{
                Spacer()
                Text("\(percentage)%").frame( alignment: .leading)
            }.padding()
            
        }.onAppear{onAppear()}
            
    }
}

struct GoalWidget: Widget {
    let kind: String = "GoalWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            GoalWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }.supportedFamilies([.systemMedium, .systemSmall])
    }
}

extension ConfigurationAppIntent {

    
//    fileprivate static var starEyes: ConfigurationAppIntent {
//        let intent = ConfigurationAppIntent()
//        intent.favoriteEmoji = "🤩"
//        return intent
//    }
}

#Preview(as: .systemSmall) {
    GoalWidget()
} timeline: {
    SimpleEntry(date: .now, configuration: .monthProgressBar)
//    SimpleEntry(date: .now, configuration: .starEyes)
}
