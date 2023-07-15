//
//  ContentView.swift
//  xSpend
//
//  Created by Mike Paraskevopoulos on 9/7/23.
//

import SwiftUI
import FirebaseAuth

struct ContentView: View {
    let purpleColor = Color(red: 0.37, green: 0.15, blue: 0.80)
    @State var loginLink: Bool = false
    @State var signupLink: Bool = false
    @State var mainAppLink: Bool = false
    @Environment(\.colorScheme) var colorScheme
    
    
    func onLoad(){
        if Auth.auth().currentUser != nil {
            print("user")
            self.mainAppLink = true
        }
    }
    
    
    var body: some View {
        ZStack{
            NavigationStack {
                VStack {
                    Spacer()
                    Text("Welcome to ").font(.system(size: 30)).foregroundColor(colorScheme == .dark ?.white:purpleColor)
                    
                    Text("xSpend").font(.system(size: 35)).foregroundColor(purpleColor).bold()
                    Spacer()
                    Image("expensesIcon").resizable().frame(width: 200,height: 200)
                    Spacer()
                    Button(action: {self.loginLink = true }){
                        Text("Login").padding().frame(maxWidth: .infinity)
                    }
                    .tint(purpleColor)
                    .buttonStyle(.borderedProminent)
                    .font(.system(size: 25))
                    
                    Button(action: {self.signupLink = true }){
                        Text("SignUp").padding().frame(maxWidth: .infinity)
                    }
                    .tint(purpleColor)
                    .buttonStyle(.bordered)
                    .font(.system(size: 25))
                }.padding()
                    .navigationBarBackButtonHidden(true)
                    .navigationDestination(isPresented: $loginLink) {
                        LoginScreen()
                    }
                    .navigationDestination(isPresented: $signupLink) {
                        SignupScreen()
                    }
                    .navigationDestination(isPresented: $mainAppLink) {
                        TabManager()
                    }
            }
        }.onAppear {onLoad()}
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
