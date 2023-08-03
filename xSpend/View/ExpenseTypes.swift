//
//  ExpenseTypes.swift
//  xSpend
//
//  Created by Mike Paraskevopoulos on 1/8/23.
//

import SwiftUI
import SymbolPicker

struct ExpenseTypes: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode
    @State private var showingAlert = false
    @State private var ExpenseTypeName = ""
    @State private var iconPickerPresented = false
    @State private var icon = "cup.and.saucer.fill"
    @State var alltypes = [String:String]()
    let purpleColor = Color(red: 0.37, green: 0.15, blue: 0.80)
    var standardTypes = ["Coffee":"cup.and.saucer.fill","Gas":"fuelpump.circle","Rent":"house.circle","Electricity":"bolt.circle"]
    
    func setUp() {
        alltypes = standardTypes
        alltypes.updateValue("custom", forKey: "plus")
    }
    
    func add() {
        print("add")
    }
    
    var body: some View {
        NavigationStack{
            List{
                ForEach(alltypes.sorted(by: <), id: \.key) { key, value in
                    if standardTypes.keys.contains(key){
                        HStack{
                            Text(key).foregroundColor(.gray)
                            Spacer()
                            Image(systemName: value).resizable().foregroundColor(.gray)
                                .frame(width: 25, height: 25)
                            
                        }.frame(height: 40)
                    }else{
                        HStack{
                            Text(key)
                            Spacer()
                            Image(systemName: value).resizable()
                                .frame(width: 25, height: 25)
                            
                        }.frame(height: 40)
                            .swipeActions {
                                Button("Delete") {
                                    print("Right on!")
                                }
                                .tint(.red)
                            }
                    }
                }
            }
            .navigationTitle(Text("Expense Types"))
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button {
                        showingAlert = true
                    } label: {
                        Label("Add", systemImage: "plus").padding(.trailing).font(.system(size: 24)).foregroundColor(colorScheme == .light ? .black : .white)
                    }
                    .sheet(isPresented: $showingAlert) {
                        VStack(spacing: 20){
                            Text("New Expense").font(.system(size: 30))
                            HStack {
                                TextField("Enter new expense name", text: $ExpenseTypeName)
                                    .frame(height: 45)
                                        .textFieldStyle(PlainTextFieldStyle())
                                        .padding([.horizontal], 4)
                                        .cornerRadius(10)
                                        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.gray))
                                        .padding([.horizontal], 4)
                                Button {
                                    iconPickerPresented = true
                                } label: {
                                    ZStack{
                                        Rectangle()
                                            .fill(.gray)
                                            .frame(width: 45, height:45).cornerRadius(10)
                                        Image(systemName: icon).resizable().frame(width: 30,height: 30).foregroundColor(.white)
                                    }
                                }
                                .sheet(isPresented: $iconPickerPresented) {
                                    SymbolPicker(symbol: $icon)
                                }
                            }
                            Button("Add"){add()}.buttonStyle(.bordered).foregroundColor(colorScheme == .light ? purpleColor: .white)
                        }.padding(.horizontal,40)
                    }
                }
            }
        }.onAppear {
            setUp()
        }
    }
}

struct ExpenseTypes_Previews: PreviewProvider {
    static var previews: some View {
        ExpenseTypes()
    }
}
