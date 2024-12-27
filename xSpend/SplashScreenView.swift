//
//  SplashScreenView.swift
//  xSpend
//
//  Created by Mike Paraskevopoulos on 27/12/24.
//

import SwiftUI

struct SplashScreen: View {
    @State private var scale = 1.0
    @Binding var isActive: Bool
    var body: some View {
        VStack {
            VStack {
                Image(Constants.icon.expenses)
                    .resizable()
                    .frame(width: 150,height: 150)
                    .padding(.bottom,26)
            }
            .scaleEffect(scale)
            .onAppear{
                withAnimation(.easeIn(duration: 0.7)) {
                    self.scale = 2.5
                }
            }
        }.onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                withAnimation {
                    self.isActive = true
                }
            }
        }
    }
}
