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
        let session = Session(mode: mode, label: label, timestamp: Date(), duration: duration)
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
                duration: decoded.duration
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
}
