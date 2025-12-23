//
//  TrainingMenu.swift
//  Training
//
//  Created by 冨岡獅堂 on 2024/12/23.
//

import Foundation
import FirebaseCore
import FirebaseFirestore

/// DB[training-menu]スキーマ
struct TrainingMenu: Identifiable, Codable {
    @DocumentID var id: String?
    var favorite: Int
    var name: TrainingName
    var category: BodyCategory
    var pof: String
    var description: String
}
