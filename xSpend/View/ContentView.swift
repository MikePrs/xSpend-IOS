//
//  ContentView.swift
//  xSpend
//
//  Created by Mike Paraskevopoulos on 9/7/23.
//

import SwiftUI

struct ContentView: View {
    let purpleColor = Color(red: 0.37, green: 0.15, blue: 0.80)
    @State var isLoginLinkActive: Bool = false
    @State var isSignupLinkActive: Bool = false
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                Text("Welcome to ").font(.system(size: 30)).foregroundColor(colorScheme == .dark ?.white:purpleColor)
                
                Text("xSpend").font(.system(size: 35)).foregroundColor(purpleColor).bold()
                Spacer()
                Image("expensesIcon").resizable().frame(width: 200,height: 200)
                Spacer()
                NavigationLink(destination: LoginScreen(), isActive: $isLoginLinkActive){
                    Button(action: {self.isLoginLinkActive = true }){
                        Text("Login").padding().frame(maxWidth: .infinity)
                    }
                    .tint(purpleColor)
                    .buttonStyle(.borderedProminent)
                    .font(.system(size: 25))
                }
                NavigationLink(destination: SignupScreen(), isActive: $isSignupLinkActive){
                    Button(action: {self.isSignupLinkActive = true }){
                        Text("SignUp").padding().frame(maxWidth: .infinity)
                    }
                    .tint(purpleColor)
                    .buttonStyle(.bordered)
                    .font(.system(size: 25))
                }
            }
            .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
