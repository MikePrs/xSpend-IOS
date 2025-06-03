//
//  AnalyticsScreen.swift
//  xSpendWatch Watch App
//
//  Created by Mike Paraskevopoulos on 10/1/25.
//

import SwiftUI

struct AnalyticsScreen: View {
    @StateObject private var sessionManager = WCSessionManagerWatch.shared

    var body: some View {
        VStack(spacing:0) {
            if let data = sessionManager.data {
                ProgressBarGoalWidgetEntryView(
                    color: ColorChoice.purple,
                    data: data
                )
            }
        }
    }
}
