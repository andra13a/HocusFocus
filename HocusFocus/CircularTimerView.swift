import SwiftUI

struct CircularTimerView: View {
    @State private var progress: CGFloat = 0.0
    
        var body: some View {
                ZStack {
                    Circle()
                        .stroke(Color.gray.opacity(0.3), lineWidth: 20)
                    Circle()
                        .trim(from: 0, to: progress)
                        .stroke(Color.blue, style: StrokeStyle(lineWidth: 20, lineCap: .round))
                        .rotationEffect(.degrees(-90))
                        .animation(.linear, value: progress)
                }
                .frame(width: 200, height: 200)
                .onAppear {
                    withAnimation(.linear(duration: 10)) {
                        progress = 1.0
                    }
                }
            }
        }

#Preview {
    CircularTimerView()
} 
