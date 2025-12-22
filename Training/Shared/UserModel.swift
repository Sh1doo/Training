//
//  UserModel.swift
//  Training
//
//  Created by 冨岡獅堂 on 2025/01/12.
//

import Foundation
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore

// Firebase Authenticateの UID
var uid: String = ""

// 後にUserのDataを扱う処理は全てこちらに移植
class UserModel: ObservableObject {
    
    init() {
        if let user = Auth.auth().currentUser {
            uid = user.uid
        }
    }
    
    // FireStoreを操作する
    
    // 最後に実行したトレーニングを変更する（Firestore関連）
    func updateLastTraining(name: String) {
        Task {
            let document = db.collection("user").document(uid)
            try await document.updateData([
                "last_training": name
            ])
        }
    }
}
