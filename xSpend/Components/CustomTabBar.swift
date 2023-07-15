//
//  CustomTabBar.swift
//  xSpend
//
//  Created by Mike Paraskevopoulos on 13/7/23.
//

import SwiftUI

enum Tab: String, CaseIterable {
    case house
    case add
    case person
}

struct CustomTabBar: View {
    @Binding var selectedTab: Tab
    let purpleColor = Color(red: 0.37, green: 0.15, blue: 0.80)
    
    private var fillImage: String {
        switch selectedTab{
        case .house:
            return "house.fill"
        case .add:
            return "plus.circle.fill"
        case .person:
            return "person.fill"
        }
    }
    
    private func getIcon(_ tab:Tab)->String{
        print(Tab.allCases)
        print(selectedTab)
        switch tab{
        case .house:
            return "house"
        case .add:
            return "plus.circle"
        case .person:
            return "person"
        }
    }
    
    func initSetup() {
        
    }
    
    var body: some View {
        VStack {
            
            ZStack {
                HStack {
                    ForEach(Tab.allCases, id: \.rawValue) { tab in
                        Spacer()
                        if (tab != .add){
                            Image(systemName: selectedTab == tab ? fillImage : getIcon(tab))
                                .scaleEffect(tab == selectedTab ? 2 : 1.0)
                                .foregroundColor(.gray)
                                .font(.system(size: 20))
                                .onTapGesture {
                                    withAnimation(.easeInOut(duration: 0.1)) {
                                        selectedTab = tab
                                    }
                                }
                        }
                        Spacer()
                    }
                }
                .frame(width: nil, height: 60)
                .background(.thinMaterial)
                .cornerRadius(20)
                .padding()
                HStack{
                    Spacer()
                    Image(systemName: "plus.circle.fill")
                        .scaleEffect(3)
                        .foregroundColor(purpleColor)
                        .font(.system(size: 20))
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 0.1)) {
                                selectedTab = .add
                            }
                        }
                    Spacer()
                }
            }
        }.onAppear(perform: initSetup)
    }
}

//struct CustomTabBar_Previews: PreviewProvider {
//    static var previews: some View {
//        CustomTabBar(selectedTab: .constant(.house))
//    }
//}

import SwiftUI

struct TabManager: View {
    @State private var tabSelected: Tab = .add
    init() {
        UITabBar.appearance().isHidden = true
    }
    var body: some View {
        
        ZStack {
            NavigationStack {
                ZStack{
                    VStack {
                        TabView(selection: $tabSelected) {
                            ForEach(Tab.allCases, id: \.rawValue) { tab in
                                HStack {
                                    if(tab.rawValue == "add"){
                                        AddNewExpense()
                                    }else if (tab.rawValue == "house"){
                                        
                                    }else if(tab.rawValue == "person"){
                                        Profile()
                                    }
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
            .navigationBarBackButtonHidden(true)
        }
    }
    
}

struct AddExpense_Previews: PreviewProvider {
    static var previews: some View {
        TabManager()
    }
}

