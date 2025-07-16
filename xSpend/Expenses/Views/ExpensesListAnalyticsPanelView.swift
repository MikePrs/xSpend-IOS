//
//  ExpensesListAnalyticsPanelView.swift
//  xSpend
//
//  Created by Mike Paraskevopoulos on 14/7/25.
//

import SwiftUI

let columns = [
    GridItem(.flexible()),
    GridItem(.flexible()),
    GridItem(.flexible())
]

struct TypesFilterPanel {
    var type:String
    var color:Color
    var isActive:Bool
}

struct ExpensesListAnalyticsPanelView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) var dismiss
    var data : [SectionedExpenses]
    @State var typesSet : Set<String> = []
    @State var typeColorDic : [String:Color] = [:]
    @State var typesFilter : [TypesFilterPanel] = [TypesFilterPanel]()

    func setup(){
        print(data)
        setResultsTypes()
    }
    
    func setResultsTypes(){
        for expense in data.flatMap({ $0.expenses }) {
            if typeColorDic[expense.type] == nil {
                let color = Color.random
                typeColorDic[expense.type] = color
                typesFilter.append(TypesFilterPanel(type: expense.type, color: color, isActive: true))
            }
        }
    }
    
    func handleActivateType(type:String){
        if let index = typesFilter.firstIndex(where: {$0.type == type}) {
            typesFilter[index].isActive.toggle()
        }
    }
    
    var body: some View {
        VStack{
            
            HStack {
                Image(systemName: Constants.icon.left)
                    .foregroundStyle(Utils.getPurpleColor(colorScheme))
                Button(Constants.strings.back) {
                    dismiss()
                }.tint(Utils.getPurpleColor(colorScheme))
                Spacer()
            }.padding().background(colorScheme == .light ? Color(uiColor: .secondarySystemBackground):nil)
            
            ScrollView {
                
                HeaderTitle(title: Constants.strings.analytics)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading,8)
                
                Text(Constants.strings.typesInFilters)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.subheadline).padding(.vertical, 5)
                    .padding(.leading,8)
                
                LazyVGrid(columns: columns, spacing: 3) {
                    ForEach(typesFilter, id: \.type) { item in
                        HStack(spacing: 8) {
                            Text(item.type)
                                .font(.footnote)
                                .padding(.trailing,5)
                                .foregroundStyle(item.isActive ? .white : .gray)
                            
                            Image(systemName: Constants.icon.categoryColorIcon)
                                .frame(width: 5, height: 5)
                                .foregroundStyle(item.isActive ? item.color : .gray)
                        }
                        .padding(10)
                        .padding(.horizontal, 5)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .onTapGesture {
                            handleActivateType(type: item.type)
                        }
                    }
                }.padding(.vertical, 5)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(20)
                
                
                Text(Constants.strings.typesFilterPanelFootnote)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.footnote)
                    .padding(.leading,8)
                    .foregroundStyle(.gray)
                
                Spacer()
            }.padding(.horizontal,20)
            
        }.onAppear{setup()}
    }
}


extension Color {
    static var random: Color {
        return Color(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1)
        )
    }
}
