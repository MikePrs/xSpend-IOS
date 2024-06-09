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
    @Environment(\.colorScheme) var colorScheme
    @Binding var selectedTab: Tab
    
    private var fillImage: String {
        switch selectedTab{
        case .house:
            return Constants.icon.houseFill
        case .add:
            return Constants.icon.plusFill
        case .person:
            return Constants.icon.personFill
        }
    }
    
    private func getIcon(_ tab:Tab)->String{
        switch tab{
        case .house:
            return Constants.icon.house
        case .add:
            return Constants.icon.plus
        case .person:
            return Constants.icon.personSimple
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
                .background(colorScheme == .dark ? .thinMaterial : .bar)
                .cornerRadius(20)
                .padding([.leading,.trailing,.bottom],2)
                HStack{
                    Spacer()
                    Image(systemName: Constants.icon.plusFill)
                        .scaleEffect(3)
                        .foregroundColor(Constants.colors.purpleColor)
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
    @ObservedObject var fbViewModel = FirebaseViewModel()

    init() {
        UITabBar.appearance().isHidden = true
    }
    
    var body: some View {
        
        ZStack {
            VStack {
                TabView(selection: $tabSelected) {
                    AddNewExpense()
                    .tabItem {
                    }.tag(Tab.add)
                    
                    ExpensesScreen().environmentObject(fbViewModel)
                    .tabItem {
                    }.tag(Tab.house)
                    
                    Profile().environmentObject(fbViewModel)
                    .tabItem {
                    }.tag(Tab.person)
                }
            }
            VStack {
                Spacer()
                CustomTabBar(selectedTab: $tabSelected)
            }
            .navigationBarHidden(true)
        }.ignoresSafeArea(.keyboard, edges: .bottom)
    }
}



struct AddExpense_Previews: PreviewProvider {
    static var previews: some View {
        TabManager()
    }
}
