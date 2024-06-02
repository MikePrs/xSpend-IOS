//
//  SignupScreen.swift
//  xSpend
//
//  Created by Mike Paraskevopoulos on 9/7/23.
//

import SwiftUI
import FirebaseAuth
import ToastViewSwift

struct SignupScreen: View {
    let purpleColor = Color(red: 0.37, green: 0.15, blue: 0.80)
    @Environment(\.colorScheme) var colorScheme
    @State private var usernameEmail: String = ""
    @State private var password: String = ""
    @State private var password2: String = ""
    @State private var showPassword: Bool = false
    @State private var passwordMatch: Bool = false
    @State private var errorAlert: Bool = false
    @State private var errorAlertMessage: String = ""
    @State private var signupLink: Bool = false

    func signUp() {
        if passwordMatch {
            Auth.auth().createUser(withEmail: usernameEmail, password: password) { result, error in
                if let error = error {
                    print("an error occured: \(error.localizedDescription)")
                    errorAlert = true
                    errorAlertMessage = error.localizedDescription
                    return
                }else{
                    signupLink.toggle()
                }
            }
        }else{
            errorAlert = true
            errorAlertMessage = Constants.strings.passwordsDontMatch
        }
    }

    var body: some View {
        NavigationStack {
            VStack{
                Image(Constants.icon.expenses).resizable().frame(width: 200,height: 200)
                Text(Constants.strings.loginTo).font(.system(size: 30)).foregroundColor(colorScheme == .dark ?.white:purpleColor)
                
                Text(Constants.strings.xSpend).font(.system(size: 35)).foregroundColor(purpleColor).bold()
                TextField(
                    Constants.strings.userNameEmail,
                    text: $usernameEmail
                ).frame(height: 40)
                    .overlay {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(colorScheme == .dark ?.gray:purpleColor, lineWidth: 2)
                    }
                    .foregroundColor(colorScheme == .dark ? .white : .black)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                    .frame(height: 40)
                    .padding(.bottom)
                
                HStack{
                    if showPassword {
                        TextField(
                            Constants.strings.password,
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
                        SecureField(Constants.strings.password, text: $password)
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
                        Image(systemName: self.showPassword ? Constants.icon.eye:Constants.icon.slashEye).foregroundColor(colorScheme == .dark ?.gray:purpleColor).font(.system(size: 25))
                    }
                }
                HStack{
                    SecureField(Constants.strings.confirmPassword, text: $password2)
                        .frame(height: 40)
                        .overlay {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(colorScheme == .dark ?.gray:purpleColor, lineWidth: 2)
                        }
                        .onChange(of: password2) { newValue in
                            self.passwordMatch = newValue == self.password
                        }
                        .textInputAutocapitalization(.never)
                        .disableAutocorrection(true)
                    Image(systemName: self.passwordMatch ? Constants.icon.ckeckMarkFill:Constants.icon.xMarkFill).foregroundColor(self.passwordMatch ? .green:.red).font(.system(size: 25))
                }.alert(errorAlertMessage, isPresented: $errorAlert) {
                    Button(Constants.strings.ok) {}
                }
                
                
                Button(action: {signUp()}){
                    Text(Constants.strings.signUp).padding()
                }
                .tint(purpleColor)
                .buttonStyle(.borderedProminent)
                .font(.system(size: 20))
                .padding(.top,60)
            }.padding()
            .navigationDestination(isPresented: $signupLink) {
                TabManager()
              }
        }
    }
}

struct SignupScreen_Previews: PreviewProvider {
    static var previews: some View {
        SignupScreen()
    }
}
