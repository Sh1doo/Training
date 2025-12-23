import Foundation

enum BodyCategory: String, CaseIterable, Identifiable {
    case upperbody = AppConfig.Text.upperBody
    case lowerbody = AppConfig.Text.lowerBody
    case chest = AppConfig.Text.chest
    case arm = AppConfig.Text.arm
    case abs = AppConfig.Text.abs
    case shoulder = AppConfig.Text.shoulder
    case back = AppConfig.Text.back
    case thigh = AppConfig.Text.thigh
    case calf = AppConfig.Text.calf
    case gluteal = AppConfig.Text.gluteal
    case hip = AppConfig.Text.hip
    case none = AppConfig.Text.none

    var id: Self { self }
    
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
