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
    @State var limitDate = Calendar.current.date(byAdding: .weekOfYear, value: -2, to: Date.now)
    
    func setUp() {
        fbViewModel.sectioned = [:]
        fbViewModel.getExpenses(from: limitDate!, to:Date.now)
    }
    
    func loadMoreExpenses(){
        let newLimit = Calendar.current.date(byAdding: .weekOfYear, value: -2, to: limitDate!)
        fbViewModel.getExpenses(from: newLimit!, to:limitDate!)
        limitDate = newLimit
    }
    
    
    
    var body: some View {
        NavigationView{
            ZStack{
                VStack {
                    List{
                        ForEach(fbViewModel.expenseSectioned) { section in
                            Section(header: Text("\(section.id)")) {
                                ForEach(section.expenses) { exp in
                                    Text(exp.title)
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
