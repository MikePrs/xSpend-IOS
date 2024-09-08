//
//  AppIntent.swift
//  GoalWidget
//
//  Created by Mike Paraskevopoulos on 18/7/24.
//

import WidgetKit
import AppIntents
import FirebaseCore
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

enum ColorChoice: String, AppEnum {
    case red
    case blue
    case green
    case yellow
    case orange
    case pink
    case purple
    case gray
    case black
    case whit
    
    var uiColor: Color {
        switch self {
        case .blue:
            return Color.blue
        case .red:
            return Color.red
        case .green:
            return Color.green
        case .yellow:
            return Color.yellow
        case .orange:
            return Color.orange
        case .pink:
            return Color.pink
        case .purple:
            return Color.purple
        case .gray:
            return Color.gray
        case .black:
            return Color.black
        case .whit:
            return Color.white
        }
        
    }

    static var typeDisplayRepresentation = TypeDisplayRepresentation(name: "Color Choice")

    static var caseDisplayRepresentations: [ColorChoice: DisplayRepresentation] = [
        .red: DisplayRepresentation(stringLiteral: "Red"),
        .green: DisplayRepresentation(stringLiteral: "Green"),
        .blue: DisplayRepresentation(stringLiteral: "Blue"),
        .yellow : DisplayRepresentation(stringLiteral: "Yellow"),
        .orange : DisplayRepresentation(stringLiteral: "Orange"),
        .pink : DisplayRepresentation(stringLiteral: "Pink"),
        .purple : DisplayRepresentation(stringLiteral: "Purple"),
        .gray : DisplayRepresentation(stringLiteral: "Gray"),
        .black : DisplayRepresentation(stringLiteral: "Black"),
        .whit : DisplayRepresentation(stringLiteral: "White"),
    ]
}
