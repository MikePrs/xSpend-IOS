//
//  AnalyticsScreen.swift
//  xSpendWatch Watch App
//
//  Created by Mike Paraskevopoulos on 10/1/25.
//

import SwiftUI

struct AnalyticsScreen: View {

    @ObservedObject var sessionManager = WCSessionManagerWatch.shared
    
    func getDefaults(){
        if let sharedDefaults = UserDefaults(suiteName: Constants.groupName) {
            let usrDefaults = sharedDefaults
            
            if let userTarget = usrDefaults.string(forKey: "userTarget") {
                sessionManager.userTarget = userTarget
            }
            if let userCurrency = usrDefaults.string(forKey: "userCurrency") {
                sessionManager.userCurrency = userCurrency
            }
            if let userCurrentExpense = usrDefaults.string(forKey: "userCurentExpense") {
                sessionManager.userCurrentExpense = userCurrentExpense
            }
        }else{
            print("userDefaults not found")
        }
    }
    
    var body: some View {
        VStack(spacing:0) {
            ProgressBarGoalWidgetEntryView(
                color: ColorChoice.purple,
                data: ProgressBarData(
                    monthGoal: sessionManager.userTarget,
                    userCurentExpense: sessionManager.userCurrentExpense,
                    currency: sessionManager.userCurrency
                )
            )
        }.onAppear {
            getDefaults()
        }
    }
}
