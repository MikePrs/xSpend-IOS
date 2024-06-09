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
    @EnvironmentObject var fbViewModel : FirebaseViewModel
    private var countryCurrencyCode = CountryCurrencyCode().countryCurrency
    @AppStorage(Constants.appStorage.currencySelection) private var currencySelection: String = ""
    @State var startDate = Calendar.current.date(byAdding: .weekOfYear, value: -2, to: Date.now)!
    @State var filterType = Constants.strings.any
    @State var limitDate = Date.now
    @State var currency = ""
    @ObservedObject var exchangeRates = ExchangeRatesViewModel()
    @State var enableFilters:Bool=false
    @State var minPrice:Float? = nil
    @State var maxPrice:Float? = nil
    @State var filtersSize:CGFloat = 130
    @State var emptytext = ""
    @State var isLoading = true
    @FocusState private var focusedField: ExpenseFilterFields?
    
    
    func setUp() async {
        isLoading = true
        await exchangeRates.fetchExchangeRates()
        currency = countryCurrencyCode[currencySelection] ?? ""
        fbViewModel.getExpenseTypes()
        fbViewModel.sectioned = [:]
        fbViewModel.getExpenses(from: startDate, to:limitDate, category: Constants.strings.any,min: minPrice,max: maxPrice)
        isLoading = false
    }
    
    func loadMoreExpenses(){
        isLoading = true
        let olderEx = Calendar.current.date(byAdding: .weekOfYear, value: -2, to: startDate)!
        fbViewModel.getExpenses(from: olderEx, to:limitDate, category: filterType)
        startDate = olderEx
        isLoading = false
    }
    
    func filterExpensesDate(_ filterStartDate:Date, _ filterEndDate:Date, _ newFilterCategory:String) {
        isLoading = true
        fbViewModel.getExpenses(from: filterStartDate, to:filterEndDate, category: newFilterCategory)
        isLoading = false
    }
    
    func setPriceRange(_ filterStartDate:Date, _ filterEndDate:Date, _ newFilterCategory:String){
        isLoading = true
        hideKeyboard()
        fbViewModel.getExpenses(from: filterStartDate, to:filterEndDate, category: newFilterCategory, min: minPrice, max: maxPrice)
        isLoading = false
    }
    
    
    
    var body: some View {
        VStack{
            Form{
                HeaderTitle(title: Constants.strings.expenses)
                
                Button() {
                    filtersSize = !enableFilters ? 340 : 130
                    enableFilters.toggle()
                } label:{
                    HStack {
                        Text(Constants.strings.filters).foregroundStyle(.gray)
                        Spacer()
                        Image(systemName: enableFilters ? Constants.icon.up : Constants.icon.down).foregroundStyle(.gray)
                    }
                }
                if enableFilters {
                    Picker(Constants.strings.category, selection: $filterType) {
                        Text(Constants.strings.any).tag(Constants.strings.any)
                        ForEach(fbViewModel.alltypesValues, id: \.self) { value in
                            Text(value).tag(value)
                        }
                    }.onChange(of: filterType) { old, value in
                        filterExpensesDate(startDate,limitDate,value)
                    }
                    DatePicker(
                        Constants.strings.startDate,
                        selection: $startDate,
                        in: ...limitDate,
                        displayedComponents: [.date]
                    ).tint(Constants.colors.lightPurpleColor)
                        .onChange(of: startDate) { old, newStartdate in
                            filterExpensesDate(newStartdate,limitDate,filterType)
                        }
                    
                    DatePicker(
                        Constants.strings.endDate,
                        selection: $limitDate,
                        in: ...Date.now,
                        displayedComponents: [.date]
                    ).tint(Constants.colors.lightPurpleColor)
                        .onChange(of: limitDate) { old, newEndDate in
                            filterExpensesDate(startDate,newEndDate,filterType)
                        }
                    VStack {
                        Text(Constants.strings.priceRange).foregroundStyle(.gray)
                        HStack {
                            Text(Constants.strings.min).foregroundStyle(.gray)
                            TextField("", value: $minPrice,format:.number).keyboardType(.decimalPad).textFieldStyle(.roundedBorder)
                                .focused($focusedField, equals: .min)
                            Text(Constants.strings.max).foregroundStyle(.gray)
                            TextField("", value: $maxPrice,format:.number).keyboardType(.decimalPad).textFieldStyle(.roundedBorder)
                                .focused($focusedField, equals: .max)
                            
                            Text(Constants.strings.set).foregroundStyle(colorScheme == .light ? Constants.colors.purpleColor : Constants.colors.lightPurpleColor).onTapGesture {
                                setPriceRange(startDate,limitDate,filterType)
                            }
                        }
                    }
                }
            }
            .scrollDisabled(true)
            .frame(height: filtersSize).ignoresSafeArea(.keyboard)
            if !isLoading {
                ExpensesList(fbViewModel: fbViewModel, exchangeRates: exchangeRates, currency: currency, loadMoreExpenses: loadMoreExpenses)
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
            enableFilters = false
            filtersSize = 130
        }
        .toolbar {
            ToolbarItem(placement: .keyboard) {
                HStack{
                    Button(action: {
                        setPriceRange(startDate,limitDate,filterType)
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

struct Expenses_Previews: PreviewProvider {
    static var previews: some View {
        ExpensesScreen()
    }
}

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
