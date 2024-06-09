//
//  AddExpense.swift
//  xSpend
//
//  Created by Mike Paraskevopoulos on 13/7/23.
//

import SwiftUI

struct AddExpense: View {
    @State private var tabSelected: Tab = .house
    init() {
        UITabBar.appearance().isHidden = true
    }
    var body: some View {
        ZStack {
            VStack {
                TabView(selection: $tabSelected) {
                    ForEach(Tab.allCases, id: \.rawValue) { tab in
                        HStack {
                            
                        }
                        .tag(tab)
                        
                    }
                }
            }
            VStack {
                Spacer()
                CustomTabBar(selectedTab: $tabSelected)
            }
        }
    }
    
}

struct AddExpense_Previews: PreviewProvider {
    static var previews: some View {
        AddExpense()
    }
}
