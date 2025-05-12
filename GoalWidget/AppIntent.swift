//
//  AppIntent.swift
//  GoalWidget
//
//  Created by Mike Paraskevopoulos on 18/7/24.
//

import WidgetKit
import AppIntents
import SwiftUI

struct ConfigurationAppIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "Configuration"
    static var description = IntentDescription("This is an example widget.")

    // non configurable parameters.
    var monthGoal: String = "1000"
    var userCurentExpense: String = "500"
    var currency: String = "EUR"
    
    // configurable parameters.
    @Parameter(title: "Color", default: .purple )
    var widgetAccentcolor: ColorChoice
}

class WidgetHelper {
    let sharedDefaults = UserDefaults(suiteName: Constants.groupName)
    
    var userTarget: String?
    var userCurrency: String?
    var userCurentExpense: String?
    var percentage: String?
    var percentageValue: Double?
    
    init() {
        guard let usrDefaults = sharedDefaults else {
            print("Shared defaults not found")
            return
        }

        self.userTarget = usrDefaults.string(forKey: "userTarget")
        self.userCurrency = usrDefaults.string(forKey: "userCurrency")
        self.userCurentExpense = usrDefaults.string(forKey: "userCurentExpense")

        print("Fetched from sharedDefaults:", self.userTarget ?? "nil", self.userCurentExpense ?? "nil", self.userCurrency ?? "nil")
    }
}


