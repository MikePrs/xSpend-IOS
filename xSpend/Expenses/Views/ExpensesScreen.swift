//
//  Expenses.swift
//  xSpend
//
//  Created by Mike Paraskevopoulos on 22/7/23.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth
import AlertToast

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
    @ObservedObject var  expensesViewModel = ExpensesViewModel()
    @AppStorage(Constants.appStorage.currencySelection) private var currencySelection: String = ""
    @FocusState private var focusedField: ExpenseFilterFields?
    
    
    func setUp() async {
        await  expensesViewModel.configure(fbViewModel: fbViewModel,currencySelection:currencySelection)
    }
    
    var body: some View {
        VStack{
            Form{
                HeaderTitle(title: Constants.strings.expenses)
                
                Button() {
                     expensesViewModel.filtersSize = !expensesViewModel.enableFilters ? 340 : 130
                     expensesViewModel.enableFilters.toggle()
                } label:{
                    HStack {
                        Text(Constants.strings.filters).foregroundStyle(.gray)
                        Spacer()
                        Image(systemName:  expensesViewModel.enableFilters ? Constants.icon.up : Constants.icon.down).foregroundStyle(.gray)
                    }
                }
                if  expensesViewModel.enableFilters {
                    Picker(Constants.strings.category, selection: $expensesViewModel.filterType) {
                        Text(Constants.strings.any).tag(Constants.strings.any)
                        ForEach(fbViewModel.alltypesValues, id: \.self) { value in
                            Text(value).tag(value)
                        }
                    }.onChange(of:  expensesViewModel.filterType) { old, value in
                         expensesViewModel.filterExpensesDate(
                             expensesViewModel.startDate,
                             expensesViewModel.limitDate,
                            value
                        )
                    }
                    DatePicker(
                        Constants.strings.startDate,
                        selection: $expensesViewModel.startDate,
                        in: ...expensesViewModel.limitDate,
                        displayedComponents: [.date]
                    ).tint(Constants.colors.lightPurpleColor)
                        .onChange(of:  expensesViewModel.startDate) { old, newStartdate in
                             expensesViewModel.filterExpensesDate(
                                newStartdate,
                                 expensesViewModel.limitDate,
                                 expensesViewModel.filterType
                            )
                        }
                    
                    DatePicker(
                        Constants.strings.endDate,
                        selection: $expensesViewModel.limitDate,
                        in: ...Date.now,
                        displayedComponents: [.date]
                    ).tint(Constants.colors.lightPurpleColor)
                        .onChange(of:  expensesViewModel.limitDate) { old, newEndDate in
                             expensesViewModel.filterExpensesDate( expensesViewModel.startDate,newEndDate, expensesViewModel.filterType)
                        }
                    VStack {
                        Text(Constants.strings.priceRange).foregroundStyle(.gray)
                        HStack {
                            Text(Constants.strings.min).foregroundStyle(.gray)
                            TextField("", value: $expensesViewModel.minPrice,format:.number).keyboardType(.decimalPad).textFieldStyle(.roundedBorder)
                                .focused($focusedField, equals: .min)
                            Text(Constants.strings.max).foregroundStyle(.gray)
                            TextField("", value: $expensesViewModel.maxPrice,format:.number).keyboardType(.decimalPad).textFieldStyle(.roundedBorder)
                                .focused($focusedField, equals: .max)
                            
                            Text(Constants.strings.set).foregroundStyle(Utils.getPurpleColor(colorScheme)).onTapGesture {
                                 expensesViewModel.setPriceRange(
                                     expensesViewModel.startDate,
                                     expensesViewModel.limitDate,
                                     expensesViewModel.filterType
                                )
                            }
                        }
                    }
                }
            }
            .scrollDisabled(true)
            .frame(height:  expensesViewModel.filtersSize).ignoresSafeArea(.keyboard)
            if !expensesViewModel.isLoading {
                ExpensesList(
                    fbViewModel: fbViewModel,
                    expensesViewModel:expensesViewModel,
                    exchangeRates:  expensesViewModel.exchangeRates,
                    currency:  expensesViewModel.currency,
                    loadMoreExpenses:  expensesViewModel.loadMoreExpenses
                )
            }else{
                Spacer()
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                Spacer()
            }
        }.background(colorScheme == .light ? Color(uiColor: .secondarySystemBackground):nil)
        .ignoresSafeArea(.all, edges: [.bottom, .trailing])
        .task{
            await setUp()
        }
        .onDisappear {
            fbViewModel.expenseSectioned = []
             expensesViewModel.enableFilters = false
             expensesViewModel.filtersSize = 130
        }
        .toolbar {
            ToolbarItem(placement: .keyboard) {
                HStack{
                    Button(action: {
                         expensesViewModel.setPriceRange(
                             expensesViewModel.startDate,
                             expensesViewModel.limitDate,
                             expensesViewModel.filterType
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
        .toast(isPresenting: $expensesViewModel.showSuccessToast  ) {
            AlertToast(type: .systemImage(Constants.icon.trash,.gray), title:  expensesViewModel.successToastText, style: .style(titleColor: .white))
        }

    }
}
