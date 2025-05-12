//
//  WCSessionManagerWatch.swift
//  xSpendWatch Watch App
//
//  Created by Mike Paraskevopoulos on 9/5/25.
//

import Foundation
import WatchConnectivity
import WidgetKit
import ClockKit
import UserNotifications

class WCSessionManagerWatch: NSObject, ObservableObject, WCSessionDelegate, UNUserNotificationCenterDelegate {
    static let shared = WCSessionManagerWatch()
    
    @Published var userTarget: String = "0"
    @Published var userCurrency: String = ""
    @Published var userCurrentExpense: String = "0"
    
    private override init() {
        super.init()
        activateSession()
    }
    
    private func activateSession() {
        guard WCSession.isSupported() else { return }
        let session = WCSession.default
        session.delegate = self
        UNUserNotificationCenter.current().delegate = self
        if WCSession.default.activationState != .activated {
            session.activate()
        }
    }
    
    // MARK: - WCSessionDelegate
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("watchOS: Activated with state: \(activationState.rawValue)")
    }
    
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        handleIncomingData(applicationContext)
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        handleIncomingData(message)
    }
    
    func session(_ session: WCSession, didReceiveUserInfo message: [String : Any] = [:]) {
        handleIncomingData(message)
    }
    
    func handleIncomingData(_ message: [String: Any]){
        
                    if message["userTarget"] != nil,
                       let userTarget = message["userTarget"] as? String {
                            self.userTarget = userTarget
                        Utilities().setUserDefaults(for: "userTarget" , with: userTarget)
                    }
        
                    if message["userCurrency"] != nil,
                       let userCurrency = message["userCurrency"] as? String {
                        self.userCurrency = userCurrency
                        Utilities().setUserDefaults(for: "userCurrency" , with: userCurrency)
                    }
        
                    if message["userCurentExpense"] != nil,
                       let userCurentExpense = message["userCurentExpense"] as? String {
                        self.userCurrentExpense = userCurentExpense
                        Utilities().setUserDefaults(for: "userCurentExpense" , with: userCurentExpense)
                    }
        
        let server = CLKComplicationServer.sharedInstance()
        server.activeComplications?.forEach {
            server.reloadTimeline(for: $0)
        }
    }
    
}

