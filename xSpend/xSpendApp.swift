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
    
  var body: some Scene {
    WindowGroup {
      NavigationView {
          ViewCoordinator()
      }
    }
  }
}


struct ViewCoordinator: View {
    @State private var isActive = false
    @AppStorage(Constants.appStorage.isDarkMode) private var isDarkMode = false
    var body: some View {
        if isActive {
            LandingPage().preferredColorScheme(isDarkMode ? .dark : .light)
        }else {
            SplashScreen(isActive: $isActive)
        }
    }
}
