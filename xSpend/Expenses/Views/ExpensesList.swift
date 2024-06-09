//
//  ExpensesList.swift
//  xSpend
//
//  Created by Mike Paraskevopoulos on 9/6/24.
//

import SwiftUI

struct ExpensesList: View {
    @Environment(\.colorScheme) var colorScheme
    
    @ObservedObject var fbViewModel: FirebaseViewModel
    @State var exchangeRates: ExchangeRatesViewModel
    @State var currency: String
    var loadMoreExpenses: () -> Void
    
    var body: some View {
        List{
            ForEach(fbViewModel.expenseSectioned) { section in
                Section(header: Text("\(section.id)")) {
                    ForEach(section.expenses) { exp in
                        HStack{
                            VStack(alignment: .leading, spacing: 0){
                                HStack {
                                    Text("-"+String(exp.amount))
                                    Text(exp.currency)
                                    if currency != exp.currency {
                                        Text(" ->  - \(exchangeRates.getExchangeRate(baseCurrencyAmount: (Double(exp.amount)), currency: exp.currency), specifier: "%.2f")"
                                        )
                                        Text(currency)
                                    }
                                }
                                Text(exp.title).font(.system(size: 14)).opacity(0.6)
                            }
                            Spacer()
                            if let icon = fbViewModel.alltypesValueIcon[String(exp.type)]{
                                Image(systemName: String(icon))
                            }else{
                                Text(String(exp.type))
                            }
                        }
                    }
                }
            }
            
            VStack {
                HStack {
                    Spacer()
                    Button() {loadMoreExpenses()} label:{Text(fbViewModel.expenseSectioned.count>0 ? Constants.strings.loadMore : Constants.strings.noExpense).foregroundColor(colorScheme == .light ? Constants.colors.purpleColor : Constants.colors.lightPurpleColor).frame(alignment: .center)}.disabled(fbViewModel.expenseSectioned.count<=0)
                    Spacer()
                }
            }
        }
        VStack{}.frame(height: 100)
    }
}
