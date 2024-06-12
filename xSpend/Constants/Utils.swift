//
//  Utils.swift
//  xSpend
//
//  Created by Mike Paraskevopoulos on 12/6/24.
//

import SwiftUI

struct Utils {

    static func getPurpleColor(_ colorScheme:ColorScheme) -> Color{
       return colorScheme == .light ? Constants.colors.purpleColor : Constants.colors.lightPurpleColor
    }
    
    static func convertStringToDate(_ dateString: String) -> Date? {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "dd/MM/yyyy"
        inputFormatter.timeZone = TimeZone(secondsFromGMT: 0) // Set time zone if needed
        
        return inputFormatter.date(from: dateString)
    }
}
