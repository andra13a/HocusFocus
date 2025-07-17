import SwiftUI
import SwiftData

struct HoldToFocusTimerView: View {
    @StateObject private var viewModel: HoldToFocusTimerViewModel
    
    init(modelContext: ModelContext) {
        _viewModel = StateObject(wrappedValue: HoldToFocusTimerViewModel(modelContext: modelContext))
    }
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.gray.opacity(0.3), lineWidth: 20)
            Circle()
                .trim(from: 0, to: viewModel.progress)
                .stroke(Color.green, style: StrokeStyle(lineWidth: 20, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .animation(.linear, value: viewModel.progress)
        }
        .frame(width: 200, height: 200)
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    viewModel.startHolding()
                }
                .onEnded { _ in
                    viewModel.stopHolding()
                }
        )
    }
}

#Preview {
    HoldToFocusTimerView(modelContext: try! ModelContainer(for: Session.self).mainContext)
} 
