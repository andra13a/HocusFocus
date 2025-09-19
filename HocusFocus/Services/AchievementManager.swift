import Foundation
import SwiftUI

@MainActor
class AchievementManager: ObservableObject {
    @Published var achievements: [Achievement] = []
    @Published var unlockedCount: Int = 0
    private let sessionManager: SessionManager
    
    init(sessionManager: SessionManager) {
        self.sessionManager = sessionManager
        setupAchievements()
    }
    
    private func setupAchievements() {
        achievements = [
            Achievement(
                title: "First Minute",
                description: "Complete a 1 minute focus session",
                category: .duration,
                level: 1,
                isUnlocked: false,
                progress: 0,
                goal: 60
            ),
            Achievement(
                title: "Marathon",
                description: "Complete a 1 hour focus session",
                category: .duration,
                level: 3,
                isUnlocked: false,
                progress: 0,
                goal: 3600
            ),
            Achievement(
                title: "3 Day Streak",
                description: "Focus for 3 consecutive days",
                category: .streak,
                level: 2,
                isUnlocked: false,
                progress: 0,
                goal: 3
            ),
            Achievement(
                title: "7 Day Streak",
                description: "Focus for 7 consecutive days",
                category: .streak,
                level: 3,
                isUnlocked: false,
                progress: 0,
                goal: 7
            ),
            // Quality Achievements
            Achievement(
                title: "Perfect Session",
                description: "Complete a session with zero distractions",
                category: .quality,
                level: 1,
                isUnlocked: false,
                progress: 0,
                goal: 1
            ),
            Achievement(
                title: "Distraction-Free 3x",
                description: "Complete 3 distraction-free sessions in a row",
                category: .quality,
                level: 2,
                isUnlocked: false,
                progress: 0,
                goal: 3
            ),
            Achievement(
                title: "10 Sessions Completed",
                description: "Complete 10 focus sessions",
                category: .consistency,
                level: 1,
                isUnlocked: false,
                progress: 0,
                goal: 10
            ),
            Achievement(
                title: "Early Bird",
                description: "Have a session before 9 AM",
                category: .timeOfDay,
                level: 1,
                isUnlocked: false,
                progress: 0,
                goal: 1
            ),
            Achievement(
                title: "Night Owl",
                description: "Have a session after 10 PM",
                category: .timeOfDay,
                level: 1,
                isUnlocked: false,
                progress: 0,
                goal: 1
            ),
            Achievement(
                title: "Weekend Warrior",
                description: "Focus on a weekend day",
                category: .other,
                level: 1,
                isUnlocked: false,
                progress: 0,
                goal: 1
            ),
            Achievement(
                title: "No Notifications",
                description: "Complete a session without notifications",
                category: .other,
                level: 1,
                isUnlocked: false,
                progress: 0,
                goal: 1
            ),
            Achievement(
                title: "Focus Machine",
                description: "Reach a total of 10 hours focused",
                category: .duration,
                level: 3,
                isUnlocked: false,
                progress: 0,
                goal: 36000 // 10 hours
            ),
            Achievement(
                title: "Most Productive Day",
                description: "Focus more than 4 hours in a single day",
                category: .duration,
                level: 3,
                isUnlocked: false,
                progress: 0,
                goal: 14400
            ),
            Achievement(
                title: "Time Traveler",
                description: "Have sessions in 3 different time zones",
                category: .other,
                level: 2,
                isUnlocked: false,
                progress: 0,
                goal: 3
            ),
            // New Achievements
            Achievement(
                title: "Half Marathon",
                description: "Complete a 30 minute focus session",
                category: .duration,
                level: 2,
                isUnlocked: false,
                progress: 0,
                goal: 1800 // 30 minutes
            ),
            Achievement(
                title: "Century Club",
                description: "Complete 100 focus sessions",
                category: .consistency,
                level: 3,
                isUnlocked: false,
                progress: 0,
                goal: 100
            ),
            Achievement(
                title: "5 Day Streak",
                description: "Focus for 5 consecutive days",
                category: .streak,
                level: 2,
                isUnlocked: false,
                progress: 0,
                goal: 5
            ),
            Achievement(
                title: "Night Owl Pro",
                description: "Have a session after midnight",
                category: .timeOfDay,
                level: 2,
                isUnlocked: false,
                progress: 0,
                goal: 1
            ),
            Achievement(
                title: "Distracted No More",
                description: "Complete 10 distraction-free sessions",
                category: .quality,
                level: 3,
                isUnlocked: false,
                progress: 0,
                goal: 10
            ),
            Achievement(
                title: "Early Riser",
                description: "Have a session before 6 AM",
                category: .timeOfDay,
                level: 2,
                isUnlocked: false,
                progress: 0,
                goal: 1
            ),
            Achievement(
                title: "Weekend Streak",
                description: "Focus on both Saturday and Sunday in the same weekend",
                category: .other,
                level: 2,
                isUnlocked: false,
                progress: 0,
                goal: 2
            ),
            Achievement(
                title: "Night Marathon",
                description: "Complete 3 sessions after 10 PM",
                category: .timeOfDay,
                level: 3,
                isUnlocked: false,
                progress: 0,
                goal: 3
            ),
            Achievement(
                title: "Focus Guru",
                description: "Reach 50 total hours focused",
                category: .duration,
                level: 4,
                isUnlocked: false,
                progress: 0,
                goal: 180000
            )
        ]
    }
    
