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
    @ObservedObject var router = Router()
    @StateObject var fbViewModel = FirebaseViewModel()
    @Environment(\.colorScheme) var colorScheme
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $router.navPath) {
                ViewCoordinator()
                    .navigationDestination(for: Destination.self) { destination in
                        switch destination {
                        case .landingScreen:
                            LandingScreen()
                        case .login:
                            LoginScreen()
                        case .signUp:
                            SignupScreen()
                        case .tabManager:
                            TabManager()
                        case .expenseDetail(let addNewExpenseViewModel, let fbViewModel, let viewType):
                            ExpenseDetail(
                                addNewExpenseViewModel: addNewExpenseViewModel,
                                fbViewModel: fbViewModel,
                                viewType: viewType
                            )
                            .navigationBarBackButtonHidden()
                            .background(colorScheme == .light ? Color(uiColor: .secondarySystemBackground) : .black)
                        case .expenseTypes:
                            ExpenseTypes()
                        }
                    }
            }.environmentObject(router).environmentObject(fbViewModel)
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
