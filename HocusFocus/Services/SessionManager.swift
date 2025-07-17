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
        SupabaseService.fetchSessions { decodableSessions in
            self.sessions = decodableSessions.map {
                Session(id: $0.id, mode: $0.mode, label: $0.label, timestamp: $0.timestamp, duration: $0.duration)
            }
        }
    }
}
