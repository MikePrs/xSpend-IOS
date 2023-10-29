//
//  Expenses.swift
//  xSpend
//
//  Created by Mike Paraskevopoulos on 22/7/23.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct Expenses: View {
    @ObservedObject var fbViewModel = FirebaseViewModel()
    
    
    func setUp() {
        fbViewModel.getExpenses()
        print(fbViewModel.expenses)
    }

    
    
    var body: some View {
        ZStack{
            List{
                ForEach(fbViewModel.expenses) {ex in
                    Text(ex.title)
                }
            }
        }.onAppear{setUp()}
    }
}

struct Expenses_Previews: PreviewProvider {
    static var previews: some View {
        Expenses()
    }
}
