import Foundation
import SwiftData

@MainActor
class SessionManager: ObservableObject {
    @Published var sessions: [Session] = []
    private var modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        fetchSessions()
    }
    
    func addSession(mode: String, label: String, duration: TimeInterval) {
        let validModes = ["Focus", "Break", "Hold to Focus", "Read Mode", "Other"]
        let finalMode = validModes.contains(mode) ? mode : "Other"
        
        let session = Session(mode: finalMode, label: label, timestamp: Date(), duration: duration)
        modelContext.insert(session)
        try? modelContext.save()
        fetchSessions()
    }
    
    func fetchSessions() {
        let descriptor = FetchDescriptor<Session>(sortBy: [SortDescriptor(\Session.timestamp, order: .reverse)])
        if let results = try? modelContext.fetch(descriptor) {
            self.sessions = results
        }
    }
    
    func fetchSessionsFromSupabase() {
        
        let localSessions = (try? self.modelContext.fetch(FetchDescriptor<Session>())) ?? []
        
        SupabaseService.fetchSessions { decodableSessions in
            
            let supabaseSessions = decodableSessions.map { decoded in
                Session(
                    id: decoded.id,
                    mode: decoded.mode,
                    label: decoded.label,
                    timestamp: decoded.timestamp,
                    duration: decoded.duration,
                )
            }
            let allSessionsDict = Dictionary(uniqueKeysWithValues:
                                                (localSessions + supabaseSessions).map { ($0.id, $0) }
            )
            let mergedSessions = Array(allSessionsDict.values)
            
            let existingSessions = (try? self.modelContext.fetch(FetchDescriptor<Session>())) ?? []
            existingSessions.forEach { self.modelContext.delete($0) }
            mergedSessions.forEach { self.modelContext.insert($0) }
            try? self.modelContext.save()
            self.fetchSessions()
        }
    }
    
    var totalFocusTime: TimeInterval {
        sessions.reduce(0) { $0 + $1.duration }
    }
    var averageSessionDuration: TimeInterval {
        sessions.isEmpty ? 0 : totalFocusTime / Double(sessions.count)
    }
    var todayFocusTime: TimeInterval {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let sessionsToday = sessions.filter {
            calendar.isDate($0.timestamp, inSameDayAs: today)
            
        }
        return sessionsToday.reduce(0) { $0 + $1.duration }
    }
    func hasStreak(days: Int) -> Bool {
        let calendar = Calendar.current
        let sortedDates = sessions
            .filter { $0.mode == "Focus" || $0.mode == "Read Mode" }
            .map { calendar.startOfDay(for: $0.timestamp) }
            .sorted(by: >)
        
        guard !sortedDates.isEmpty else { return false }
        
        var streak = 1
        var current = sortedDates[0]
        
        for date in sortedDates.dropFirst() {
            let expected = calendar.date(byAdding: .day, value: -1, to: current)!
            if date == expected {
                streak += 1
                current = date
            } else if date < expected {
                break
            }
        }
        
        return streak >= days
    }
    func totalFocusedTime() -> TimeInterval {
        sessions
            .filter { $0.mode == "Focus" || $0.mode == "Read Mode" }
            .reduce(0) { $0 + $1.duration }
    }
    
    func hasReachedGoal() -> Bool {
        return false 
    }
    
    func hasPerfectSession() -> Bool {
        sessions.first(where: { $0.isPerfect && ($0.mode == "Focus" || $0.mode == "Read Mode") }) != nil
    }
    
    func focusedTimeInOneDay() -> TimeInterval {
        let calendar = Calendar.current
        let groupedByDay = Dictionary(grouping: sessions) { calendar.startOfDay(for: $0.timestamp) }
        return groupedByDay.values.map { $0.reduce(0) { $0 + $1.duration } }.max() ?? 0
    }
    
    func hasSessionOnWeekend() -> Bool {
        let calendar = Calendar.current
        return sessions.contains {
            let weekday = calendar.component(.weekday, from: $0.timestamp)
            return weekday == 1 || weekday == 7 // Sunday = 1, Saturday = 7
        }
    }
    
    func hasSessionBefore(hour: Int) -> Bool {
        let calendar = Calendar.current
        return sessions.contains {
            let sessionHour = calendar.component(.hour, from: $0.timestamp)
            return sessionHour < hour
        }
    }
    
    func hasSessionAfter(hour: Int) -> Bool {
        let calendar = Calendar.current
        return sessions.contains {
            let sessionHour = calendar.component(.hour, from: $0.timestamp)
            return sessionHour >= hour
        }
    }
    
    func goalsCompletedInWeek() -> Int {
        return 0 // Replace with actual goal-tracking logic if available
    }
    
    func takesBreaksOnlyAfterSessions() -> Bool {
        return false
    }
    
    func sessionsInDifferentTimeZones(count: Int) -> Bool {
        let timeZones = Set(sessions.compactMap { $0.timeZoneIdentifier })
        return timeZones.count >= count
    }
    
    func hasConsecutiveDistractionFreeSessions(count: Int) -> Bool {
        var current = 0
        for session in sessions where session.isDistractionFree {
            current += 1
            if current >= count {
                return true
            }
        }
        return false
    }
    
    func goalsCompleted() -> Int {
        return 0;
    }
    
    func hasZeroNotificationSession() -> Bool {
        return sessions.first(where: { $0.notificationsReceived == 0 }) != nil
    }
    func movingAverageFitnessScore(windowSize: Int) -> Double {
        guard sessions.count >= windowSize else { return 0 }
        let recentSessions = sessions.prefix(windowSize)

        let scores = recentSessions.map { session -> Double in
            let baseScore = session.duration
            let penalty: Double
            if session.mode == "Read Mode" {
                penalty = 0
            } else {
                penalty = Double(session.distractions + session.notificationsReceived) * 30
            }
            return max(baseScore - penalty, 0)
        }

        return scores.reduce(0, +) / Double(windowSize)
    }
    func longestSessionDuration() -> TimeInterval {
        sessions.map { $0.duration }.max() ?? 0
    }

    func longestStreak() -> Int {
        let calendar = Calendar.current
        let sortedDates = sessions.filter { $0.duration > 0 }.map { calendar.startOfDay(for: $0.timestamp) }.sorted(by: >)

        guard !sortedDates.isEmpty else { return 0 }

        var longest = 1
        var current = 1

        for i in 1..<sortedDates.count {
            let expected = calendar.date(byAdding: .day, value: -1, to: sortedDates[i - 1])!
            if sortedDates[i] == expected {
                current += 1
                if current > longest {
                    longest = current
                }
            } else {
                current = 1
            }
        }
        return longest
    }

    func mostFocusedCategory() -> String? {
        let grouped = Dictionary(grouping: sessions, by: { $0.label ?? "Unknown" })
        let totals = grouped.mapValues { $0.reduce(0) { $0 + $1.duration } }
        return totals.max { $0.value < $1.value }?.key
    }

    func countDistractionFreeSessions() -> Int {
        sessions.filter { $0.isDistractionFree }.count
    }

    func hasWeekendStreak() -> Bool {
        let calendar = Calendar.current
        let groupedByDay = Dictionary(grouping: sessions) { calendar.startOfDay(for: $0.timestamp) }
        for (date, _) in groupedByDay {
            guard let saturday = calendar.date(byAdding: .day, value: -calendar.component(.weekday, from: date) + 7, to: date) else { continue }
            guard let sunday = calendar.date(byAdding: .day, value: 1, to: saturday) else { continue }

            let hasSaturday = groupedByDay[saturday] != nil
            let hasSunday = groupedByDay[sunday] != nil

            if hasSaturday && hasSunday {
                return true
            }
        }
        return false
    }

    func countSessionsAfter(hour: Int) -> Int {
        let calendar = Calendar.current
        return sessions.filter {
            let sessionHour = calendar.component(.hour, from: $0.timestamp)
            return sessionHour >= hour
        }.count
    }

    }
