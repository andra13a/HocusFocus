import Foundation

enum RewardType: String, Codable {
    case theme
    case sound
}

struct Reward: Identifiable, Codable {
    var id = UUID()
    var name: String
    var type: RewardType
    var isUnlocked: Bool = false
    var associatedAchievementId: UUID
}
