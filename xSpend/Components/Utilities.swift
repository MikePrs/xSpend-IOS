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

    
    func parseDate(from dateString: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "d/M/yyyy" // Handles "10/7/2025" format
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter.date(from: dateString)
    }
    
    var dayFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "E" // short day name
        return formatter
    }
    
    func currentWeekDates() -> [Date] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())

        let weekday = calendar.component(.weekday, from: today)
        let daysToMonday = (weekday == 1) ? -6 : -(weekday - 2) // Sunday = 1

        guard let monday = calendar.date(byAdding: .day, value: daysToMonday, to: today) else {
            return []
        }

        return (0..<7).compactMap {
            calendar.date(byAdding: .day, value: $0, to: monday)
        }
    }
    
    func endOfDay(for date: Date) -> Date {
        Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: date)!
    }

}
