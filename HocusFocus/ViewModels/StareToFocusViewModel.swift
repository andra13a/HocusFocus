import Foundation
import SwiftUI
import SwiftData

class StareToFocusViewModel: ObservableObject {
    @Published var progress: CGFloat = 0.0
    @Published var completed = false
    @Published var timerText: String = "0s"
    let duration: CGFloat = 10.0
    private var timer: Timer?
    private var secondsElapsed: Int = 0
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

    func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.secondsElapsed += 1
            self.timerText = self.formatTime(self.secondsElapsed)
            self.progress = min(CGFloat(self.secondsElapsed) / self.duration, 1.0)
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

    func stopAndResetTimer() {
        timer?.invalidate()
        timer = nil
        progress = 0.0
        completed = false
        secondsElapsed = 0
        timerText = "0s"
    }

    @MainActor private func saveSession() {
        sessionManager.addSession(mode: "stare", label: "Stare to Focus", duration: TimeInterval(secondsElapsed))
        SupabaseService.uploadSession(mode: "stare", label: "Stare to Focus", timestamp: Date(), duration: TimeInterval(secondsElapsed))
    }

    private func formatTime(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let secs = seconds % 60
        if minutes > 0 {
            return "\(minutes)m:\(String(format: "%02d", secs))s"
        } else {
            return "\(secs)s"
        }
    }
} 
