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
    var category: TrainingCategory
    var weight: Int
    var count: Int
    var set: Int
}