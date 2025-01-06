//
//  AuthViewModel.swift
//  xSpend
//
//  Created by Mike Paraskevopoulos on 9/6/24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class LoginViewModel: ObservableObject {
    @Published var usernameEmail: String = ""
    @Published var password: String = ""
    @Published var showPassword: Bool = false
    @Published var errorAlert: Bool = false
    @Published var loginLink: Bool = false
    @Published var errorAlertMessage: String = ""
    
    func login(success: @escaping (Bool) -> Void) {
        Auth.auth().signIn(withEmail: usernameEmail, password: password) { (result, error) in
            if let error = error {
                print(error.localizedDescription)
                self.errorAlert = true
                self.errorAlertMessage = error.localizedDescription
                success(false)
            } else {
                success(true)
            }
        }
    }
    
    func sendPasswordReset(withEmail email: String){
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            self.errorAlert = true
            self.errorAlertMessage = Constants.error.passwordErr
        }
    }
    
    func resetingPassword(){
        if usernameEmail != "" {
            sendPasswordReset(withEmail: usernameEmail)
        }else{
            errorAlert = true
            errorAlertMessage = Constants.error.emailFillErr
        }
    }
}
