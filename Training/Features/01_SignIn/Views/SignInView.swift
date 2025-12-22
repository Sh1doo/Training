//
//  LoginView.swift
//  Training
//
//  Created by 冨岡獅堂 on 2024/12/18.
//

import SwiftUI
import FirebaseAuth

struct SignInView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @ObservedObject var authViewModel: AuthViewModel
    
    var body: some View {
        if authViewModel.isAuthenticated {
            HomeView()
        } else {
            NavigationView {
                ZStack {
                    VStack {
                        Spacer()
                        Text(AppConfig.Text.signIn)
                            .font(.largeTitle)
                            .fontWeight(.heavy)
                        
                        TextField("E-mail:", text: $email)
                            .keyboardType(.asciiCapable)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)
                        SecureField("Password: ", text: $password)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)
                        
                        if email != "" && password != "" {
                            Button(AppConfig.Text.signIn) {
                                authViewModel.signIn(email: email, password: password)
                            }
                            .modifier(TrainingMenuButtonStyle())
                            .padding()
                        }
                        
                        Spacer()
                        
                        NavigationLink(destination: SignUpView(authViewModel: authViewModel)) {
                            Text(AppConfig.Text.getStarted)
                                .modifier(TrainingMenuButtonStyle())
                                .padding()
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    SignInView(authViewModel: AuthViewModel())
}
