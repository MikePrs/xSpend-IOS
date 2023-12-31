//
//  xSpendApp.swift
//  xSpend
//
//  Created by Mike Paraskevopoulos on 9/7/23.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

@main
struct YourApp: App {
  // register app delegate for Firebase setup
  @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
  @AppStorage("isDarkMode") private var isDarkMode = false


  var body: some Scene {
    WindowGroup {
      NavigationView {
        ContentView().preferredColorScheme(isDarkMode ? .dark : .light)
      }
    }
  }
}
