//
//  AddNewExpense.swift
//  xSpend
//
//  Created by Mike Paraskevopoulos on 13/7/23.
//

import SwiftUI
import FirebaseAuth

struct AddNewExpense: View {
    @State private var expenseTitle: String = ""
    @State private var expenseIcon: String = "eurosign.circle"
    @State private var expenseType: String = ""
    @State private var expenseNotes: String = ""
    @State private var expenseAmount: Float = 0.0
    private let types = ["Coffee","Gas","Rent","Electricity"]
    let purpleColor = Color(red: 0.37, green: 0.15, blue: 0.80)
    
    
    var body: some View {
        NavigationView{
            ZStack{
                Form {
                    TextField("Title", text: $expenseTitle)
                    HStack{
                        Text("Amount:   ")
                        TextField("Amount", value: $expenseAmount,format:.number).keyboardType(.decimalPad)
                    }
                    Picker("Type", selection: $expenseType){
                        ForEach(types, id: \.self) { value in
                            Text(value).tag(value)
                        }
                    }.pickerStyle(.navigationLink)
                    TextField("Notes", text: $expenseNotes, axis: .vertical).frame(height: 200)
                    Section {
                        Button(role: .cancel) {print("add")} label:{Text("Add").foregroundColor(purpleColor)}
                    }
                }.scrollDismissesKeyboard(.immediately)
            }
            .navigationBarTitle(Text("Add new expense"))
        }.onAppear{}
    }
}

struct AddNewExpense_Previews: PreviewProvider {
    static var previews: some View {
        AddNewExpense()
    }
}


extension View {
    func hideKeyboard() {
        let resign = #selector(UIResponder.resignFirstResponder)
        UIApplication.shared.sendAction(resign, to: nil, from: nil, for: nil)
    }
}
