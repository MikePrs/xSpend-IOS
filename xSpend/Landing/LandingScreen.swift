//
//  ContentView.swift
//  xSpend
//
//  Created by Mike Paraskevopoulos on 9/7/23.
//

import SwiftUI
import FirebaseAuth
import WidgetKit

struct LandingScreen: View {
    let purpleColor = Color(red: 0.37, green: 0.15, blue: 0.80)
    @State var loginLink: Bool = false
    @State var signupLink: Bool = false
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var router: Router
    
    var body: some View {
        ZStack{
                VStack {
                    Spacer()
                    Text(Constants.strings.welcomTo).font(.system(size: 30)).foregroundColor(colorScheme == .dark ?.white:purpleColor)
                    
                    Text(Constants.strings.xSpend).font(.system(size: 35)).foregroundColor(purpleColor).bold()
                    Spacer()
                    Image(Constants.icon.expenses).resizable().frame(width: 200,height: 200)
                    Spacer()
                    Button(action: {
                        router.navigate(to: .login)
                    }){
                        Text(Constants.strings.login).padding().frame(maxWidth: .infinity)
                    }
                    .tint(purpleColor)
                    .buttonStyle(.borderedProminent)
                    .font(.system(size: 25))
                    
                    Button(action: {
                        router.navigate(to: .signUp)
                    }){
                        Text(Constants.strings.signUp).padding().frame(maxWidth: .infinity)
                    }
                    .tint(purpleColor)
                    .buttonStyle(.bordered)
                    .font(.system(size: 25))
                }.padding()
                    .navigationBarBackButtonHidden(true)
        }
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        LandingScreen()
//    }
//}

struct LandingPage: View {
    @Environment(\.colorScheme) var colorScheme
    @State var mainAppLink: Bool = false
    @State var isLoading: Bool = true
    @EnvironmentObject var router: Router
    
    func onLoad(){
        isLoading = true
        if let userEmail = Auth.auth().currentUser?.email {
            Utilities().setUserDefaults(for: "userEmail",with: userEmail)
            self.mainAppLink = true
            router.navigate(to: .tabManager)
            print("user")
        }else{
            self.mainAppLink = false
            router.navigate(to: .landingScreen)
            print("no user")
        }
        isLoading = false
    }
    var body: some View {
        ZStack{
            Spacer()
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
            Spacer()
        }.onAppear {onLoad()}
    }
}
