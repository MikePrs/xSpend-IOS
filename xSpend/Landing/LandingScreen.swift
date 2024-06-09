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
                    Text(Constants.strings.welcomTo).font(.system(size: 30)).foregroundColor(colorScheme == .dark ?.white:purpleColor)
                    
                    Text(Constants.strings.xSpend).font(.system(size: 35)).foregroundColor(purpleColor).bold()
                    Spacer()
                    Image(Constants.icon.expenses).resizable().frame(width: 200,height: 200)
                    Spacer()
                    Button(action: {self.loginLink = true }){
                        Text(Constants.strings.login).padding().frame(maxWidth: .infinity)
                    }
                    .tint(purpleColor)
                    .buttonStyle(.borderedProminent)
                    .font(.system(size: 25))
                    
                    Button(action: {self.signupLink = true }){
                        Text(Constants.strings.signUp).padding().frame(maxWidth: .infinity)
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
    @State var isLoading: Bool = true
    
    func onLoad(){
        isLoading = true
        if Auth.auth().currentUser != nil {
            self.mainAppLink = true
            print("user")
        }else{
            self.mainAppLink = false
            print("no user")
        }
        isLoading = false
    }
    var body: some View {
            NavigationStack{
                if !isLoading {
                    if mainAppLink {
                        TabManager()
                    }else{
                        LandingScreen()
                    }
                }else{
                    Spacer()
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                    Spacer()
                }
            }.onAppear {onLoad()}
    }
}
