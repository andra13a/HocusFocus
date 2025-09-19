import SwiftUI
import UIKit

struct AchievementsView: View {
    @ObservedObject var achievementManager: AchievementManager
    @State private var isShareSheetPresented = false
    @State private var shareText = ""
    
    var body: some View {
        ZStack {

            Rectangle()
                .foregroundColor(.clear)
                .frame(width: 376, height: 812)
                .background(Color(red: 0.93, green: 0.93, blue: 0.93).opacity(0.7))
                .blur(radius: 35)
            
            VStack(spacing: 20) {
                Text("Achievements")
                    .font(.headline)
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(achievementManager.achievements) { achievement in
                            Rectangle()
                                .foregroundColor(.clear)
                                .frame(width: 343, height: 79)
                                .background(.white)
                                .cornerRadius(24)
                                .overlay(
                                    HStack(spacing: 16) {
                                        Image(systemName: achievement.isUnlocked ? "checkmark.circle.fill" : "hourglass")
                                            .font(.title2)
                                            .foregroundColor(achievement.isUnlocked ? .green : .gray)
                                            .padding(.leading, 8)
                                        
                                        VStack(alignment: .leading, spacing: 6) {
                                            Text(achievement.title)
                                                .font(.system(size: 17, weight: .medium, design: .rounded))
                                                .foregroundColor(.black)
                                            Text(achievement.description)
                                                .font(.system(size: 13, weight: .medium, design: .rounded))
                                                .foregroundColor(.black)
                                                .opacity(0.5)
                                        }
                                        Spacer()
                                        
                                        Button(action: {
                                            shareText = "I unlocked the achievement: \(achievement.title)!"
                                            isShareSheetPresented = true
                                        }) {
                                            Image(systemName: "square.and.arrow.up")
                                                .foregroundColor(.blue)
                                        }
                                        .buttonStyle(BorderlessButtonStyle())
                                    }
                                    .padding(.horizontal, 16)
                                )
                                .scaleEffect(1.0)
                                .animation(.spring(), value: 1)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                    .padding(.bottom, 100)
                }
            }
            .padding(.top, 50)
            .sheet(isPresented: $isShareSheetPresented) {
                AchievementShareView(activityItems: [shareText])
            }
        }
    }
}

struct AchievementShareView: UIViewControllerRepresentable {
    let activityItems: [Any]
    let applicationActivities: [UIActivity]? = nil

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: activityItems, applicationActivities: applicationActivities)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
