//
//  HeaderTitle.swift
//  xSpend
//
//  Created by Mike Paraskevopoulos on 8/6/24.
//

import SwiftUI

struct HeaderTitle: View {
    @State var title:String
    var body: some View {
        Text(title)
            .font(.title)
            .fontWeight(.bold)
            .padding(.leading,25)
    }
}
