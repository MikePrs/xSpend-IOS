//
//  Utilities.swift
//  xSpend
//
//  Created by Mike Paraskevopoulos on 21/7/24.
//

import Foundation
import WidgetKit
import WatchConnectivity
import ClockKit

class Utilities {
    func setUserDefaults(for key:String, with value:String, reloadWidgets:Bool = true){
        if let sharedDefaults = UserDefaults(suiteName: Constants.groupName) {
            sharedDefaults.set(value, forKey: key)
            sharedDefaults.synchronize()
//            WCSessionManager.shared.sendMessage(getComplicationsUserDefaultsValues())
            sendComplicationUpdate()
            updateTimelines()
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
    
    
    func sendComplicationUpdate() {
        WCSession.default.transferCurrentComplicationUserInfo(getComplicationsUserDefaultsValues())
        WCSession.default.transferUserInfo(getComplicationsUserDefaultsValues())
    }
    
    func updateTimelines(){
        WidgetCenter.shared.reloadTimelines(ofKind: "MonthGoalComplication")
        WidgetCenter.shared.reloadAllTimelines()
    }

}
