//
//  LineChartModel.swift
//  xSpend
//
//  Created by Mike Paraskevopoulos on 12/7/25.
//

import Foundation

struct LineChartModel: Identifiable, Hashable {
    let id = UUID()
    let day: Date
    let amount: Float
    var isActive: Bool?
}
