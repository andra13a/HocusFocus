import SwiftUI
import SwiftData

struct HoldToFocusTimerView: View {
    @State private var progress: CGFloat = 0.0
    @State private var isHolding = false
    @State private var timer: Timer? = nil
    let duration: CGFloat = 10.0 // seconds for full circle
    @Environment(\.modelContext) private var modelContext

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
        timer = Timer.scheduledTimer(withTimeInterval: 0.02, repeats: true) { _ in
            if isHolding {
                progress += 0.02 / duration
                if progress >= 1.0 {
                    progress = 1.0
                    stopAndResetTimer()
                }
            }
        }
    }

    func stopAndResetTimer() {
        timer?.invalidate()
        timer = nil
        progress = 0.0
    }

}
#Preview {
    HoldToFocusTimerView()
} 
