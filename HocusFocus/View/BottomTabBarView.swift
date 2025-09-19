import SwiftUI

struct BottomTabBarView: View {
    @Binding var activeTab: String?

    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: 376, height: 107)
                .background(.black.opacity(0.01))
                .blur(radius: 30)
            
            HStack(alignment: .top) {
                Spacer()
                
                Button(action: { activeTab = "home" }) {
                    VStack(alignment: .center, spacing: 6) {
                        Image(systemName: activeTab == "home" ? "house.fill" : "house")
                            .font(Font.custom("SF Pro", size: 24).weight(.medium))
                            .foregroundColor(.black)
                            .frame(width: 58.55, height: 21, alignment: .top)
                        Text("Home")
                            .font(Font.custom("SF Pro", size: 12).weight(.medium))
                            .foregroundColor(.black)
                            .frame(width: 95.70313, alignment: .top)
                    }
                }
                .frame(maxWidth: .infinity)
                
                Spacer()
                
                Button(action: { activeTab = "read" }) {
                    VStack(alignment: .center, spacing: 6) {
                        Image(systemName: activeTab == "read" ? "book.fill" : "book")
                            .font(Font.custom("SF Pro", size: 24).weight(.medium))
                            .foregroundColor(.black)
                            .frame(width: 58.55, height: 21, alignment: .top)
                        Text("Read")
                            .font(Font.custom("SF Pro", size: 12).weight(.medium))
                            .foregroundColor(.black)
                            .frame(width: 95.70313, alignment: .top)
                    }
                }
                .frame(maxWidth: .infinity)
                
                Spacer()
                
                Button(action: { activeTab = "achievements" }) {
                    VStack(alignment: .center, spacing: 6) {
                        Image(systemName: activeTab == "achievements" ? "star.fill" : "star")
                            .font(Font.custom("SF Pro", size: 24).weight(.medium))
                            .foregroundColor(.black)
                            .frame(width: 58.55, height: 21, alignment: .top)
                        Text("Achievements")
                            .font(Font.custom("SF Pro", size: 12).weight(.medium))
                            .foregroundColor(.black)
                            .frame(width: 95.70313, alignment: .top)
                    }
                }
                .frame(maxWidth: .infinity)
                
                Spacer()
                
                Button(action: { activeTab = "stats" }) {
                    VStack(alignment: .center, spacing: 6) {
                        Image(systemName: activeTab == "stats" ? "chart.bar.fill" : "chart.bar")
                            .font(Font.custom("SF Pro", size: 24).weight(.medium))
                            .foregroundColor(.black)
                            .frame(width: 58.55, height: 21, alignment: .top)
                        Text("Stats")
                            .font(Font.custom("SF Pro", size: 12).weight(.medium))
                            .foregroundColor(.black)
                            .frame(width: 95.70313, alignment: .top)
                    }
                }
                .frame(maxWidth: .infinity)
                
                Spacer()
            }
            .frame(maxWidth: .infinity, minHeight: 83, maxHeight: 83)
        }
        .frame(maxHeight: .infinity, alignment: .bottom)
        .padding(.bottom, 40)
        .edgesIgnoringSafeArea(.all)
    }
}

struct BottomTabBarView_Previews: PreviewProvider {
    @State static var activeTab: String? = "home"

    static var previews: some View {
        BottomTabBarView(
            activeTab: $activeTab
        )
        .previewLayout(.sizeThatFits)
    }
}
