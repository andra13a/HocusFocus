import Foundation
import SwiftUI
import SwiftData

class HoldToFocusTimerViewModel: ObservableObject {
    @Published var progress: CGFloat = 0.0
    @Published var isHolding = false
    private var timer: Timer?
    let duration: CGFloat = 10.0 // seconds for full circle

    private var modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func startHolding() {
        if !isHolding {
            isHolding = true
            startTimer()
        }
    }

    func stopHolding() {
        isHolding = false
        stopAndResetTimer()
    }

    private func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.02, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            if self.isHolding {
                self.progress += 0.02 / self.duration
                if self.progress >= 1.0 {
                    self.progress = 1.0
                    self.saveSession()
                    self.stopAndResetTimer()
                }
            }
        }
    }

    private func stopAndResetTimer() {
        timer?.invalidate()
        timer = nil
        progress = 0.0
    }

    private func saveSession() {
        let session = Session(mode: "hold", label: "Hold to Focus", timestamp: Date(), duration: TimeInterval(duration))
        modelContext.insert(session)
        do {
            try modelContext.save()
            print("Session saved successfully: \(session)")
            SupabaseService.uploadSession(mode: "hold", label: "Hold to Focus", timestamp: Date(), duration: TimeInterval(duration))
        } catch {
            print("Failed to save session: \(error)")
        }
    }
} 