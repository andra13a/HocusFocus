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
    // 1. Fetch local sessions
    let localSessions = (try? self.modelContext.fetch(FetchDescriptor<Session>())) ?? []

    SupabaseService.fetchSessions { decodableSessions in
        // 2. Convert Supabase sessions to local Session objects
        let supabaseSessions = decodableSessions.map { decoded in
            Session(
                id: decoded.id,
                mode: decoded.mode,
                label: decoded.label,
                timestamp: decoded.timestamp,
                duration: decoded.duration
            )
        }

        // 3. Merge, avoiding duplicates (by id)
        let allSessionsDict = Dictionary(uniqueKeysWithValues:
            (localSessions + supabaseSessions).map { ($0.id, $0) }
        )
        let mergedSessions = Array(allSessionsDict.values)

        // 4. Clear local and save merged
        let existingSessions = (try? self.modelContext.fetch(FetchDescriptor<Session>())) ?? []
        existingSessions.forEach { self.modelContext.delete($0) }
        mergedSessions.forEach { self.modelContext.insert($0) }
        try? self.modelContext.save()
        self.fetchSessions()
    }
}

    // Analytics computed properties
    var totalFocusTime: TimeInterval {
        sessions.reduce(0) { $0 + $1.duration }
    }
    var averageSessionDuration: TimeInterval {
        sessions.isEmpty ? 0 : totalFocusTime / Double(sessions.count)
    }
}
