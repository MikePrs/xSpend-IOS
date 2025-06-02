//
//  xSpendWatchApp.swift
//  xSpendWatch Watch App
//
//  Created by Mike Paraskevopoulos on 10/1/25.
//

import SwiftUI

class AppDelegate: NSObject, WKExtensionDelegate {
    
    func applicationDidFinishLaunching() {
       let _ = WCSessionManagerWatch.shared
    }
}

@main
struct xSpendWatch_Watch_AppApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
