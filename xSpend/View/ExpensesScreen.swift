//
//  Expenses.swift
//  xSpend
//
//  Created by Mike Paraskevopoulos on 22/7/23.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct ExpensesScreen: View {
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var fbViewModel = FirebaseViewModel()
    let purpleColor = Color(red: 0.37, green: 0.15, blue: 0.80)
    @State var startDate = Calendar.current.date(byAdding: .weekOfYear, value: -2, to: Date.now)!
    @State var filterCategory = "Any";
    @State var limitDate = Date.now;

    
    func setUp() {
        fbViewModel.getExpenseTypes()
        fbViewModel.sectioned = [:]
        fbViewModel.getExpenses(from: limitDate, to:startDate)
        print(fbViewModel.alltypesValueIcon)
    }
    
    func loadMoreExpenses(){
        let olderEx = Calendar.current.date(byAdding: .weekOfYear, value: -2, to: startDate)!
        fbViewModel.getExpenses(from: olderEx, to:limitDate)
        startDate = olderEx
    }
    
    func filterExpensesDate(_ filterStartDate:Date, _ filterEndDate:Date) {
            fbViewModel.getExpenses(from: filterStartDate, to:filterEndDate)
    }
    
    
    
    var body: some View {
        NavigationView{
            ZStack{
                VStack {
                    
                    Form{
                        Section(header: Text("FILTERS")) {
                            Picker("Category", selection: $filterCategory) {
                                Text("Any")
                            }
                            DatePicker(
                                "Start Date",
                                selection: $startDate,
                                in: ...limitDate,
                                displayedComponents: [.date]
                            ).onChange(of: startDate, perform: { newStartdate in
                                filterExpensesDate(newStartdate,limitDate)
                            })
                            DatePicker(
                                "End Date",
                                selection: $limitDate,
                                in: ...Date.now, 
                                displayedComponents: [.date]
                            ).onChange(of: limitDate, perform: { newEndDate in
                                filterExpensesDate(startDate,newEndDate)
                            })
                        }
                    }
                    .frame(height: 170)
                    
                    List{
                        ForEach(fbViewModel.expenseSectioned) { section in
                            Section(header: Text("\(section.id)")) {
                                ForEach(section.expenses) { exp in
                                    VStack{
                                        HStack{
                                            Text(exp.title)
                                            Text(String(exp.amount))
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
                    
                    VStack{
                        
                    }.frame(height: 100)
                }
                .background(colorScheme == .light ? Color(uiColor: .secondarySystemBackground):nil)
                .ignoresSafeArea(.all, edges: [.bottom, .trailing])
            }.navigationBarTitle(Text("Expenses"))
        }.onAppear{setUp()}.onDisappear {fbViewModel.sectioned = [:]}
    }
}

struct Expenses_Previews: PreviewProvider {
    static var previews: some View {
        ExpensesScreen()
    }
}
