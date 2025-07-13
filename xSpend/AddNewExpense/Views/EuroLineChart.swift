//
//  EuroLineChart.swift
//  xSpend
//
//  Created by Mike Paraskevopoulos on 12/7/25.
//

import SwiftUI
import Charts

struct EuroLineChartView: View {
    let data: [LineChartModel]
    
    var body: some View {
        VStack{
            Text(Constants.strings.weeklyReport)
                .font(.title2)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 20)
            
            Chart(data) { item in
                LineMark(
                    x: .value("Day", item.day),
                    y: .value("Euro", item.amount)
                )
                .foregroundStyle(Constants.colors.purpleColor)
                .symbol(Circle())
            }
            .chartXScale(domain: Utilities().currentWeekDates().first!...Utilities().endOfDay(for: Utilities().currentWeekDates().last!))
            .chartXAxis {
                AxisMarks(values: Utilities().currentWeekDates()) { value in
                    AxisGridLine()
                    AxisTick()
                    AxisValueLabel {
                        if let date = value.as(Date.self) {
                            Text(Utilities().dayFormatter.string(from: date))
                        }
                    }
                }
            }
            .chartYAxis {
                AxisMarks(position: .leading)
            }
            .frame(height: 300)
            
            VStack {
                
            }.frame(height: 150)
        }
        .padding(.horizontal, 30)
    }
}
