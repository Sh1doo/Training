import Foundation

enum TrainingName: String, CaseIterable {
    case squat = "Squat"
    case benchPress = "BenchPress"
    case deadlift = "Deadlift"

    var localized: String {
        return String(localized: .init(self.rawValue))
    }
}