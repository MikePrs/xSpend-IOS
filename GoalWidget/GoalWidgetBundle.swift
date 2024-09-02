//
//  GoalWidgetBundle.swift
//  GoalWidget
//
//  Created by Mike Paraskevopoulos on 18/7/24.
//

import WidgetKit
import SwiftUI


@main
struct GoalWidgetBundle: WidgetBundle {
    var body: some Widget {
        ProgressBarGoalWidget()
        GaudgeGoalWidget()
    }
}
