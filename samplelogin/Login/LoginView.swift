//
//  LoginView.swift
//  samplelogin
//
//  Created by Vasisht Chinta on 7/30/23.
//

import SwiftUI
import FirebaseAuth

struct LoginView: View {
    @Binding var currentShowingView: String
    @AppStorage("uid") var userID: String = ""
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var emailVerified: Bool = false
    @State private var showAlert: Bool = false
    @State private var verificationEmailSent = false

    private func isValidPassword(_ password: String) -> Bool {
        let passwordRegex = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])(?=.*[A-Z]).{6,}$")
        
        return passwordRegex.evaluate(with: password)
    }
    
    var body: some View {
        ZStack{
            Color.black.edgesIgnoringSafeArea(.all)
            VStack{
                HStack{
                    Text("Welcome")
//                        .foregroundColor(.black)
                        .font(.largeTitle)
                        .bold()
                    
                    Spacer()
                }
                .padding()
                .padding(.top)
                
                Spacer()
                
                HStack{
                    Image(systemName: "mail")
                    TextField("Email", text: $email)
                    
                    Spacer()
                    
                    if(email.count != 0){
                        Image(systemName: email.isValidEmail() ? "checkmark":"xmark")
                            .fontWeight(.bold)
                            .foregroundColor(email.isValidEmail() ? .green : .red)
                    }
                }
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(lineWidth: 2)
                )
                .padding()
                
                HStack{
                    Image(systemName: "lock")
                    SecureField("Password", text: $password)
                    
                    
                    Spacer()
                    Image(systemName:password.count != 0 ? "checkmark":"xmark")
                        .fontWeight(.bold)
                        .foregroundColor(password.count != 0 ? .green: .red)
                }
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(lineWidth: 2)
                )
                .padding()
                
                
                Button(action: {
                    withAnimation {
                        self.currentShowingView = "signup"
                    }
                    
                }) {
                    Text("Don't have an account? Register")
                        .foregroundColor(.gray.opacity(0.7))
                }
                
                
                Spacer()
                Spacer()
                
                Button {
                        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                            if let error = error {
                                print(error)
                                return
                            }
                            if let authResult = authResult {
                                print(authResult.user.uid)
                                if authResult.user.isEmailVerified {
                                        withAnimation {
                                            userID = authResult.user.uid
                                    }
                                } else{
                                    showAlert = true
                                }
                            }
                        }
                } label: {
                    Text("Sign in")
                        .foregroundColor(.black)
                        .font(.title3)
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.white)
                        )
                        .padding(.horizontal)
                }
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("Email Not Verified"),
                        message: Text("Your email has not been verified. Please check your inbox for the verification link."),
                        primaryButton: .default(Text("OK")),
                        secondaryButton: .default(Text("Resend email")) {
                            Auth.auth().currentUser?.sendEmailVerification{ error in
                                if let error = error {
                                    print(error)
                                } else {
                                    verificationEmailSent = true
                                }
                            }
                        }
                        
                    )
                }
            }
        }
    }
}
