//
//  ColorModel.swift
//  Training
//
//  Created by 冨岡獅堂 on 2025/01/23.
//

import Foundation
import SwiftUI

// カレンダーのカテゴリごとの色
enum CalendarColors {
    static let chest = Color.blue
    static let arm = Color.green
}

class ColorModel : ObservableObject {
    func numberToColor(number: Int) -> Color {
        switch number {
        case 0: return CalendarColors.chest
        case 1: return CalendarColors.arm
        default: return Color.white
        }
    }
}

/*
 enum CalendarMark {
 case chest
 case arm
 case abs
 case shoulder
 case back
 case thigh
 case calf
 case gluteal
 case hip
 
 var color: Color {
 switch self {
 case .chest:
 return .blue
 case .arm:
 return .blue
 case .abs:
 return .blue
 case .shoulder:
 return .blue
 case .back:
 return .green
 case .thigh:
 return .green
 case .calf:
 return .green
 case .gluteal:
 return .green
 case .hip:
 return .green
 }
 }
 }
 */
