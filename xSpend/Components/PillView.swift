//
//  PillView.swift
//  xSpend
//
//  Created by Mike Paraskevopoulos on 13/7/25.
//

import SwiftUI

struct PillView : View {
    @Environment(\.colorScheme) var colorScheme

    let title : String
    
    var body: some View {
        VStack {
            Text(title)
                .font(.subheadline)
                .foregroundStyle(colorScheme == .light ? Constants.colors.purpleColor : Constants.colors.lightPurpleColor)
                .padding(10)
        }
        .background(Color.white.opacity(colorScheme == .light ? 1 : 0.1))
        .cornerRadius(20)
    }
    
}
