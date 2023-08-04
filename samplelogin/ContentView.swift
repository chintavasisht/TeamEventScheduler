//
//  ContentView.swift
//  samplelogin
//
//  Created by Vasisht Chinta on 7/30/23.
//

import SwiftUI
import FirebaseAuth

struct ContentView: View {
    
    @AppStorage("uid") var userID: String = ""
    
    var body: some View {
        
        if userID == "" {
            AuthView()
        }
//        else {
//            Text("Logged in!")
//            Button(action: {
//                let firebaseAuth = Auth.auth()
//                do {
//                    try firebaseAuth.signOut()
//                    userID = ""
//                } catch let signOutError as NSError {
//                    print("Error singing out: %@", signOutError)
//                }
//            }) {
//                Text("Sign out")
//            }
//        }
        else {
            ProfileView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
