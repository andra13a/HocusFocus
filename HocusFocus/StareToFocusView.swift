import SwiftUI
import ARKit
import UIKit
import SwiftData

struct StareToFocusView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel: StareToFocusViewModel
    @State private var isLooking = false
    
    init(modelContext: ModelContext) {
        _viewModel = StateObject(wrappedValue: StareToFocusViewModel(modelContext: modelContext))
    }
    
    var body: some View {
        VStack {
            Text("Stare to Focus")
                .font(.title)
                .padding()
            ZStack {
                Circle()
                    .stroke(Color.gray.opacity(0.3), lineWidth: 20)
                Circle()
                    .trim(from: 0, to: viewModel.progress)
                    .stroke(Color.blue, style: StrokeStyle(lineWidth: 20, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                    .animation(.linear, value: viewModel.progress)
                if viewModel.completed {
                    Text("Focused!")
                        .font(.title2)
                        .foregroundColor(.green)
                }
            }
            .frame(width: 200, height: 200)
            .padding()
            ARFaceTrackingContainer(isLooking: $isLooking)
                .frame(height: 300)
        }
        .onChange(of: isLooking) {
            viewModel.onLookingChanged(isLooking)
        }
    }
}

#Preview {
    // Provide a dummy modelContext for preview
    StareToFocusView(modelContext: try! ModelContainer(for: Session.self).mainContext)
}


struct ARFaceTrackingContainer: UIViewRepresentable {
    @Binding var isLooking: Bool
    
    class Coordinator: NSObject, ARSessionDelegate {
        var parent: ARFaceTrackingContainer

        init(parent: ARFaceTrackingContainer) {
            self.parent = parent
        }

        func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
            for anchor in anchors {
                guard let faceAnchor = anchor as? ARFaceAnchor else { continue }
                let lookAt = faceAnchor.lookAtPoint
                let isLooking = abs(lookAt.x) < 0.2 && abs(lookAt.y) < 0.2
                let blinkLeft = faceAnchor.blendShapes[.eyeBlinkLeft]?.floatValue ?? 0.0
                let blinkRight = faceAnchor.blendShapes[.eyeBlinkRight]?.floatValue ?? 0.0
                let isBlinking = blinkLeft > 0.5 || blinkRight > 0.5
                DispatchQueue.main.async {
                    self.parent.isLooking = isLooking && !isBlinking
                }
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    func makeUIView(context: Context) -> ARSCNView {
        let view = ARSCNView()
        view.session.delegate = context.coordinator

        view.scene.background.contents = UIColor.clear
        view.isHidden = true 

        if ARFaceTrackingConfiguration.isSupported {
            let configuration = ARFaceTrackingConfiguration()
            view.session.run(configuration)
        }
        return view
    }

    func updateUIView(_ uiView: ARSCNView, context: Context) {
    
    }
}
