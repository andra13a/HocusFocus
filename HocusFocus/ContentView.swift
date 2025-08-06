import SwiftUI
import SwiftData

enum FocusMode {
    case stare
    case hold
}

struct TimerLabelView: View {
    @ObservedObject var formatter: TimerLabelFormatter
    var seconds: Int
    var body: some View {
        Text(formatter.format(seconds: seconds))
            .font(.title)
    }
}

struct SessionHistoryView: View {
    @ObservedObject var sessionManager: SessionManager

    func formatTime(_ interval: TimeInterval) -> String {
        let minutes = Int(interval) / 60
        let seconds = Int(interval) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Total Focus Time: \(formatTime(sessionManager.totalFocusTime))")
                    .font(.headline)
                Text("Average Session: \(formatTime(sessionManager.averageSessionDuration))")
                    .font(.subheadline)
            }
            .padding(.horizontal)

            List(sessionManager.sessions) { session in
                VStack(alignment: .leading) {
                    Text(session.label ?? "No Label")
                    Text("Mode: \(session.mode ?? "Unknown"), Duration: \(Int(session.duration))s")
                        .font(.caption)
                    Text("\(session.timestamp.formatted())")
                        .font(.caption2)
                }
            }
        }
        .navigationTitle("Session History")
    }
}

struct ContentView: View {
    @State private var selectedMode: FocusMode? = nil
    @StateObject private var sessionManager: SessionManager
    @State private var showSessionHistory = false
    @StateObject private var formatter = TimerLabelFormatter()
    @Environment(\.modelContext) private var modelContext

    init(modelContext: ModelContext) {
        _sessionManager = StateObject(wrappedValue: SessionManager(modelContext: modelContext))
    }
    func formatTime(_ interval: TimeInterval) -> String {
           let minutes = Int(interval) / 60
           let seconds = Int(interval) % 60
           return "\(minutes)m \(seconds)s"
       }

    var body: some View {
        NavigationStack {
            ZStack {
                // Background image
                Image("background")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()

                VStack {
                    if let mode = selectedMode {
                        switch mode {
                        case .stare:
                            StareToFocusView(modelContext: modelContext, sessionManager: sessionManager)
                        case .hold:
                            HoldToFocusTimerView(modelContext: modelContext, sessionManager: sessionManager)
                        }

                        Button("Back") {
                            selectedMode = nil
                        }
                        .padding(.top)
                        .accessibilityIdentifier("BackButton")
                    } else {
                        VStack(spacing: 40) {
                            Spacer().frame(height:220)

                            VStack(spacing: 8) {
                                Text("Focused today")
                                    .font(.custom("SF Pro", size: 14).weight(.bold))
                                    .foregroundColor(.black)
                                    .multilineTextAlignment(.center)
                                    .frame(maxWidth: .infinity)
                                    .lineSpacing(5)
                                    .kerning(-0.08)

                                Text("\(Int(sessionManager.todayFocusTime))s")
                                    .font(.custom("SF Compact Rounded", size: 56))
                                    .fontWeight(.medium)
                                    .foregroundColor(Color(hex: "#5B78AF"))
                                    .multilineTextAlignment(.center)
                                    .frame(maxWidth: .infinity)
                                    .kerning(-1.463)
                            }

                            Spacer()
                            VStack(spacing: 8) {
                                Button(action: {
                                    selectedMode = .hold
                                }) {
                                    Text(NSLocalizedString("Hold to focus", comment: ""))
                                        .font(.custom("SF Pro", size: 17))
                                        .foregroundColor(.white)
                                        .multilineTextAlignment(.center)
                                        .frame(width: 343, height: 64)
                                        .background(Color.black)
                                        .cornerRadius(999)
                                        .kerning(-0.43)
                                }
                                .accessibilityIdentifier("HoldToFocusModeButton")

                                Button(action: {
                                    selectedMode = .stare
                                }) {
                                    Text(NSLocalizedString("Stare to focus", comment: ""))
                                        .font(.custom("SF Pro", size: 17))
                                        .foregroundColor(.white)
                                        .multilineTextAlignment(.center)
                                        .frame(width: 343, height: 64)
                                        .background(Color.black)
                                        .cornerRadius(999)
                                        .kerning(-0.43)
                                }
                                .accessibilityIdentifier("StareToFocusModeButton")
                            }
                            .padding(.horizontal, 16)
                            .padding(.bottom, 1)

                            Button(action: {
                                showSessionHistory = true
                            }) {
                                Text("Previous focus sessions")
                                    .font(.custom("SF Pro", size: 14))
                                    .fontWeight(.medium)
                                    .foregroundColor(.black)
                                    .frame(width: 193, height: 34)
                                    .background(Color.white)
                                    .cornerRadius(40)
                            }
                            .accessibilityIdentifier("SessionHistoryButton")
                            .navigationDestination(isPresented: $showSessionHistory) {
                                SessionHistoryView(sessionManager: sessionManager)
                            }
                            .padding(.bottom, 56)
                        }
                    }
                }
                .padding()
            }
        }
        .onAppear {
            sessionManager.fetchSessionsFromSupabase()
        }
    }
}

#Preview {
    ContentView(modelContext: try! ModelContainer(for: Session.self).mainContext)
}

extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        _ = scanner.scanString("#")
        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)
        let r = Double((rgb >> 16) & 0xFF) / 255
        let g = Double((rgb >> 8) & 0xFF) / 255
        let b = Double(rgb & 0xFF) / 255
        self.init(red: r, green: g, blue: b)
    }
}
