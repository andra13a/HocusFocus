import SwiftUI

struct HoldToFocusTimerView: View {
    @State private var isHolding = false
    @State private var progress: CGFloat = 0.0
    var timerDuration: Double = 10.0 // seconds
    @State private var timer: Timer? = nil

    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.gray.opacity(0.3), lineWidth: 20)
            Circle()
                .trim(from: 0, to: progress)
                .stroke(Color.green, style: StrokeStyle(lineWidth: 20, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .animation(.linear, value: progress)
        }
        .frame(width: 200, height: 200)
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    if !isHolding {
                        isHolding = true
                        print("Holding!")
                        startTimer()
                    }
                }
                .onEnded { _ in
                    isHolding = false
                    print("Released!")
                    stopAndResetTimer()
                }
        )
    }

    func startTimer() {
        timer?.invalidate()
        progress = 0.0
        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { t in
            if isHolding {
                progress += 0.01 / timerDuration
                if progress >= 1.0 {
                    progress = 1.0
                    t.invalidate()
                }
            } else {
                t.invalidate()
            }
        }
    }

    func stopAndResetTimer() {
        timer?.invalidate()
        progress = 0.0
    }
}

#Preview {
    HoldToFocusTimerView()
} 