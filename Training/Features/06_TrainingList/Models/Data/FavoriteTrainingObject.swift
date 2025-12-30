//
//  FavoriteTrainingObject.swift
//  Training
//
//  Created by 冨岡獅堂 on 2025/12/23.
//

import Foundation
import RealmSwift

/// お気に入りトレーニング
class FavoriteTrainingObject: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var name: String
    @Persisted var isFavorite = false
    
    convenience init(name: String, isFavorite: Bool) {
        self.init()
        self.name = name
        self.isFavorite = isFavorite
    }
}
