//
//  ExpensesListAnalyticsPanelView.swift
//  xSpend
//
//  Created by Mike Paraskevopoulos on 14/7/25.
//

import SwiftUI
import Charts

struct ExpensesListAnalyticsPanelView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) var dismiss
    var data : [SectionedExpenses]

    @State var chartType : String = Constants.strings.multiLine
    
    var body: some View {
        VStack{
            topNavBar
            ScrollView{
                HStack{
                    HeaderTitle(title: Constants.strings.analytics)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading,8)
                    Spacer()
                    Picker(Constants.strings.chartType, selection: $chartType) {
                        Text(Constants.strings.multiLine).tag(Constants.strings.multiLine)
                        Text(Constants.strings.pieChart).tag(Constants.strings.pieChart)
                    }.pickerStyle(DefaultPickerStyle())
                        .tint(colorScheme == .light ? Color.black : Color.white)
                        .padding(.vertical, 5)
                        .background(colorScheme == .light ? Color.white : Color.gray.opacity(0.2))
                        .cornerRadius(20)
                }.padding(.horizontal,8)
                
                if chartType == Constants.strings.multiLine {
                    MultiLineExpenseGraphView(data: data)
                }else if chartType == Constants.strings.pieChart {
                    PieChartView(data: data)
                }
            }
        }.background(colorScheme == .light ? Color(uiColor: .secondarySystemBackground) : .black)
    }
    
    var topNavBar: some View {
        HStack {
            Image(systemName: Constants.icon.left)
                .foregroundStyle(Utils.getPurpleColor(colorScheme))
            Button(Constants.strings.back) {
                dismiss()
            }.tint(Utils.getPurpleColor(colorScheme))
            Spacer()
        }.padding().background(colorScheme == .light ? Color(uiColor: .secondarySystemBackground):nil)
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

extension String {
    var dayMonthDateFormat: Date? {
        let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy"
            formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter.date(from: self)
    }
}
