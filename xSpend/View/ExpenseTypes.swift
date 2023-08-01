//
//  ExpenseTypes.swift
//  xSpend
//
//  Created by Mike Paraskevopoulos on 1/8/23.
//

import SwiftUI

struct ExpenseTypes: View {
    @Environment(\.colorScheme) var colorScheme
    var standardTypes = ["Coffee":"cup.and.saucer.fill","Gas":"fuelpump.circle","Rent":"house.circle","Electricity":"bolt.circle"]
    @State var alltypes = [String:String]()
    
    func setUp() {
        alltypes = standardTypes
        alltypes.updateValue("custom", forKey: "plus")
    }
    
    var body: some View {
        NavigationView{
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
            .navigationBarTitle(Text("Expense Types"))
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button {
                        print("Edit button was tapped")
                    } label: {
                        Label("Add", systemImage: "plus.circle").padding(.top,90).padding(.trailing).font(.system(size: 24)).foregroundColor(colorScheme == .light ? .black : .white)
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
