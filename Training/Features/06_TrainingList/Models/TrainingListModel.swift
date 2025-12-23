//
//  TrainingListModel.swift
//  Training
//
//  Created by 冨岡獅堂 on 2024/12/23.
//

import Foundation
import FirebaseCore
import FirebaseFirestore
import RealmSwift

/// 単一トレーニングデータ
struct TrainingSet: Hashable {
    var name: TrainingName
    var category: BodyCategory
    var weight: Int
    var count: Int
    var set: Int
}

extension TrainingSet {
    /// TrainingSetObjectから初期化
    init(from object: TrainingSetObject) {
        self.name = TrainingName(rawValue: object.name) ?? TrainingName.benchPress
        self.category = BodyCategory(rawValue: object.category) ?? BodyCategory.chest
        self.weight = object.weight
        self.count = object.count
        self.set = object.set
    }
}
