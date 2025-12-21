//
//  AuthViewController.swift
//  Training
//
//  Created by 冨岡獅堂 on 2024/12/18.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore


class AuthViewModel : ObservableObject {
    @Published var isAuthenticated = false
    
    init() {
        Auth.auth().addStateDidChangeListener { [weak self] _, user in
            DispatchQueue.main.async {
                self?.isAuthenticated = user != nil
            }
        }
    }
    
    func signIn(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            DispatchQueue.main.async {
                if result != nil, error == nil {
                    self?.isAuthenticated = true
                }
            }
        }
    }
    
    func signUp(email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            DispatchQueue.main.async {
                if result != nil, error == nil {
                    self?.setupUserData(email: email)
                    self?.isAuthenticated = true
                }
            }
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            isAuthenticated = false
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
    // Firestoreに初期userdataを追加する
    func setupUserData(email: String) {
        if let user = Auth.auth().currentUser {
            //初期登録データ
            let userdata : [String: Any] = [
                "instant_id" : UUID(uuid: UUID().uuid).uuidString,
                "name" : "TestUser",
                "level" : 1,
                "last_login": Timestamp(date:Date()),
                "last_training": "none"
            ]
            
            Task {
                do {
                    try await db.collection("user").document(user.uid).setData(userdata)
                } catch {
                    print("addDataFailed")
                }
            }
        } else {
            return
        }
    }
    
}