    func checkAchievements() async {
        for i in achievements.indices {
            var achievement = achievements[i]
            
            switch achievement.title {
            case "First Minute":
                let maxDuration = sessionManager.sessions.map { $0.duration }.max() ?? 0
                achievement.progress = min(maxDuration / achievement.goal, 1)

            case "Marathon":
                let maxDuration = sessionManager.sessions.map { $0.duration }.max() ?? 0
                achievement.progress = min(maxDuration / achievement.goal, 1)
                
            case "3 Day Streak":
                achievement.progress = sessionManager.hasStreak(days: 3) ? 1 : 0
                
            case "7 Day Streak":
                achievement.progress = sessionManager.hasStreak(days: 7) ? 1 : 0
                
            case "Perfect Session":
                achievement.progress = sessionManager.hasPerfectSession() ? 1 : 0
                
            case "Distraction-Free 3x":
                achievement.progress = sessionManager.hasConsecutiveDistractionFreeSessions(count: 3) ? 1 : 0
                
            case "10 Sessions Completed":
                let completed = sessionManager.sessions.count
                achievement.progress = min(Double(completed) / achievement.goal, 1)
                
            case "Early Bird":
                achievement.progress = sessionManager.hasSessionBefore(hour: 9) ? 1 : 0
                
            case "Night Owl":
                achievement.progress = sessionManager.hasSessionAfter(hour: 22) ? 1 : 0
                
            case "Weekend Warrior":
                achievement.progress = sessionManager.hasSessionOnWeekend() ? 1 : 0
                
            case "No Notifications":
                achievement.progress = sessionManager.hasZeroNotificationSession() ? 1 : 0
                
            case "Focus Machine":
                let total = sessionManager.totalFocusedTime()
                achievement.progress = min(total / achievement.goal, 1)

            case "Most Productive Day":
                let maxDay = sessionManager.focusedTimeInOneDay()
                achievement.progress = min(maxDay / achievement.goal, 1)

            case "Time Traveler":
                let unlocked = sessionManager.sessionsInDifferentTimeZones(count: Int(achievement.goal))
                achievement.progress = unlocked ? 1 : 0
                
            case "Half Marathon":
                let maxDurationHalf = sessionManager.sessions.map { $0.duration }.max() ?? 0
                achievement.progress = min(maxDurationHalf / achievement.goal, 1)

            case "Century Club":
                let completedCount = sessionManager.sessions.count
                achievement.progress = min(Double(completedCount) / achievement.goal, 1)

            case "5 Day Streak":
                achievement.progress = sessionManager.hasStreak(days: 5) ? 1 : 0

            case "Night Owl Pro":
                achievement.progress = sessionManager.hasSessionAfter(hour: 0) ? 1 : 0

            case "Distracted No More":
                let countDistractedFree = sessionManager.countDistractionFreeSessions()
                achievement.progress = min(Double(countDistractedFree) / achievement.goal, 1)

            case "Early Riser":
                achievement.progress = sessionManager.hasSessionBefore(hour: 6) ? 1 : 0

            case "Weekend Streak":
                achievement.progress = sessionManager.hasWeekendStreak() ? 1 : 0

            case "Night Marathon":
                let nightSessions = sessionManager.countSessionsAfter(hour: 22)
                achievement.progress = min(Double(nightSessions) / achievement.goal, 1)

            case "Focus Guru":
                let totalFocus = sessionManager.totalFocusedTime()
                achievement.progress = min(totalFocus / achievement.goal, 1)
                
            default:
                achievement.progress = 0
            }
            
            if achievement.progress >= 1 && !achievement.isUnlocked {
                achievements[i].isUnlocked = true
            } else {
                achievements[i].progress = achievement.progress
            }
        }
        updateUnlockedCount()
    }
    
    func updateUnlockedCount() {
        unlockedCount = achievements.filter { $0.isUnlocked }.count
    }
}
