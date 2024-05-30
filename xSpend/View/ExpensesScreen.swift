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
    private var countryCurrencyCode = CountryCurrencyCode().countryCurrency
    @AppStorage("currencySelection") private var currencySelection: String = ""
    
    let purpleColor = Color(red: 0.37, green: 0.15, blue: 0.80)
    let lightPurpleColor = Color(red: 0.6, green: 0.6, blue: 1.0)
    
    @State var startDate = Calendar.current.date(byAdding: .weekOfYear, value: -2, to: Date.now)!
    @State var filterType = "Any"
    @State var limitDate = Date.now
    @State var currency = ""
    @ObservedObject var exchangeRates = ExchangeRatesViewModel()
    @State var enableFilters:Bool=false
    @State var minPrice:Int = 0
    @State var maxPrice:Int = 0
    @State var filtersSize:CGFloat = 80
    @State var emptytext = ""
    @FocusState private var focusedField: ExpenseFilterFields?
    
    
    func setUp() async {
        print(maxPrice)
        await exchangeRates.fetchExchangeRates()
        currency = countryCurrencyCode[currencySelection] ?? ""
        fbViewModel.getExpenseTypes()
        fbViewModel.sectioned = [:]
        fbViewModel.getExpenses(from: startDate, to:limitDate, category: "Any")
    }
    
    func loadMoreExpenses(){
        let olderEx = Calendar.current.date(byAdding: .weekOfYear, value: -2, to: startDate)!
        fbViewModel.getExpenses(from: olderEx, to:limitDate, category: filterType)
        startDate = olderEx
    }
    
    func filterExpensesDate(_ filterStartDate:Date, _ filterEndDate:Date, _ newFilterCategory:String) {
        fbViewModel.getExpenses(from: filterStartDate, to:filterEndDate, category: newFilterCategory)
    }
    
    func setPriceRange(){
        hideKeyboard()
    }
    
    
    
    var body: some View {
        VStack {
            Form{
                HStack {
                    Button() {
                        filtersSize = !enableFilters ? 300 : 80
                        enableFilters.toggle()
                    } label:{
                        HStack {
                            Text("FILTERS").foregroundStyle(.gray)
                            Spacer()
                            Image(systemName: enableFilters ? "chevron.up" : "chevron.down" ).foregroundStyle(.gray)
                        }
                    }
                }
                if enableFilters {
                    Picker("Category", selection: $filterType) {
                        Text("Any").tag("Any")
                        ForEach(fbViewModel.alltypesValues, id: \.self) { value in
                            Text(value).tag(value)
                        }
                    }.onChange(of: filterType, perform: { value in
                        filterExpensesDate(startDate,limitDate,value)
                    })
                    DatePicker(
                        "Start Date",
                        selection: $startDate,
                        in: ...limitDate,
                        displayedComponents: [.date]
                    ).tint(lightPurpleColor)
                    .onChange(of: startDate, perform: { newStartdate in
                        filterExpensesDate(newStartdate,limitDate,filterType)
                    })
                    
                    DatePicker(
                        "End Date",
                        selection: $limitDate,
                        in: ...Date.now,
                        displayedComponents: [.date]
                    ).tint(lightPurpleColor)
                    .onChange(of: limitDate, perform: { newEndDate in
                        filterExpensesDate(startDate,newEndDate,filterType)
                    })
                    VStack {
                        Text("PRICE RANGE").foregroundStyle(.gray)
                        HStack {
                            Text("min").foregroundStyle(.gray)
                            TextField("", value: $minPrice,format:.number).keyboardType(.decimalPad).textFieldStyle(.roundedBorder)
                                .focused($focusedField, equals: .min)
                            Text("max").foregroundStyle(.gray)
                            TextField("", value: $maxPrice,format:.number).keyboardType(.decimalPad).textFieldStyle(.roundedBorder)
                                .focused($focusedField, equals: .max)
                            Text("Set").foregroundStyle(colorScheme == .light ? purpleColor : lightPurpleColor).onTapGesture {
                                setPriceRange()
                            }
                        }
                    }
                }
            }.scrollDisabled(true).frame(height: filtersSize).ignoresSafeArea(.keyboard)
            
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
                        Button() {loadMoreExpenses()} label:{Text(fbViewModel.expenseSectioned.count>0 ? "Load More":"No Expenses").foregroundColor(colorScheme == .light ? purpleColor : lightPurpleColor).frame(alignment: .center)}.disabled(fbViewModel.expenseSectioned.count<0)
                        Spacer()
                    }
                }
            }
            VStack{}.frame(height: 100)
        }.task{await setUp()}.onDisappear {fbViewModel.sectioned = [:]}
            .toolbar {
                ToolbarItem(placement: .keyboard) {
                    HStack{
                        Button(action: {
                            setPriceRange()
                        }) {
                            Text("Set").foregroundStyle(lightPurpleColor)
                        }
                        Spacer()
                        Button(action: {
                            focusedField = focusedField?.next
                        }) {
                            Image(systemName: focusedField == .min ? "chevron.right" : "chevron.left" ).foregroundStyle(lightPurpleColor)
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
