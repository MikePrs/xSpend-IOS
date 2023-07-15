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
    @State private var usernameEmail: String = ""
    @State private var password: String = ""
    @State private var showPassword: Bool = false
    @State private var errorAlert: Bool = false
    @State private var loginLink: Bool = false
    @State private var errorAlertMessage: String = ""
    
    let purpleColor = Color(red: 0.37, green: 0.15, blue: 0.80)
    
    func login() {
        Auth.auth().signIn(withEmail: usernameEmail, password: password) { (result, error) in
            if let error = error {
                print(error.localizedDescription)
                errorAlert = true
                errorAlertMessage = error.localizedDescription
            } else {
                loginLink.toggle()
            }
        }
    }
    
    func sendPasswordReset(withEmail email: String){
        Auth.auth().sendPasswordReset(withEmail: email) { error in
                print("password change err")
                errorAlert = true
                errorAlertMessage = "Password change erros"
        }
    }
    
    func resetingPassword(){
        if usernameEmail != "" {
            sendPasswordReset(withEmail: usernameEmail)
        }else{
            print("fill email first")
            errorAlert = true
            errorAlertMessage = "Fill email first"
        }
    }
    
    var body: some View {
        VStack{
            NavigationStack {
                VStack{
                    VStack{
                        Image("expensesIcon").resizable().frame(width: 200,height: 200)
                        Text("Login to ").font(.system(size: 30)).foregroundColor(colorScheme == .dark ?.white:purpleColor)
                        
                        Text("xSpend").font(.system(size: 35)).foregroundColor(purpleColor).bold()
                        TextField(
                            "User name (email address)",
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
                        .alert(errorAlertMessage, isPresented: $errorAlert) {
                            Button("Ok") {}
                        }
                    HStack{
                        Spacer()
                        Button(role: .destructive , action: {resetingPassword()}){
                            Text("Forgot passwort")
                        }.frame(alignment: .trailing).padding()
                    }
                    Button(action: {login()}){
                        Text("Login").padding()
                    }
                    .tint(purpleColor)
                    .buttonStyle(.borderedProminent)
                    .font(.system(size: 20))
                    .padding(.top)
                }
                .navigationDestination(isPresented: $loginLink) {
                    TabManager()
                }
            }
        }
    }
}

struct LoginScreen_Previews: PreviewProvider {
    static var previews: some View {
        LoginScreen()
    }
}
