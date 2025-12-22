import SwiftUI

/// UIデザインに関する共通設定
extension AppConfig {
    enum UI {
        static let cornerRadius: CGFloat = 12.0

        enum Color {
            static let errorRed = SwiftUI.Color.red
        }
    }
}
