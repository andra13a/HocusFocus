import SwiftUI
import ARKit
import UIKit

struct StareToFocusView: View {
    @State private var progress: CGFloat = 0.0
    @State private var timer: Timer? = nil
    @State private var isLooking = false
    @State private var completed = false
    let duration: CGFloat = 10.0 // seconds
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        VStack {
            Text("Stare to Focus")
                .font(.title)
                .padding()
            ZStack {
                Circle()
                    .stroke(Color.gray.opacity(0.3), lineWidth: 20)
                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(Color.blue, style: StrokeStyle(lineWidth: 20, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                    .animation(.linear, value: progress)
                if completed {
                    Text("Focused!")
                        .font(.title2)
                        .foregroundColor(.green)
                }
            }
            .frame(width: 200, height: 200)
            .padding()
            ARFaceTrackingContainer(isLooking: $isLooking)
                .frame(height: 300) // Adjust height as needed
        }
        .onChange(of: isLooking) { newValue in
            if newValue {
                startTimer()
            } else {
                stopAndResetTimer()
            }
        }
    }
    
    func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.02, repeats: true) { _ in
            if isLooking {
                progress += 0.02 / duration
                if progress >= 1.0 {
                    progress = 1.0
                    completed = true
                    
                    timer?.invalidate()
                }
            }
        }
    }
    
    func stopAndResetTimer() {
        timer?.invalidate()
        timer = nil
        progress = 0.0
        completed = false
    }
  
}
#Preview {
  StareToFocusView()
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
                // Heuristic: if lookAt is close to (0,0,0), user is looking at the screen
                let isLooking = abs(lookAt.x) < 0.2 && abs(lookAt.y) < 0.2
                // Detect blinks
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

        // Hide the camera feed
        view.scene.background.contents = UIColor.clear
        view.isHidden = true // This hides the view entirely

        if ARFaceTrackingConfiguration.isSupported {
            let configuration = ARFaceTrackingConfiguration()
            view.session.run(configuration)
        }
        return view
    }

    func updateUIView(_ uiView: ARSCNView, context: Context) {
        // No update logic needed for now
    }
}
