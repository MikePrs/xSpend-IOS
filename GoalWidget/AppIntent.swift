//
//  AppIntent.swift
//  GoalWidget
//
//  Created by Mike Paraskevopoulos on 18/7/24.
//

import WidgetKit
import AppIntents
import FirebaseCore

struct ConfigurationAppIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "Configuration"
    static var description = IntentDescription("This is an example widget.")

    // An example configurable parameter.
    @Parameter(title: "Month Goal", default: "0")
    var monthGoal: String
    @Parameter(title: "Current Expenses", default: "0")
    var userCurentExpense: String
    @Parameter(title: "Currency", default: "EUR")
    var currency: String
    
    static var monthProgressBar: ConfigurationAppIntent {
        
        let intent = ConfigurationAppIntent()
        let wh = WidgetHelper()
        intent.monthGoal = wh.userTarget
        intent.userCurentExpense = wh.userCurentExpense
        intent.currency = wh.userCurrency
        return intent
    }
}

class WidgetHelper {
    let sharedDefaults = UserDefaults(suiteName: Constants.groupName)
    @Published var userTarget:String
    @Published var userCurrency:String
    @Published var userCurentExpense:String
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
        }else{
            self.userTarget =  "0"
            self.userCurentExpense = "0"
            self.userCurrency =  ""
        }
    }
}
