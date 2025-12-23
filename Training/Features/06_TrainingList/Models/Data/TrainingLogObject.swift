//
//  TrainingLogObject.swift
//  Training
//
//  Created by 冨岡獅堂 on 2025/12/23.
//

import Foundation
import RealmSwift

/// [RealmDB] トレーニングログ
class TrainingLogObject: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var trainingDate: String
    @Persisted var trainingData: RealmSwift.List<TrainingSetObject>
    
    convenience init(trainingDate: String, trainingData: RealmSwift.List<TrainingSetObject>) {
        self.init()
        self.trainingDate = trainingDate
        self.trainingData.append(objectsIn: trainingData)
    }
}

/// 単一トレーニングデータ
class TrainingSetObject: Object {
    @Persisted var name: String
    @Persisted var category: String
    @Persisted var weight: Int
    @Persisted var count: Int
    @Persisted var set: Int
}

extension TrainingSetObject {
    func setup(from trainingSet: TrainingSet) {
        self.name = trainingSet.name.rawValue
        self.category = trainingSet.category.rawValue
        self.weight = trainingSet.weight
        self.count = trainingSet.count
        self.set = trainingSet.set
    }
}
