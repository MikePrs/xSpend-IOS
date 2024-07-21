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
    var currentSpend: String
    
    static var monthProgressBar: ConfigurationAppIntent {
        
        let intent = ConfigurationAppIntent()
//        FirebaseApp.configure()
//        let fbViewModel = FirebaseViewModel()
//        fbViewModel.getUserTarget { value in
//            if let target = value{
//                intent.monthGoal = target
//            }
//        }
        intent.monthGoal = WidgetHelper().userTarget ?? "20"
        intent.currentSpend = WidgetHelper().userTarget ?? "20"
        return intent
    }
}

class WidgetHelper {
    let sharedDefaults = UserDefaults(suiteName: Constants.groupName)
    @Published var userTarget:String?
    
    init() {
        self.userTarget =  sharedDefaults?.string(forKey: "userTarget") ?? "0"
    }
//    func getUserTargetFromDefaults()  {
//        userTarget =
//
//    }
}
