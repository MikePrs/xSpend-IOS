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
}
