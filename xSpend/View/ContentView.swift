//
//  ContentView.swift
//  xSpend
//
//  Created by Mike Paraskevopoulos on 9/7/23.
//

import SwiftUI
import FirebaseAuth

struct LandingScreen: View {
    let purpleColor = Color(red: 0.37, green: 0.15, blue: 0.80)
    @State var loginLink: Bool = false
    @State var signupLink: Bool = false
    @Environment(\.colorScheme) var colorScheme
    
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
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LandingScreen()
    }
}

struct ContentView: View {
    @State var mainAppLink: Bool = false
    func onLoad(){
        if Auth.auth().currentUser != nil {
            self.mainAppLink = true
            print("user")
        }else{
            self.mainAppLink = false
            print("no user")
        }
    }
    var body: some View {
            NavigationStack{
                if mainAppLink {
                    TabManager()
                }else{
                    LandingScreen()
                }
            }.onAppear {onLoad()}
    }
}
