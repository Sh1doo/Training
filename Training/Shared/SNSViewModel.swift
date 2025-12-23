//
//  SNSViewModel.swift
//  Training
//
//  Created by 冨岡獅堂 on 2025/01/12.
//

import Foundation
import RealmSwift
import FirebaseCore
import FirebaseFirestore

// Realmスキーマ
class FriendRealm: Object, ObjectKeyIdentifiable {
    @Persisted var uid: String
    @Persisted var startFriendDate = Date()
    @Persisted var favorite = false
    
    required override init() {
        super.init()
    }
    
    convenience init(uid: String) {
        self.init()
        self.uid = uid
    }
}

struct Friend: Hashable {
    var uid: String
    var name: String
    var level: Int
    var lastLogin: Date
    var lastTraining: String
}

class SNSViewModel: ObservableObject {
    @Published var friends: [Friend] = [
        Friend(uid: "", name: "sample", level: 1, lastLogin: Date(), lastTraining: "ベンチプレス"),
        Friend(uid: "", name: "アイウエオ", level: 1, lastLogin: Date(), lastTraining: "ベンチプレス")
    ]
    
    private var realm: Realm {
        return RealmConfig.shared.realm
    }
    
    init() {
        updateFriendList()
    }
    
    // フレンド追加
    func addFriend(id: String) {
        if id == "" {
            return
        }
        
        if  realm.objects(FriendRealm.self).where({$0.uid == id}).first != nil {
            //すでに追加されている
            print("already added")
        } else {
            try! realm.write {
                // [FindHere]
                // 実際にあるかどうかの判別が必須（なければゴミデータが溜まっていく）
                let realmObject = FriendRealm(uid: id)
                realm.add(realmObject)
            }
        }
        updateFriendList()
    }
    
    // フレンドリストの更新
    func updateFriendList() {
        friends = []
        
        var uidList: [String] = []
        for friend in realm.objects(FriendRealm.self) {
            uidList.append(friend.uid)
        }
        
        for uid in uidList {
            Task{
                let document = db.collection("user").document(uid)
                if let data = try await document.getDocument().data() {
                    let last_login = data["last_login"] as! Timestamp
                    let newFriend = Friend(uid: uid, name: data["name"] as! String, level: data["level"] as! Int, lastLogin: last_login.dateValue(), lastTraining: data["last_training"] as! String)
                    friends.append(newFriend)
                }
            }
        }
    }
    
    func getFormattedDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        return dateFormatter.string(from: date)
    }
}
