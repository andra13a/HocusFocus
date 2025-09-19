import SwiftUI
import Charts

struct StatCard: View {
    let title: String
    let value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.system(size: 15, weight: .medium, design: .rounded))
                .foregroundColor(.black)
                .frame(maxWidth: .infinity, alignment: .topLeading)

            Text(value)
                .font(.system(size: 24, weight: .medium, design: .rounded))
                .foregroundColor(Color(red: 0.36, green: 0.47, blue: 0.69))
                .frame(maxWidth: .infinity, alignment: .topLeading)
        }
        .padding()
        .frame(width: 168, height: 70)
        .background(Color.white)
        .cornerRadius(24)
    }
}

struct StatsView: View {
    @ObservedObject var sessionManager: SessionManager
    @ObservedObject var achievementManager: AchievementManager
    
    @Binding var activeTab: String?
    @Binding var showReadMode: Bool
    @Binding var showAchievements: Bool
    @Binding var showStatistics: Bool

    func formatTime(_ interval: TimeInterval) -> String {
        let minutes = Int(interval) / 60
        let seconds = Int(interval) % 60
        return String(format: "%d:%02ds", minutes, seconds)
    }

    var body: some View {
        NavigationView {
            ZStack {
                Image("background")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .clipped()
                    .ignoresSafeArea(.all, edges: .top)
                
                Color(red: 0.93, green: 0.93, blue: 0.93)
                    .opacity(0.7)
                    .blur(radius: 35)
                
                VStack(spacing: 8) {
                    HStack(spacing: 8) {
                        StatCard(title: "Fitness Score", value: "\(Int(sessionManager.movingAverageFitnessScore(windowSize: 5)))")
                        StatCard(title: "Longest Session", value: formatTime(sessionManager.longestSessionDuration()))
                    }
                    
                    HStack(spacing: 8) {
                        StatCard(title: "Longest Streak", value: "\(sessionManager.longestStreak()) days")
                        StatCard(title: "Achievements", value: "\(achievementManager.unlockedCount)")
                    }
                    
                    DurationChartView(sessions: sessionManager.sessions)
                        .padding(.top, 8)
                }
                .padding(.top, -50)
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    VStack {
                        Spacer().frame(height: 60)
                        Text("Statistics")
                            .font(.headline)
                            .foregroundColor(.black)
                            .multilineTextAlignment(.center)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct DurationChartView: View {
    var sessions: [Session]

    var body: some View {
        Rectangle()
            .foregroundColor(.clear)
            .frame(width: 344, height: 443)
            .background(Color.white)
            .cornerRadius(24)
            .overlay(
                Chart {
                    ForEach(sessions) { session in
                        BarMark(
                            x: .value("Date", session.timestamp, unit: .day),
                            y: .value("Duration", session.duration / 60)
                        )
                        .foregroundStyle(Color(red: 0.36, green: 0.61, blue: 0.69))
                        .cornerRadius(3)
                    }
                }
                .padding()
                .chartYAxis {
                    AxisMarks(position: .leading)
                }
                .chartXAxis {
                    AxisMarks(values: .automatic) { value in
                        if value.index == 0 {
                            AxisValueLabel {
                                Text("min")
                            }
                        } else {
                            AxisValueLabel()
                        }
                    }
                }
            )
    }
}
