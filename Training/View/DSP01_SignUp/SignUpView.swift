//
//  SignUpView.swift
//  Training
//
//  Created by 冨岡獅堂 on 2024/12/18.
//

import SwiftUI

struct SignUpView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @ObservedObject var authViewModel: AuthViewModel
    
    var body: some View {
        if authViewModel.isAuthenticated {
            ContentView()
        } else {
            ZStack {
                //背景
                
                VStack {
                    Spacer()
                    Text("新規登録")
                        .font(.largeTitle)
                        .fontWeight(.heavy)
                    
                    TextField("E-mail:", text: $email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                    SecureField("Password: ", text: $password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                    
                    if email != "" && password != "" {
                        Button("Sign Up") {
                            authViewModel.signUp(email: email, password: password)
                        }
                        .trainingMenuButtonStyle()
                        .padding()
                    }
                    Spacer()
                }
            }
        }
    }
}
