import Foundation

enum AchievementCategory: String, Codable {
    case streak
    case duration
    case consistency
    case quality
    case timeOfDay
    case other
}

struct Achievement: Identifiable, Codable {
    var id = UUID()
    var title: String
    var description: String
    var category: AchievementCategory
    var level: Int
    var isUnlocked: Bool = false
    var progress: Double = 0.0
    var goal: Double
}
