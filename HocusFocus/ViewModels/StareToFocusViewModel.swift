import Foundation
import SwiftUI
import SwiftData

class StareToFocusViewModel: ObservableObject {
    @Published var progress: CGFloat = 0.0
    @Published var completed = false
    let duration: CGFloat = 10.0
    private var timer: Timer?
    private var modelContext: ModelContext
    private let sessionManager: SessionManager
    init(modelContext: ModelContext, sessionManager: SessionManager) {
        self.modelContext = modelContext
        self.sessionManager = sessionManager
    }

    func onLookingChanged(_ isLooking: Bool) {
        if isLooking {
            startTimer()
        } else {
            stopAndResetTimer()
        }
    }

    private func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.02, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.progress += 0.02 / self.duration
            if self.progress >= 1.0 {
                self.progress = 1.0
                self.completed = true
                self.timer?.invalidate()
                Task { @MainActor in
                    self.saveSession()
                }
            }
        }
    }

    private func stopAndResetTimer() {
        timer?.invalidate()
        timer = nil
        progress = 0.0
        completed = false
    }

    @MainActor private func saveSession() {
    sessionManager.addSession(mode: "stare", label: "Stare to Focus", duration: TimeInterval(duration))
        SupabaseService.uploadSession(mode: "stare", label: "Stare to Focus", timestamp: Date(), duration: TimeInterval(duration))
    
    }
} 
