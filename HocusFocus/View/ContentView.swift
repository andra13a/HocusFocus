import SwiftUI
import SwiftData

enum FocusMode {
    case stare
}

struct TimerLabelView: View {
    @ObservedObject var formatter: TimerLabelFormatter
    var seconds: Int
    var body: some View {
        Text(formatter.format(seconds: seconds))
            .font(.title)
    }
}

struct ContentView: View {
    @State private var selectedMode: FocusMode? = nil
    @StateObject private var sessionManager: SessionManager
    @StateObject private var achievementManager: AchievementManager
    @State private var showSessionHistory = false
    @State private var showAchievements = false
    @StateObject private var formatter = TimerLabelFormatter()
    @State private var showStatistics = false
    @State private var showReadMode = false
    @Environment(\.modelContext) private var modelContext
    @State private var activeTab: String? = "home"
    @State private var hasStartedReading = false
    
    init(modelContext: ModelContext) {
        let sessionManager = SessionManager(modelContext: modelContext)
        _sessionManager = StateObject(wrappedValue: sessionManager)
        _achievementManager = StateObject(wrappedValue: AchievementManager(sessionManager: sessionManager))
    }
    func formatTime(_ interval: TimeInterval) -> String {
        let minutes = Int(interval) / 60
        let seconds = Int(interval) % 60
        return String(format: "%d:%02ds", minutes, seconds)
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                if !(activeTab == "read" && hasStartedReading) {
                    GeometryReader { geometry in
                        Image("background")
                            .resizable()
                            .scaledToFill()
                            .ignoresSafeArea()
                    }
                } else {
                    Color.white.ignoresSafeArea()
                }

                if let mode = selectedMode {
                    switch mode {
                    case .stare:
                        StareToFocusView(
                            modelContext: modelContext,
                            sessionManager: sessionManager,
                            onStop: { selectedMode = nil}
                        )
                    }
                } else {
                    switch activeTab {
                    case "home":
                        VStack(spacing: 100) {
                            Spacer().frame(height:10)
                            VStack(spacing: 8) {
                                Text("Focused today")
                                    .font(.system(size: 13, weight: .medium, design: .rounded))
                                    .foregroundColor(.black)
                                    .multilineTextAlignment(.center)
                                    .lineSpacing(5)
                                    .kerning(-0.08)
                                
                                Text(formatTime(sessionManager.todayFocusTime))
                                    .font(.system(size: 56, weight: .regular, design: .rounded))
                                    .foregroundColor(Color(red: 0.36, green: 0.47, blue: 0.69))
                                    .multilineTextAlignment(.center)
                                    .kerning(-1.463)
                            }
                            .offset(y: -40)
                            VStack(spacing: 8) {
                                Button(action: { selectedMode = .stare }) {
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

                                Spacer().frame(height: 32)
                            }
                        }

                    case "read":
                        ReadModeView(hasStartedReading: $hasStartedReading)
                            .environmentObject(sessionManager)

                    case "achievements":
                        AchievementsView(achievementManager: achievementManager)
                    case "stats":
                        StatsView(
                            sessionManager: sessionManager,
                            achievementManager: achievementManager,
                            activeTab: $activeTab,
                            showReadMode: $showReadMode,
                            showAchievements: $showAchievements,
                            showStatistics: $showStatistics
                        )

                    default:
                        EmptyView()
                    }
                }
                if selectedMode == nil && !(activeTab == "read" && hasStartedReading) {
                    VStack {
                        Spacer()
                        ZStack {
                            Rectangle()
                                .foregroundColor(.clear)
                                .frame(height: 107)
                                .background(.ultraThinMaterial.opacity(0.7))
                                .blur(radius: 17)
                                .ignoresSafeArea(edges: .bottom)
                            BottomTabBarView(activeTab: $activeTab)
                                .frame(height: 83)
                                .frame(maxWidth: .infinity)
                        }
                    }
                    .ignoresSafeArea(edges: .bottom)
                }
            }
        }
        .onAppear {
            sessionManager.fetchSessionsFromSupabase()
            Task { await achievementManager.checkAchievements() }
        }
    }
    
    
    #Preview {
        ContentView(modelContext: try! ModelContainer(for: Session.self).mainContext)
    }
    
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
