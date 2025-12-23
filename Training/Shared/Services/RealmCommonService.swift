//
//  RealmCommonService.swift
//  Training
//
//  Created by 冨岡獅堂 on 2024/12/21.
//

import Foundation
import RealmSwift

@MainActor
struct RealmConfig {
    static let shared = RealmConfig()
    
    let realm: Realm
    
    private init() {
        let identifier = "MyRealm"
        let config = Realm.Configuration(
            inMemoryIdentifier: identifier,
            schemaVersion: 1
        )
        
        do {
            self.realm = try Realm(configuration: config)
        } catch {
            fatalError("realm init failed: \(error)")
        }
    }
}