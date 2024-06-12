//
//  ExpensesList.swift
//  xSpend
//
//  Created by Mike Paraskevopoulos on 9/6/24.
//

import SwiftUI
import AlertToast

struct ExpensesList: View {
    @Environment(\.colorScheme) var colorScheme
    
    @ObservedObject var fbViewModel: FirebaseViewModel
    @ObservedObject var addNewExpenseViewModel = AddNewExpenseViewModel()
    @ObservedObject var expensesViewModel : ExpensesViewModel
    @State var exchangeRates: ExchangeRatesViewModel
    @State var currency: String
    @State var showSheet = false
    @State var showingDeleteAlert = false
    var loadMoreExpenses: () -> Void
    @State var detailViewType:ExpenseDetailViewType = .view
    
    @State var test = true
    
    func setUp(){
        
    }
    
    var body: some View {
        List{
            ForEach(fbViewModel.expenseSectioned) { section in
                Section(header: Text("\(section.id)")) {
                    ForEach(section.expenses) { exp in
                        Button {
                            self.detailViewType = .view
                            addNewExpenseViewModel.configure(fbViewModel: fbViewModel,expense:exp)
                            showSheet = true
                        } label: {
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
                            }.foregroundColor(colorScheme == .light ? .black : .white)
                        }
                        .swipeActions {
                            Button(Constants.strings.delete) {
                                showingDeleteAlert = true
                                expensesViewModel.expenseId = exp.id
                            }
                            .tint(.red)
                            
                            Button(Constants.strings.edit) {
                                detailViewType = .update
                                showSheet = true
                            }
                            .tint(Utils.getPurpleColor(colorScheme))
                        }
                    }
                }
                
            }
            
            VStack {
                HStack {
                    Spacer()
                    Button() {loadMoreExpenses()} label:{Text(fbViewModel.expenseSectioned.count>0 ? Constants.strings.loadMore : Constants.strings.noExpense).foregroundColor(Utils.getPurpleColor(colorScheme)).frame(alignment: .center)}.disabled(fbViewModel.expenseSectioned.count<=0)
                    Spacer()
                }
            }.sheet(isPresented: $showSheet) {
                ExpenseDetail(addNewExpenseViewModel:addNewExpenseViewModel, fbViewModel: fbViewModel, viewType: detailViewType)
            }
            .alert(Constants.strings.expenseDelete, isPresented: $showingDeleteAlert) {
                Button(Constants.strings.no, role: .cancel) {
                    expensesViewModel.expenseId = ""
                }
                Button(Constants.strings.delete, role: .destructive) {
                    Task{
                        await expensesViewModel.removeExpense()
                    }
                }
            }
            .alert(expensesViewModel.alertMessage, isPresented: $expensesViewModel.showingErrAlert) {
                Button(Constants.strings.ok, role: .cancel) { }
            }
        }.onAppear{setUp()}
        VStack{}.frame(height: 100)
    }
}
