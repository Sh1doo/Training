//
//  CategoryTag.swift
//  Training
//
//  Created by 冨岡獅堂 on 2025/12/30.
//


import Foundation

/// タグのカテゴリ一覧
/// - Note: DBのカテゴリ項目と一致させること
enum CategoryTag: String, CaseIterable, Hashable, Codable {
    case upperbody = "upperbody"        // 上半身
    case lowerbody = "lowerbody"        // 下半身
    case chest = "chest"                // 胸
    case arm = "arm"                    // 腕
    case abs = "abs"                    // 腹
    case shoulder = "shoulder"          // 肩
    case back = "back"                  // 背中
    case thigh = "thigh"                // 大腿
    case calf = "calf"                  // ふくらはぎ
    case gluteal = "gluteal"            // 臀部
    case hip = "hip"                    // 腰
    case midrange = "midrange"          // ミッドレンジ種目
    case stretch = "stretch"            // ストレッチ種目
    case contracted = "contracted"      // コントラクト種目
    case bodyweight = "bodyweight"      // 自重
    case dumbbell = "dumbbell"          // ダンベル
    case barbell = "barbell"            // バーベル
    case machine = "machine"            // マシン
    case cable = "cable"                // ケーブル
    case powerrack = "powerrack"        // パワーラック
    case smithmachine = "smithmachine"  // スミスマシン
    case ezbar = "ezbar"                // EZバー
    case bench = "bench"                // ベンチ
    case beginner = "beginner"          // 初心者向け
    case athome = "athome"              // 自宅でできる
    case none = "none"
    
    var localized: String {
        return String(localized: .init(self.rawValue))
    }
    
    var sortOrder: Int {
        switch self {
        case .upperbody: return 0
        case .lowerbody: return 1
        case .chest: return 2
        case .arm: return 3
        case .abs: return 4
        case .shoulder: return 5
        case .back: return 6
        case .thigh: return 7
        case .calf: return 8
        case .gluteal: return 9
        case .hip: return 10
        case .midrange: return 11
        case .stretch: return 12
        case .contracted: return 13
        case .bodyweight: return 14
        case .dumbbell: return 15
        case .barbell: return 16
        case .machine: return 17
        case .cable: return 18
        case .powerrack: return 19
        case .smithmachine: return 20
        case .ezbar: return 21
        case .bench: return 22
        case .beginner: return 23
        case .athome: return 24
        case .none: return 99
        }
    }
    
    static let bigCategories: [CategoryTag] = [.upperbody, .lowerbody]
    
    static let upperCategories: [CategoryTag] = [.chest, .arm, .abs, .shoulder, .back]
    
    static let lowerCategories: [CategoryTag] = [.thigh, .calf, .gluteal, .hip]
    
    static let pofCategories: [CategoryTag] = [.midrange, .stretch, .contracted]
    
    static let equipmentCategories: [CategoryTag] = [.bodyweight, .dumbbell, .barbell, .machine, .cable, .powerrack, .smithmachine, .ezbar, .bench]
    
    static let specialCategories: [CategoryTag] = [.beginner, .athome]
    
}
