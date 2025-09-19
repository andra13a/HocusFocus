import SwiftUI
import ARKit
import UIKit
import SwiftData

struct StareToFocusView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel: StareToFocusViewModel
    @State private var isLooking = false
    var onStop: () -> Void
    
    init(modelContext: ModelContext, sessionManager: SessionManager, onStop: @escaping () -> Void) {
        _viewModel = StateObject(wrappedValue: StareToFocusViewModel(modelContext: modelContext, sessionManager: sessionManager))
        self.onStop = onStop
    }
    
    var body: some View {
        ZStack{
            Image("background")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                Text("Focus session")
                    .font(.system(size: 13, weight: .medium, design: .rounded))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity, alignment: .top)
                    .padding(.top, 260)
                Text(viewModel.timerText)
                    .font(Font.custom("SF Compact Rounded", size:56)
                        .weight(.heavy))
                    .multilineTextAlignment(.center)
                    .foregroundStyle(Color(red: 0.36, green: 0.47, blue: 0.69))
                    .frame(maxWidth: .infinity, alignment: .top)
                Image(systemName: "eye.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 32, height: 32)
                    .foregroundColor(.black)
                    .padding(.top, 5)
                    .multilineTextAlignment(.center)
                Text("Keep staring to focus")
                    .font(.system(size: 13, weight: .medium, design: .rounded))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.black)
                    .frame(width: 137, alignment: .top)
                ARFaceTrackingContainer(isLooking: $isLooking)
                    .frame(height: 300)
                Button(action: {
                    viewModel.stopAndResetTimer()
                    onStop()
                }) {
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 343, height: 64)
                        .background(Color.black)
                        .cornerRadius(999)
                        .overlay(
                            Text("Stop focus session")
                                .font(.system(size: 17, weight: .medium, design: .rounded))
                                .multilineTextAlignment(.center)
                                .foregroundColor(.white)
                        )
                }
                .padding(.top, -30)
                Spacer()
            }
            .onChange(of: isLooking) { newValue in
                if newValue {
                    viewModel.startTimer()
                } else {
                    viewModel.stopAndResetTimer()
                }
            }
        }
    }
}
    
    #Preview {
        let modelContainer = try! ModelContainer(for: Session.self)
        let sessionManager = SessionManager(modelContext: modelContainer.mainContext)
        return StareToFocusView(modelContext: modelContainer.mainContext, sessionManager: sessionManager, onStop: {})
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
