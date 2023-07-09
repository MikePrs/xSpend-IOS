//
//  SignupScreen.swift
//  xSpend
//
//  Created by Mike Paraskevopoulos on 9/7/23.
//

import SwiftUI

struct SignupScreen: View {
    let purpleColor = Color(red: 0.37, green: 0.15, blue: 0.80)
    @Environment(\.colorScheme) var colorScheme
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var password2: String = ""
    @State private var showPassword: Bool = false
    @State private var passwordMatch: Bool = false
    

    var body: some View {
        VStack{
            Image("expensesIcon").resizable().frame(width: 200,height: 200)
            Text("Sign up to ").font(.system(size: 30)).foregroundColor(colorScheme == .dark ?.white:purpleColor)
            
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
                    .padding(.bottom)
                }else{
                    SecureField("Password", text: $password)
                        .frame(height: 40)
                        .overlay {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(colorScheme == .dark ?.gray:purpleColor, lineWidth: 2)
                        }
                        .textInputAutocapitalization(.never)
                        .disableAutocorrection(true)
                        .padding(.bottom)
                }
                Button(action: {self.showPassword = !self.showPassword }){
                    Image(systemName: self.showPassword ? "eye":"eye.slash").foregroundColor(colorScheme == .dark ?.gray:purpleColor).font(.system(size: 25))
                }
            }
            HStack{
                SecureField("Confirm Password", text: $password2)
                    .frame(height: 40)
                    .overlay {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(colorScheme == .dark ?.gray:purpleColor, lineWidth: 2)
                    }
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                Image(systemName: self.passwordMatch ? "checkmark.circle.fill":"xmark.circle.fill").foregroundColor(self.passwordMatch ? .green:.red).font(.system(size: 25))
            }
            Button(action: {}){
                Text("Sign Up").padding()
            }
            .tint(purpleColor)
            .buttonStyle(.borderedProminent)
            .font(.system(size: 20))
            .padding(.top,60)
        }.padding()
    }
}

struct SignupScreen_Previews: PreviewProvider {
    static var previews: some View {
        SignupScreen()
    }
}
