//
//  ColorChoice.swift
//  xSpend
//
//  Created by Mike Paraskevopoulos on 11/1/25.
//


import WidgetKit
import AppIntents
import SwiftUI

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
