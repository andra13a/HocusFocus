import Foundation
import SwiftData

@Model
class Session: Identifiable {
    @Attribute(.unique) var id: UUID
    var mode: String?
    var label: String?
    var timestamp: Date
    var duration: TimeInterval
    
    init(id: UUID = UUID(), mode: String? = nil, label: String? = nil, timestamp: Date, duration: TimeInterval) {
        self.id = id
        self.mode = mode
        self.label = label
        self.timestamp = timestamp
        self.duration = duration
    }
}

struct DecodableSession: Codable, Identifiable {
    let id: UUID
    let mode: String
    let label: String
    let timestamp: Date
    let duration: TimeInterval
}
