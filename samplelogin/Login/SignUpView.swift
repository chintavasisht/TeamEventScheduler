//
//  SignUpView.swift
//  samplelogin
//
//  Created by Vasisht Chinta on 7/30/23.
//

import SwiftUI
import FirebaseAuth

struct SignUpView: View {
    @Binding var currentShowingView: String
    @AppStorage("uid") var userID: String = ""
    
    @State private var email: String = ""
    @State private var password: String = "" // 6 characters long
    // 1 uppercase
    // 1 special character
    @State private var isEmailSent: Bool = false
    
    private func isValidPassword(_ password: String) -> Bool {
        let passwordRegex = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])(?=.*[A-Z]).{6,}$")
        
        return passwordRegex.evaluate(with: password)
    }
    
    var body: some View {
        ZStack{
            Color.black.edgesIgnoringSafeArea(.all)
            VStack{
                HStack{
                    Text("Sign up")
                        .foregroundColor(.white)
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
                .foregroundColor(.white)
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(lineWidth: 2)
                        .foregroundColor(.white)
                )
                .padding()
                
                HStack{
                    Image(systemName: "lock")
                    SecureField("Password", text: $password)
                    
                    
                    Spacer()
                    if(password.count != 0){
                        Image(systemName: isValidPassword(password) ? "checkmark":"xmark")
                            .fontWeight(.bold)
                            .foregroundColor(isValidPassword(password) ? .green: .red)
                    }
                }
                .foregroundColor(.white)
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(lineWidth: 2)
                        .foregroundColor(.white)
                )
                .padding()
                
                
                Button(action: {
                    withAnimation {
                        self.currentShowingView = "login"
                    }
                }) {
                    Text("Already have an account? Login")
                        .foregroundColor(.gray)
                }
                
                
                Spacer()
                Spacer()
                
                Button {
                    Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                        if let error = error {
                            print(error)
                            return
                        }
                        if let authResult = authResult {
                            print(authResult)
                            isEmailSent = true
                            
                            authResult.user.sendEmailVerification { error in
                                if error != nil {
                                    print("Error sending email verification");
                                } else {
                                    print("Verification email sent")
                                }
                            }
                        }
                    }
                } label: {
                    Text("Sign up")
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
                        .alert(isPresented: $isEmailSent) {
                            Alert(
                                title: Text("Verify email"),
                                message: Text("An email has been sent for verification. Please check your inbox for the verification link."),
                                primaryButton: .default(Text("Sign in")) {
                                    self.currentShowingView = "login"
                                },
                                secondaryButton: .default(Text("Resend email")) {
                                    Auth.auth().currentUser?.sendEmailVerification{ error in
                                        if let error = error {
                                            print(error)
                                        } else {
                                            isEmailSent = true
                                        }
                                    }
                                }
                            )
                        }
                }
            }
        }
    }
}
