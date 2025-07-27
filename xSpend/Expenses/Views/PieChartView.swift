//
//  PieChartView.swift
//  xSpend
//
//  Created by Mike Paraskevopoulos on 22/7/25.
//

import SwiftUI
import Charts

struct PieChartData: Identifiable {
    var id = UUID()
    var category: String
    var value: Float
}

struct PieChartView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) var dismiss
    var data : [SectionedExpenses]
    @State var chartData = [PieChartData]()
    @State var totalSum: Float = 0
    
    func setupData(){
        for expense in data.flatMap({ $0.expenses }) {
            if let index = chartData.firstIndex(where: {$0.category == expense.type}) {
                chartData[index].value += expense.amount
            } else {
                chartData.append(PieChartData(category: expense.type, value: expense.amount))
            }
            totalSum += expense.amount
        }
        
        for i in chartData.indices{
            chartData[i].value = chartData[i].value / totalSum * 100
        }
        
        
    }
    
    var body: some View {
        VStack{
            Chart(chartData) { item in
                SectorMark(
                    angle: .value("Value", item.value),
                    innerRadius: .ratio(0.5),
                    angularInset: 1
                )
                .foregroundStyle(by: .value("Category", item.category))
                .annotation(position: .overlay, alignment: .center) {
                                let percent = item.value / totalSum
                                if percent > 0.01 {
                                    Text("\(Int(percent * 100))%")
                                        .font(.caption)
                                        .foregroundColor(.white)
                                        .bold()
                                }
                            }
            }
            .frame(height: 300)
            .padding()
        }.onAppear{setupData()}
    }
}
