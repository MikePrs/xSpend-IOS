//
//  AnalyticsScreen.swift
//  xSpendWatch Watch App
//
//  Created by Mike Paraskevopoulos on 10/1/25.
//

import SwiftUI

struct AnalyticsScreen: View {
    @ObservedObject var sessionManager = WCSessionManagerWatch.shared
    var body: some View {
        VStack(spacing:0) {
            ProgressBarGoalWidgetEntryView(
                color: ColorChoice.purple,
                data: sessionManager.getData()
            )
        }
    }
}
