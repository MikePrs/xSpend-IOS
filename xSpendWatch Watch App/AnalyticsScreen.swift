//
//  AnalyticsScreen.swift
//  xSpendWatch Watch App
//
//  Created by Mike Paraskevopoulos on 10/1/25.
//

import SwiftUI

struct AnalyticsScreen: View {
    var monthGoal = "1000"
    var userCurentExpense = "500"
    var percentage = "50%"
    var percentageValue = 0.5
    var currency = "EUR"
    
    var body: some View {
        VStack(spacing:0) {
            ProgressBarGoalWidgetEntryView(
                percentage: percentage,
                percentageValue: percentageValue,
                monthGoal: monthGoal,
                userCurentExpense: userCurentExpense,
                currency: currency,
                color: ColorChoice.purple
            )
        }
    }
}
