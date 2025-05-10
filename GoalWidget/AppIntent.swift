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
    
    static var monthProgressBar: ConfigurationAppIntent {
        
        var intent = ConfigurationAppIntent()
        let wh = WidgetHelper()
        intent.monthGoal = wh.userTarget ?? "1000"
        intent.userCurentExpense = wh.userCurentExpense ?? "500"
        intent.currency = wh.userCurrency ?? ""
        return intent
    }
}

class WidgetHelper {
    let sharedDefaults = UserDefaults(suiteName: Constants.groupName)
    @Published var userTarget:String?
    @Published var userCurrency:String?
    @Published var userCurentExpense:String?
    @Published var percentage:String?
    @Published var percentageValue:Double?
    
    init() {
        if let usrDefaults = sharedDefaults,
           let userTarget = usrDefaults.string(forKey: "userTarget"),
           let userCurrency =  usrDefaults.string(forKey: "userCurrency"),
           let userCurentExpense =  usrDefaults.string(forKey: "userCurentExpense")
        {
            self.userTarget =  userTarget
            self.userCurentExpense = userCurentExpense
            self.userCurrency =  userCurrency
        }
    }
}


