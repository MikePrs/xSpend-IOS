//
//  Profile.swift
//  xSpend
//
//  Created by Mike Paraskevopoulos on 13/7/23.
//

import SwiftUI
import FirebaseAuth

struct Profile: View {
    @State private var isDarkMode: Bool = false
    @State private var logoutLink: Bool = false
    @State private var currencySelection: String = "Euro"
    
    func signOut(){
        do {
            try Auth.auth().signOut()
            logoutLink.toggle()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
    
    var body: some View {
        NavigationStack {
            Form{
                if let userEmail = Auth.auth().currentUser?.email{
                    HStack {
                        Image(systemName: "person.circle").frame(width: 80,height: 80).font(.system(size: 50))
                        Text(userEmail)
                    }
                    LabeledContent("Username", value: userEmail.components(separatedBy: "@")[0])
                }
                Toggle("Dark Mode", isOn: $isDarkMode)
                Section {
                    Picker("Currency", selection: $currencySelection){
                        Text("Euro")
                        Text("Dollar")
                    }
                } header: {
                    Text("In App Currency")
                }
                Section {
                    Button(role: .destructive) {signOut()} label:{Text("Log Out")}
                }
            }
            .navigationBarTitle("Profile")
            
            .navigationDestination(isPresented: $logoutLink) {
                ContentView()
            }
        }
    }
}

struct Profile_Previews: PreviewProvider {
    static var previews: some View {
        Profile()
    }
}
