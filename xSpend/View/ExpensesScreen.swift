//
//  Expenses.swift
//  xSpend
//
//  Created by Mike Paraskevopoulos on 22/7/23.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth
import RangeUISlider

struct ExpensesScreen: View {
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var fbViewModel = FirebaseViewModel()
    private var countryCurrencyCode = CountryCurrencyCode().countryCurrency
    @AppStorage("currencySelection") private var currencySelection: String = ""
    
    let purpleColor = Color(red: 0.37, green: 0.15, blue: 0.80)
    @State var startDate = Calendar.current.date(byAdding: .weekOfYear, value: -2, to: Date.now)!
    @State var filterType = "Any"
    @State var limitDate = Date.now
    @State var currency = ""
    @ObservedObject var exchangeRates = ExchangeRatesViewModel()
    @State var minPriceValueSelected:CGFloat = 0
    @State var maxPriceValueSelected:CGFloat = 500
    @State var enableFilters:Bool=false
    @State var minPrice:Float = 0
    @State var filtersSize:CGFloat = 50
    
    func setUp() async {
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
    
    
    
    var body: some View {
        NavigationView{
            ZStack{
                VStack {
                    Form{
                                HStack {
                                    Button() {
                                        filtersSize = !enableFilters ? 260 : 50
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
                                ).onChange(of: startDate, perform: { newStartdate in
                                    filterExpensesDate(newStartdate,limitDate,filterType)
                                })
                                DatePicker(
                                    "End Date",
                                    selection: $limitDate,
                                    in: ...Date.now,
                                    displayedComponents: [.date]
                                ).onChange(of: limitDate, perform: { newEndDate in
                                    filterExpensesDate(startDate,newEndDate,filterType)
                                })
                                VStack {
                                    HStack {
                                        TextField("", value: $minPrice,format:.number).keyboardType(.decimalPad).textFieldStyle(.roundedBorder)
                                        TextField("", value: $minPrice,format:.number).keyboardType(.decimalPad).textFieldStyle(.roundedBorder)
                                    }
                                    
                                    RangeSlider(minValueSelected: self.$minPriceValueSelected, maxValueSelected: self.$minPriceValueSelected)
                                        .scaleMinValue(0)
                                        .scaleMaxValue(1000)
                                        .defaultValueLeftKnob(0)
                                        .defaultValueRightKnob(500)
                                        .rangeSelectedGradientColor1(purpleColor)
                                        .rangeSelectedGradientColor2(purpleColor)
                                        .rangeSelectedGradientStartPoint(CGPoint(x: 0, y: 0.5))
                                        .rangeSelectedGradientEndPoint(CGPoint(x: 0, y: 1))
                                        .rangeNotSelectedGradientColor1(.gray)
                                        .rangeNotSelectedGradientColor2(.gray)
                                        .rangeNotSelectedGradientStartPoint(CGPoint(x: 0, y: 0.5))
                                        .rangeNotSelectedGradientEndPoint(CGPoint(x: 0, y: 1))
                                        .barHeight(5)
                                        .leftKnobColor(purpleColor)
                                        .leftKnobWidth(30)
                                        .leftKnobHeight(30)
                                        .leftKnobCorners(15)
                                        .rightKnobColor(purpleColor)
                                        .rightKnobWidth(30)
                                        .rightKnobHeight(30)
                                        .rightKnobCorners(15)
                                        .showKnobsLabels(false)
                                        .knobsLabelFontSize(18)
                                        .knobsLabelFontColor(Color(.gray))
                                        .accessibility(identifier: "RangeUISliderStandard")
                                        .padding([.bottom , .top],10)
                                }
                        }
                    }.scrollDisabled(true).frame(height: filtersSize)
                    
                    List{
                        ForEach(fbViewModel.expenseSectioned) { section in
                            Section(header: Text("\(section.id)")) {
                                ForEach(section.expenses) { exp in
                                    VStack{
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
                        }
                        
                        VStack {
                            HStack {
                                Spacer()
                                Button() {loadMoreExpenses()} label:{Text(fbViewModel.expenseSectioned.count>0 ? "Load More":"No Expenses").foregroundColor(purpleColor).frame(alignment: .center)}.disabled(fbViewModel.expenseSectioned.count<0)
                                Spacer()
                            }
                        }
                    }
                    VStack{}.frame(height: 100)
                }
                .background(colorScheme == .light ? Color(uiColor: .secondarySystemBackground):nil)
                .ignoresSafeArea(.all, edges: [.bottom, .trailing])
            }.navigationBarTitle(Text("Expenses"))
        }.task{await setUp()}.onDisappear {fbViewModel.sectioned = [:]}
    }
}

struct Expenses_Previews: PreviewProvider {
    static var previews: some View {
        ExpensesScreen()
    }
}
