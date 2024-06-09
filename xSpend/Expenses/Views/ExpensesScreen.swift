//
//  Expenses.swift
//  xSpend
//
//  Created by Mike Paraskevopoulos on 22/7/23.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

enum ExpenseFilterFields {
    case min,max
    
    var next:ExpenseFilterFields{
        switch self {
        case .min:
            return .max
        case .max:
            return .min
        }
    }
}

struct ExpensesScreen: View {
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var fbViewModel = FirebaseViewModel()
    @ObservedObject var expenseViewModel = ExpensesViewModel()
    @AppStorage(Constants.appStorage.currencySelection) private var currencySelection: String = ""
    @FocusState private var focusedField: ExpenseFilterFields?
    
    
    func setUp() async {
        await expenseViewModel.configure(fbViewModel: fbViewModel,currencySelection:currencySelection)
    }
    
    var body: some View {
        VStack{
            Form{
                HeaderTitle(title: Constants.strings.expenses)
                
                Button() {
                    expenseViewModel.filtersSize = !expenseViewModel.enableFilters ? 340 : 130
                    expenseViewModel.enableFilters.toggle()
                } label:{
                    HStack {
                        Text(Constants.strings.filters).foregroundStyle(.gray)
                        Spacer()
                        Image(systemName: expenseViewModel.enableFilters ? Constants.icon.up : Constants.icon.down).foregroundStyle(.gray)
                    }
                }
                if expenseViewModel.enableFilters {
                    Picker(Constants.strings.category, selection: $expenseViewModel.filterType) {
                        Text(Constants.strings.any).tag(Constants.strings.any)
                        ForEach(fbViewModel.alltypesValues, id: \.self) { value in
                            Text(value).tag(value)
                        }
                    }.onChange(of: expenseViewModel.filterType) { old, value in
                        expenseViewModel.filterExpensesDate(
                            expenseViewModel.startDate,
                            expenseViewModel.limitDate,
                            value
                        )
                    }
                    DatePicker(
                        Constants.strings.startDate,
                        selection: $expenseViewModel.startDate,
                        in: ...expenseViewModel.limitDate,
                        displayedComponents: [.date]
                    ).tint(Constants.colors.lightPurpleColor)
                        .onChange(of: expenseViewModel.startDate) { old, newStartdate in
                            expenseViewModel.filterExpensesDate(
                                newStartdate,
                                expenseViewModel.limitDate,
                                expenseViewModel.filterType
                            )
                        }
                    
                    DatePicker(
                        Constants.strings.endDate,
                        selection: $expenseViewModel.limitDate,
                        in: ...Date.now,
                        displayedComponents: [.date]
                    ).tint(Constants.colors.lightPurpleColor)
                        .onChange(of: expenseViewModel.limitDate) { old, newEndDate in
                            expenseViewModel.filterExpensesDate(expenseViewModel.startDate,newEndDate,expenseViewModel.filterType)
                        }
                    VStack {
                        Text(Constants.strings.priceRange).foregroundStyle(.gray)
                        HStack {
                            Text(Constants.strings.min).foregroundStyle(.gray)
                            TextField("", value: $expenseViewModel.minPrice,format:.number).keyboardType(.decimalPad).textFieldStyle(.roundedBorder)
                                .focused($focusedField, equals: .min)
                            Text(Constants.strings.max).foregroundStyle(.gray)
                            TextField("", value: $expenseViewModel.maxPrice,format:.number).keyboardType(.decimalPad).textFieldStyle(.roundedBorder)
                                .focused($focusedField, equals: .max)
                            
                            Text(Constants.strings.set).foregroundStyle(colorScheme == .light ? Constants.colors.purpleColor : Constants.colors.lightPurpleColor).onTapGesture {
                                expenseViewModel.setPriceRange(
                                    expenseViewModel.startDate,
                                    expenseViewModel.limitDate,
                                    expenseViewModel.filterType
                                )
                            }
                        }
                    }
                }
            }
            .scrollDisabled(true)
            .frame(height: expenseViewModel.filtersSize).ignoresSafeArea(.keyboard)
            if !expenseViewModel.isLoading {
                ExpensesList(
                    fbViewModel: fbViewModel,
                    exchangeRates: expenseViewModel.exchangeRates,
                    currency: expenseViewModel.currency,
                    loadMoreExpenses: expenseViewModel.loadMoreExpenses
                )
            }else{
                Spacer()
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                Spacer()
            }
        }
        .task{
            await setUp()
        }
        .onDisappear {
            fbViewModel.expenseSectioned = []
            expenseViewModel.enableFilters = false
            expenseViewModel.filtersSize = 130
        }
        .toolbar {
            ToolbarItem(placement: .keyboard) {
                HStack{
                    Button(action: {
                        expenseViewModel.setPriceRange(
                            expenseViewModel.startDate,
                            expenseViewModel.limitDate,
                            expenseViewModel.filterType
                        )
                    }) {
                        Text(Constants.strings.set).foregroundStyle(Constants.colors.lightPurpleColor)
                    }
                    Spacer()
                    Button(action: {
                        focusedField = focusedField?.next
                    }) {
                        Image(systemName: focusedField == .min ? Constants.icon.right : Constants.icon.left ).foregroundStyle(Constants.colors.lightPurpleColor)
                    }
                }
            }
        }
        .background(colorScheme == .light ? Color(uiColor: .secondarySystemBackground):nil)
        .ignoresSafeArea(.all, edges: [.bottom, .trailing])
    }
}
