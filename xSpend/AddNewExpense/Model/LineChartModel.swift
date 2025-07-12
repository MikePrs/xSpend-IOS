//
//  LineChartModel.swift
//  xSpend
//
//  Created by Mike Paraskevopoulos on 12/7/25.
//

import Foundation

struct LineChartModel: Identifiable {
    let id = UUID()
    let day: Date       // Day of the month (1-31)
    let amount: Float   // Euro amount
}
