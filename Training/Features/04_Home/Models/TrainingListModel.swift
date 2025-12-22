//
//  TrainingListModel.swift
//  Training
//
//  Created by 冨岡獅堂 on 2024/12/19.
//

import Foundation
import FirebaseCore
import FirebaseFirestore
import RealmSwift

/// - mark : カレンダー着色用
class TrainingLogRealmObject: Object, ObjectKeyIdentifiable {
    @Persisted var createdAt = Date()
    @Persisted var trainingDate: Date
    @Persisted var trainingData: RealmSwift.List<TrainingRealmObject>
    
    @Persisted var mark: Int
    
    @Persisted var year: Int
    @Persisted var month: Int
    @Persisted var day: Int
    
    required override init() {
        super.init()
    }
    
    // 便利な独自イニシャライザ
    convenience init(trainingDate: Date, trainingData: [TrainingRealmObject], mark: Int) {
        self.init()
        self.trainingDate = trainingDate
        self.trainingData.append(objectsIn: trainingData)
        
        self.mark = mark
        
        self.year = calendar.dateComponents([.year, .month, .day], from: trainingDate).year ?? 2024
        self.month = calendar.dateComponents([.year, .month, .day], from: trainingDate).month ?? 12
        self.day = calendar.dateComponents([.year, .month, .day], from: trainingDate).day ?? 31
    }
}

// トレーニングリスト (トレーニング履歴保存用）
class TrainingRealmObject: Object {
    @Persisted var name: String
    @Persisted var weight: Int
    @Persisted var count: Int
    @Persisted var set: Int
    
    convenience init(name: String, weight: Int, count: Int, set: Int) {
        self.init()
        self.name = name
        self.weight = weight
        self.count = count
        self.set = set
    }
}

// Realmスキーマ
class FavoriteRealmObject: Object, ObjectKeyIdentifiable {
    @Persisted var name: String
    @Persisted var isFavorite = false
    
    required override init() {
        super.init()
    }
    
    convenience init(name: String, isFavorite: Bool) {
        self.init()
        self.name = name
        self.isFavorite = isFavorite
    }
}

struct ListedTraining: Hashable {
    var name: String
    var category: String
    var weight: Int
    var count: Int
    var set: Int
}

struct TrainingMenu: Identifiable, Codable {
    @DocumentID var id: String?
    var favorite: Int
    var name: String
    var category: String
    var pof: String
    var description: String
}

struct LocalizedText: Hashable {
    let english: String
    let japanese: String
}

