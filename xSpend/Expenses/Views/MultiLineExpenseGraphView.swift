//
//  MultiLineExpenseGraphView.swift
//  xSpend
//
//  Created by Mike Paraskevopoulos on 22/7/25.
//

import SwiftUI
import Charts

let columns = [
    GridItem(.flexible()),
    GridItem(.flexible())
]

struct MultiLineExpenseGraphView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) var dismiss
    var data : [SectionedExpenses]
    
    @State var typesSet : Set<String> = []
    @State var typeColorDic : [String:Color] = [:]
    @State var typesFilter = [TypesFilterPanel]()
    @State var chartData = [String : [LineChartModel]]()

    func setup(){
        setResultsTypes()
    }
    
    func setResultsTypes(){
        for expense in data.flatMap({ $0.expenses }) {
            if typeColorDic[expense.type] == nil {
                let color = Color.random
                typeColorDic[expense.type] = color
                typesFilter.append(TypesFilterPanel(type: expense.type, color: color, isActive: true, typeSum: expense.amount, currency: expense.currency))
                if let date = expense.date.dayMonthDateFormat {
                    chartData[expense.type] = [LineChartModel(day: date, amount: expense.amount,isActive: true)]
                }
            }else{
                if let date = expense.date.dayMonthDateFormat {
                    chartData[expense.type]?.append(LineChartModel(day: date, amount: expense.amount, isActive: true))
                    if let index = typesFilter.firstIndex(where: {$0.type == expense.type}) {
                        typesFilter[index].typeSum += expense.amount
                    }
                }
            }
        }
        
        for item in chartData {
            chartData[item.key] = chartData[item.key]?.sorted{$0.day < $1.day}
        }
    }
    
    func getTypesSum(){
        
    }
    
    func handleActivateType(type:String){
        if let index = typesFilter.firstIndex(where: {$0.type == type}) {
            typesFilter[index].isActive.toggle()
        }
        
        if var values = chartData[type] {
            for i in values.indices {
                values[i].isActive?.toggle()
            }
            chartData[type] = values
        }
    }
    
    var body: some View {
        VStack{
            Chart {
                ForEach(Array(chartData), id: \.key) { (key, values) in
                    ForEach(values , id: \.self){ item in
                        if let isActive = item.isActive, isActive {
                            LineMark(
                                x: .value("Day", item.day),
                                y: .value("Amount", item.amount),
                                series: .value("Category", key)
                            )
                            .foregroundStyle(typeColorDic[key] ?? .white)
                            .symbol(Circle())
                        }
                    }
                }
            }
            .frame(height: 400)
            .padding(.vertical, 20)
            
            typesPanel
            
        }.onAppear{setup()}
        .padding(.horizontal,20)
    }

    
    var typesPanel: some View {
        VStack{
            Text(Constants.strings.typesInFilters)
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.headline).padding(.vertical, 5)
                .padding(.leading,8)
            
            LazyVGrid(columns: columns, spacing: 3) {
                ForEach(typesFilter, id: \.type) { item in
                    HStack(spacing: 8) {
                        Image(systemName: Constants.icon.categoryColorIcon)
                            .frame(width: 5, height: 5)
                            .foregroundStyle(item.isActive ? item.color : .gray)
                            .padding(.trailing,5)
                        
                        Text(item.type)
                            .font(.footnote)
                            .padding(.trailing,2)
                            .foregroundStyle(
                                item.isActive ?
                                    colorScheme == .light ? Color.black : Color.white
                                 : .gray
                            )
                        
                        Text(String(format: "%.1f", item.typeSum) + " " + item.currency )
                            .font(.footnote)
                            .foregroundStyle(item.isActive ?
                                 colorScheme == .light ? Color.black : Color.white
                                 : .gray
                            )
                    }
                    .padding(10)
                    .padding(.horizontal, 5)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .onTapGesture {
                        handleActivateType(type: item.type)
                    }
                }
            }.padding(.vertical, 5)
                .background(colorScheme == .light ? Color.white : Color.gray.opacity(0.2))
                .cornerRadius(20)
            
            
            Text(Constants.strings.typesFilterPanelFootnote)
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.footnote)
                .padding(.leading,8)
                .foregroundStyle(.gray)
            
            Spacer()
        }
    }
}
