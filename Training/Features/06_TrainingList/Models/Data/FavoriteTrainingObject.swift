//
//  FavoriteTrainingObject.swift
//  Training
//
//  Created by 冨岡獅堂 on 2025/12/23.
//

import Foundation
import RealmSwift

// RealmDB[] お気に入りトレーニングメニュー
class FavoriteTrainingObject: Object, ObjectKeyIdentifiable {
    @Persisted var name: String
    @Persisted var isFavorite = false
}
