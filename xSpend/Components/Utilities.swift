//
//  Utilities.swift
//  xSpend
//
//  Created by Mike Paraskevopoulos on 21/7/24.
//

import Foundation
import WidgetKit

class Utilities {
    func setUserDefaults(for key:String, with value:String, reloadWidgets:Bool = true){
        if let sharedDefaults = UserDefaults(suiteName: Constants.groupName) {
            sharedDefaults.set(value, forKey: key)
            if reloadWidgets {
                WidgetCenter.shared.reloadAllTimelines()
            }
        }
    }
}
