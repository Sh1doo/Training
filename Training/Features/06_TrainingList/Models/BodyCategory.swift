import Foundation

/// 体の部位カテゴリ
/// - Note: DBのカテゴリ項目と一致させること
enum BodyCategory: String, CaseIterable, Hashable, Codable {
    case upperbody = "upperbody"
    case lowerbody = "lowerbody"
    case chest = "chest"
    case arm = "arm"
    case abs = "abs"
    case shoulder = "shoulder"
    case back = "back"
    case thigh = "thigh"
    case calf = "calf"
    case gluteal = "gluteal"
    case hip = "hip"
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
        case .none: return 99
        }
    }

    static let bigCategories: [BodyCategory] = [.upperbody, .lowerbody]

    static let upperCategories: [BodyCategory] = [.chest, .arm, .abs, .shoulder, .back]
    
    static let lowerCategories: [BodyCategory] = [.thigh, .calf, .gluteal, .hip]
}
