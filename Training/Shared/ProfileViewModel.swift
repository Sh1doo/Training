//
//  ProfileViewModel.swift
//  Training
//
//  Created by 冨岡獅堂 on 2025/01/12.
//

import Foundation
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore

struct UserData: Identifiable, Codable {
    @DocumentID var id: String?
    var instant_id: String
    var name: String
    var level: Int
    var last_login: Date
    var last_training: String
}

class ProfileViewModel: ObservableObject {
    @Published var userdata: UserData = UserData(instant_id: "none", name: "unknown", level: 0, last_login: Date(), last_training: "none")
    
    private var user: User?
    
    // 初期化時にUIDを取得しておく
    init() {
        if let user = Auth.auth().currentUser {
            self.user = user
            ChangeDisplayName()
        }
    }
    
    // 表示用の変数に変更を加える
    func ChangeDisplayName() {
        Task {
            let document = db.collection("user").document(uid)
            print(uid)
            if let data = try? await document.getDocument().data(as: UserData.self) {
                DispatchQueue.main.async {
                    self.userdata = data
                }
            } else {
                DispatchQueue.main.async {
                    self.userdata = UserData(instant_id: "none", name: "fetch error", level: 0, last_login: Date(), last_training: "fetch error")
                }
            }
        }
    }
    
    // e-mailの更新用メールを送信する
    func updateEmail() {
        if let email = user?.email {
            user?.sendEmailVerification(beforeUpdatingEmail: email)
        } else {
            print("error email is not registerd")
        }
    }
    
    // パスワードの更新
    func updatePassword(password: String) {
        user?.updatePassword(to: password) { error in
            return
        }
    }
    
    // userの削除
    func deleteUser(){
        user?.delete { error in
            if let error = error {
                print("delete error \(error)")
            }
        }
    }
    
    // ユーザデータの更新 (Firestore)
    func updateUserData(name: String, instantId: String) {
        
        var afterName = name
        var afterId = instantId
        
        // nameが空
        if name == "" {
            afterName = userdata.name
        }
        
        // idが空
        if instantId == "" {
            afterId = userdata.instant_id
        }
        
        // idもしくは、nameが変更前と異なる場合
        if afterName != userdata.name || afterName != userdata.instant_id {
            Task {
                let document = db.collection("user").document(uid)
                try await document.updateData([
                    "instant_id": afterId,
                    "name": afterName
                ])
            }
            ChangeDisplayName()
        }
    }
    
    
    
    //Getter
    func getEmail() -> String {
        return user?.email ?? "not authenticated"
    }
    
    func getLastLogin() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        return dateFormatter.string(from: userdata.last_login)
    }
}
