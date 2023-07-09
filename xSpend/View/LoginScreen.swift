//
//  LoginScreen.swift
//  xSpend
//
//  Created by Mike Paraskevopoulos on 9/7/23.
//

import SwiftUI

struct LoginScreen: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var showPassword: Bool = false
    
    let purpleColor = Color(red: 0.37, green: 0.15, blue: 0.80)
    
    var body: some View {
        VStack{
            VStack{
                Image("expensesIcon").resizable().frame(width: 200,height: 200)
                Text("Login to ").font(.system(size: 30)).foregroundColor(colorScheme == .dark ?.white:purpleColor)
                
                Text("xSpend").font(.system(size: 35)).foregroundColor(purpleColor).bold()
                TextField(
                    "User name (email address)",
                    text: $username
                ).frame(height: 40)
                    .overlay {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(colorScheme == .dark ?.gray:purpleColor, lineWidth: 2)
                    }
                    .foregroundColor(.white)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                    .frame(height: 40)
                    .padding(.bottom)
                
                HStack{
                    if showPassword {
                        TextField(
                            "Password",
                            text: $password
                        )
                        .frame(height: 40)
                        .overlay {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(colorScheme == .dark ?.gray:purpleColor, lineWidth: 2)
                        }
                        .textInputAutocapitalization(.never)
                        .disableAutocorrection(true)
                    }else{
                        SecureField("Password", text: $password)
                            .frame(height: 40)
                            .overlay {
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(colorScheme == .dark ?.gray:purpleColor, lineWidth: 2)
                            }
                            .textInputAutocapitalization(.never)
                            .disableAutocorrection(true)
                    }
                    Button(action: {self.showPassword = !self.showPassword }){
                        Image(systemName: self.showPassword ? "eye":"eye.slash").foregroundColor(colorScheme == .dark ?.gray:purpleColor).font(.system(size: 25))
                    }
                }
            }.padding()
            HStack{
                Spacer()
                Button(role: .destructive , action: {}){
                    Text("Forgot passwort")
                }.frame(alignment: .trailing).padding()
            }
            Button(action: {}){
                Text("Login").padding()
            }
            .tint(purpleColor)
            .buttonStyle(.borderedProminent)
            .font(.system(size: 20))
            .padding(.top)
        }
    }
}

struct LoginScreen_Previews: PreviewProvider {
    static var previews: some View {
        LoginScreen()
    }
}
