//
//  SignupScreen.swift
//  xSpend
//
//  Created by Mike Paraskevopoulos on 9/7/23.
//

import SwiftUI
import FirebaseAuth

struct SignupScreen: View {
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject private var signUpViewModel = SignUpViewModel()
    @EnvironmentObject var router: Router

    var body: some View {
        VStack{
            Image(Constants.icon.expenses).resizable().frame(width: 200,height: 200)
            Text(Constants.strings.loginTo).font(.system(size: 30)).foregroundColor(colorScheme == .dark ?.white:Constants.colors.purpleColor)
            
            Text(Constants.strings.xSpend).font(.system(size: 35)).foregroundColor(Constants.colors.purpleColor).bold()
            TextField(
                Constants.strings.userNameEmail,
                text: $signUpViewModel.usernameEmail
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
                if signUpViewModel.showPassword {
                    TextField(
                        Constants.strings.password,
                        text: $signUpViewModel.password
                    )
                    .frame(height: 40)
                    .overlay {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(colorScheme == .dark ?.gray:Constants.colors.purpleColor, lineWidth: 2)
                    }
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                    .padding(.bottom)
                }else{
                    SecureField(Constants.strings.password, text: $signUpViewModel.password)
                        .frame(height: 40)
                        .overlay {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(colorScheme == .dark ?.gray:Constants.colors.purpleColor, lineWidth: 2)
                        }
                        .textInputAutocapitalization(.never)
                        .disableAutocorrection(true)
                        .padding(.bottom)
                }
                Button(action: {signUpViewModel.showPassword = !signUpViewModel.showPassword }){
                    Image(systemName: signUpViewModel.showPassword ? Constants.icon.eye:Constants.icon.slashEye).foregroundColor(colorScheme == .dark ?.gray:Constants.colors.purpleColor).font(.system(size: 25))
                }
            }
            HStack{
                SecureField(Constants.strings.confirmPassword, text: $signUpViewModel.password2)
                    .frame(height: 40)
                    .overlay {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(colorScheme == .dark ?.gray:Constants.colors.purpleColor, lineWidth: 2)
                    }
                    .onChange(of: signUpViewModel.password2) { oldValue,newValue in
                        signUpViewModel.passwordMatch = newValue == signUpViewModel.password
                    }
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                Image(systemName: signUpViewModel.passwordMatch ? Constants.icon.ckeckMarkFill:Constants.icon.xMarkFill).foregroundColor(signUpViewModel.passwordMatch ? .green:.red).font(.system(size: 25))
            }.alert(signUpViewModel.errorAlertMessage, isPresented: $signUpViewModel.errorAlert) {
                Button(Constants.strings.ok) {}
            }
            
            
            Button(action: {
                signUpViewModel.signUp{ success in
                    if success { self.router.navigate(to: .tabManager) }
                }
            }){
                Text(Constants.strings.signUp).padding()
            }
            .tint(Constants.colors.purpleColor)
            .buttonStyle(.borderedProminent)
            .font(.system(size: 20))
            .padding(.top,60)
        }.padding()
    }
}

//struct SignupScreen_Previews: PreviewProvider {
//    static var previews: some View {
//        SignupScreen()
//    }
//}
