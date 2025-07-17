import Foundation

class TimerLabelFormatter: ObservableObject {
    func format(seconds: Int) -> String {
        let minutes = seconds / 60
        let seconds = seconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
} 
