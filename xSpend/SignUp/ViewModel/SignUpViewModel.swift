//
//  SignUpViewModel.swift
//  xSpend
//
//  Created by Mike Paraskevopoulos on 9/6/24.
//

import Foundation
import FirebaseAuth

class SignUpViewModel: ObservableObject {
    @Published var usernameEmail: String = ""
    @Published var password: String = ""
    @Published var password2: String = ""
    @Published var showPassword: Bool = false
    @Published var passwordMatch: Bool = false
    @Published var errorAlert: Bool = false
    @Published var errorAlertMessage: String = ""
    @Published var signupLink: Bool = false

    func signUp(success: @escaping (Bool) -> Void) {
        if passwordMatch {
            Auth.auth().createUser(withEmail: usernameEmail, password: password) { result, error in
                if let error = error {
                    print("an error occured: \(error.localizedDescription)")
                    self.errorAlert = true
                    self.errorAlertMessage = error.localizedDescription
                    success(false)
                }else{
                    success(true)
                }
            }
        }else{
            errorAlert = true
            errorAlertMessage = Constants.strings.passwordsDontMatch
        }
    }
}
