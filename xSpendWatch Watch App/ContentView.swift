//
//  ContentView.swift
//  xSpendWatch Watch App
//
//  Created by Mike Paraskevopoulos on 10/1/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        HorizontalScrollScreens()
    }
}

#Preview {
    ContentView()
}

struct HorizontalScrollScreens: View {
    var body: some View {
        TabView {
            MainScreen().tag(0)
            
            AnalyticsScreen().tag(1)
        }
        .tabViewStyle(PageTabViewStyle())
    }
}
