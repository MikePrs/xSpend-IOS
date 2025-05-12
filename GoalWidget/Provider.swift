//
//  GoalWidget.swift
//  GoalWidget
//
//  Created by Mike Paraskevopoulos on 18/7/24.
//

import WidgetKit
import SwiftUI

struct Provider: AppIntentTimelineProvider {
    
    func recommendations() -> [AppIntentRecommendation<ConfigurationAppIntent>] {
        return [AppIntentRecommendation(intent: ConfigurationAppIntent(), description: Constants.strings.monthGoal)]
    }
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationAppIntent(), colorChoice: .purple)
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: configuration, colorChoice: configuration.widgetAccentcolor.uiColor)
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        var entries: [SimpleEntry] = []
        let currentDate = Date()

        for minuteOffset in stride(from: 0, to: 60, by: 5) {
            let entryDate = Calendar.current.date(byAdding: .minute, value: minuteOffset, to: currentDate)!
            
            
            if let containerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.xSpend.usersStatsData") {
                print("✅ App group container is available at: \(containerURL)")
            } else {
                print("❌ App group container is NOT available. Entitlements may be missing or it's being called too early.")
            }
            
            // ✅ Re-fetch shared defaults each time
            let helper = WidgetHelper()
            var updatedConfig = configuration
            updatedConfig.monthGoal = helper.userTarget ?? "1000"
            updatedConfig.userCurentExpense = helper.userCurentExpense ?? "500"
            updatedConfig.currency = helper.userCurrency ?? "EUR"

            let entry = SimpleEntry(date: entryDate, configuration: updatedConfig, colorChoice: configuration.widgetAccentcolor.uiColor)
            entries.append(entry)
        }

        let nextUpdate = Calendar.current.date(byAdding: .minute, value: 5, to: currentDate)!
        print("Next complication update scheduled for: \(nextUpdate)")
        return Timeline(entries: entries, policy: .after(nextUpdate))
    }


}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationAppIntent
    let colorChoice: Color
}
