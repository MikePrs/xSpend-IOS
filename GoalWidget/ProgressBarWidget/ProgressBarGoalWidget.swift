//
//  ProgressBarGoalWidget.swift
//  xSpend
//
//  Created by Mike Paraskevopoulos on 2/9/24.
//

import WidgetKit
import SwiftUI

struct ProgressBarGoalWidget: Widget {
    let kind: String = "GoalWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            ProgressBarGoalWidgetEntryView(
                color: entry.configuration.widgetAccentcolor,
                data: ProgressBarData(
                monthGoal: entry.configuration.monthGoal,
                userCurentExpense: entry.configuration.userCurentExpense,
                currency: entry.configuration.currency),
            ).containerBackground(.fill.tertiary, for: .widget)
        }.supportedFamilies([.systemMedium, .systemSmall])
    }
}
