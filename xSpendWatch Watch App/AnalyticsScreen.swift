//
//  AnalyticsScreen.swift
//  xSpendWatch Watch App
//
//  Created by Mike Paraskevopoulos on 10/1/25.
//

import SwiftUI

struct AnalyticsScreen: View {

    @ObservedObject var sessionManager = WCSessionManagerWatch.shared
    @State var data = ProgressBarData()
    
    func getDefaults(){
        if let sharedDefaults = UserDefaults(suiteName: Constants.groupName) {
            let usrDefaults = sharedDefaults
            
            if let userTarget = usrDefaults.string(forKey: "userTarget") {
                sessionManager.userTarget = userTarget
                data.monthGoal = userTarget
            }
            if let userCurrency = usrDefaults.string(forKey: "userCurrency") {
                sessionManager.userCurrency = userCurrency
                data.currency = userCurrency
            }
            if let userCurrentExpense = usrDefaults.string(forKey: "userCurentExpense") {
                sessionManager.userCurrentExpense = userCurrentExpense
                data.userCurentExpense = userCurrentExpense
            }
        }else{
            print("userDefaults not found")
        }
        
        print("---- User defaults analytics----")
        print(data)
    }
    
    var body: some View {
        VStack(spacing:0) {
            ProgressBarGoalWidgetEntryView(
                color: ColorChoice.purple,
                data: data
            )
        }.onAppear {
            getDefaults()
        }
    }
}
