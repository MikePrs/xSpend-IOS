//
//  ExpensesListAnalyticsPanelView.swift
//  xSpend
//
//  Created by Mike Paraskevopoulos on 14/7/25.
//

import SwiftUI

struct ExpensesListAnalyticsPanelView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) var dismiss
    var data : [SectionedExpenses]
    @State var typesSet : Set<String> = []

    func setup(){
        print(data)
        setResultsTypes()
    }
    
    func setResultsTypes(){
        for expense in data.flatMap({ $0.expenses }) {
            typesSet.insert(expense.type)
        }
    }
    
    var body: some View {
        ScrollView {
            HStack {
                Image(systemName: Constants.icon.left)
                    .foregroundStyle(Utils.getPurpleColor(colorScheme))
                Button(Constants.strings.back) {
                    dismiss()
                }.tint(Utils.getPurpleColor(colorScheme))
                Spacer()
            }.padding().background(colorScheme == .light ? Color(uiColor: .secondarySystemBackground):nil)
            
            Spacer()
            
            let columns = [
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.flexible())
            ]

            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(Array(typesSet), id: \.self) { type in
                    HStack(spacing: 8) {
                        Text(type).font(.title3)
                        Image(systemName: "circle.inset.filled").frame(width: 10, height: 10)
                    }.padding(8)
                }
            }
            .background(Color.gray.opacity(0.2))
            .cornerRadius(20)
            .padding(10)
            
            
            Spacer()
        }.onAppear{setup()}
    }
}
