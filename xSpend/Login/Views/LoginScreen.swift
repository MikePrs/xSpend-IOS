//
//  LoginScreen.swift
//  xSpend
//
//  Created by Mike Paraskevopoulos on 9/7/23.
//

import SwiftUI
import FirebaseAuth

struct LoginScreen: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var router: Router
    @ObservedObject private var loginViewModel = LoginViewModel()
    
    var body: some View {
        VStack{
            VStack{
                VStack{
                    Image(Constants.icon.expenses).resizable().frame(width: 200,height: 200)
                    Text(Constants.strings.loginTo).font(.system(size: 30)).foregroundColor(colorScheme == .dark ?.white:Constants.colors.purpleColor)
                    
                    Text(Constants.strings.xSpend).font(.system(size: 35)).foregroundColor(Constants.colors.purpleColor).bold()
                    TextField(
                        Constants.strings.userNameEmail,
                        text: $loginViewModel.usernameEmail
                    ).frame(height: 40)
                        .overlay {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(colorScheme == .dark ?.gray:Constants.colors.purpleColor, lineWidth: 2)
                        }
                        .foregroundColor(colorScheme == .dark ? .white : .black)
                        .textInputAutocapitalization(.never)
                        .disableAutocorrection(true)
                        .frame(height: 40)
                        .padding(.bottom)
                    
                    HStack{
                        if loginViewModel.showPassword {
                            TextField(
                                Constants.strings.password,
                                text: $loginViewModel.password
                            )
                            .frame(height: 40)
                            .overlay {
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(colorScheme == .dark ?.gray:Constants.colors.purpleColor, lineWidth: 2)
                            }
                            .textInputAutocapitalization(.never)
                            .disableAutocorrection(true)
                        }else{
                            SecureField(Constants.strings.password, text: $loginViewModel.password)
                                .frame(height: 40)
                                .overlay {
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(colorScheme == .dark ?.gray:Constants.colors.purpleColor, lineWidth: 2)
                                }
                                .textInputAutocapitalization(.never)
                                .disableAutocorrection(true)
                        }
                        Button(action: {loginViewModel.showPassword = !loginViewModel.showPassword }){
                            Image(systemName: loginViewModel.showPassword ? Constants.icon.eye:Constants.icon.slashEye).foregroundColor(colorScheme == .dark ?.gray:Constants.colors.purpleColor).font(.system(size: 25))
                        }
                    }
                }.padding()
                    .alert(loginViewModel.errorAlertMessage, isPresented: $loginViewModel.errorAlert) {
                        Button(Constants.strings.ok) {}
                    }
                HStack{
                    Spacer()
                    Button(role: .destructive , action: {loginViewModel.resetingPassword()}){
                        Text(Constants.strings.forgotPassword)
                    }.frame(alignment: .trailing).padding()
                }
                Button(action: {
                    loginViewModel.login { success in
                        if success { router.navigate(to: .tabManager) }
                    }
                }){
                    Text(Constants.strings.login).padding()
                }
                .tint(Constants.colors.purpleColor)
                .buttonStyle(.borderedProminent)
                .font(.system(size: 20))
                .padding(.top)
            }

        }
    }
}
