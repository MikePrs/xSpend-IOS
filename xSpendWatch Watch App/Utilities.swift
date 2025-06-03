//
//  Utilities.swift
//  xSpendWatch Watch App
//
//  Created by Mike Paraskevopoulos on 10/5/25.
//

import Foundation
import WidgetKit

class Utilities {
    func setUserDefaults(for key:String, with value:String, reloadWidgets:Bool = true){
        if let sharedDefaults = UserDefaults(suiteName: Constants.groupName) {
            sharedDefaults.set(value, forKey: key)
            sharedDefaults.synchronize()
            if reloadWidgets {
                WidgetCenter.shared.reloadAllTimelines()
            }
        }
    }
    
    func getComplicationsUserDefaultsValues()-> [String:String] {
        let sharedDefaults = UserDefaults(suiteName: Constants.groupName)
        if let usrDefaults = sharedDefaults,
           let userTarget = usrDefaults.string(forKey: "userTarget"),
           let userCurrency =  usrDefaults.string(forKey: "userCurrency"),
           let userCurentExpense =  usrDefaults.string(forKey: "userCurentExpense"){
            return ["userTarget" : userTarget, "userCurrency" : userCurrency, "userCurentExpense" : userCurentExpense]
        }
        return [:]
    }
}
