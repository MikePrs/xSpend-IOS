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
    @ObservedObject var fbViewModel = FirebaseViewModel()
    let purpleColor = Color(red: 0.37, green: 0.15, blue: 0.80)
    
    func setUp() {
        fbViewModel.getExpenses(from: Calendar.current.date(byAdding: .weekOfYear, value: -2, to: Date.now)!, to:Date.now)
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
                        
                        HStack {
                            Spacer()
                            Button() {} label:{Text(fbViewModel.expenseSectioned.count>0 ? "Load More":"No Expenses").foregroundColor(purpleColor).frame(alignment: .center)}.disabled(fbViewModel.expenseSectioned.count<0)
                            Spacer()
                        }
                    }
                   
                }
            }.navigationBarTitle(Text("Expenses"))
        }.onAppear{setUp()}
    }
}

struct Expenses_Previews: PreviewProvider {
    static var previews: some View {
        ExpensesScreen()
    }
}
