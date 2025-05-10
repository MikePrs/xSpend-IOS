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
}
