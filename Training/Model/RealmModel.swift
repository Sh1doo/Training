//
//  RealmModel.swift
//  Training
//
//  Created by 冨岡獅堂 on 2024/12/21.
//

import Foundation
import RealmSwift

// Realmをインメモリで開く
let identifier = "MyRealm"
let config = Realm.Configuration(
    // schemaVersion: 1
    inMemoryIdentifier: identifier
)
let realm = try! Realm(configuration: config)
