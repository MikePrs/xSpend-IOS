//
//  AnalyticsScreen.swift
//  xSpendWatch Watch App
//
//  Created by Mike Paraskevopoulos on 10/1/25.
//

import SwiftUI

struct AnalyticsScreen: View {
    var body: some View {
        GeometryReader { geometry in
                    VStack(spacing: 0) {
                        // Top Content
                        Color.blue
                            .frame(height: geometry.size.height * 0.3) // 30% of screen height
                            .overlay(Text("Top Area").foregroundColor(.white))

                        // Middle Content
                        Color.green
                            .frame(height: geometry.size.height * 0.4) // 40% of screen height
                            .overlay(Text("Middle Area").foregroundColor(.white))

                        // Bottom Content
                        Color.red
                            .frame(height: geometry.size.height * 0.3) // 30% of screen height
                            .overlay(Text("Bottom Area").foregroundColor(.white))
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height) // Ensures it uses full screen size
                    .edgesIgnoringSafeArea(.all) // Explicitly ignores safe areas
                }
    }
}
