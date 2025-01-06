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
    @EnvironmentObject var router: Router
    @ObservedObject var fbViewModel: FirebaseViewModel
    @ObservedObject var addNewExpenseViewModel : AddNewExpenseViewModel
    @ObservedObject var expensesViewModel : ExpensesViewModel
    @State var exchangeRates: ExchangeRatesViewModel
    @State var currency: String
    @State var showingDeleteAlert = false
    var loadMoreExpenses: () -> Void
    
    var body: some View {
        List{
            ForEach(expensesViewModel.expenseList) { section in
                Section(header: Text("\(section.id)")) {
                    ForEach(section.expenses) { exp in
                        Button {
                            addNewExpenseViewModel.configure(fbViewModel: fbViewModel,expense:exp)
                            addNewExpenseViewModel.detailViewType = .view
                            router.navigate(to: .expenseDetail(
                                addNewExpenseViewModel: addNewExpenseViewModel,
                                fbViewModel: fbViewModel,
                                viewType: .view
                            ))
                        } label: {
                            HStack{
                                VStack(alignment: .leading, spacing: 0){
                                    HStack {
                                        Text("-"+String(exp.amount))
                                        Text(exp.currency)
                                        if currency != exp.currency, exp.amountConverted != "Api Error" {
                                            Text(" -> ").foregroundStyle(.gray)
                                            Text("-\(exp.amountConverted)")
                                            Text(currency)
                                        }
                                    }.padding(.vertical,2)
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
                                addNewExpenseViewModel.configure(fbViewModel: fbViewModel,expense:exp)
                                addNewExpenseViewModel.detailViewType = .update
                                expensesViewModel.openDetails = true
                            }
                            .tint(Utils.getPurpleColor(colorScheme))
                        }
                    }
                }
                
            }
            
            VStack {
                HStack {
                    Spacer()
                    Button() {loadMoreExpenses()} label:{Text(expensesViewModel.expenseList.count>0 ? Constants.strings.loadMore : Constants.strings.noExpense).foregroundColor(Utils.getPurpleColor(colorScheme)).frame(alignment: .center)}.disabled(expensesViewModel.expenseList.count<=0)
                    Spacer()
                }
            }
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
        
        VStack{}.frame(height: 100)
    }
}
