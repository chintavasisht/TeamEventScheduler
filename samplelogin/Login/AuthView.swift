//
//  AuthView.swift
//  samplelogin
//
//  Created by Vasisht Chinta on 7/30/23.
//

import SwiftUI
import FirebaseAuth

struct AuthView: View {
    @State private var currentViewShowing: String = "login"
     
    var body: some View {
        if(currentViewShowing == "login")
        {
            LoginView(currentShowingView: $currentViewShowing)
        }
        else{
            SignUpView(currentShowingView: $currentViewShowing)
                .preferredColorScheme(.dark)
                .transition(.move(edge: .bottom ))
        }
    }
}

struct AuthView_Previews: PreviewProvider {
    static var previews: some View {
        AuthView()
    }
}
