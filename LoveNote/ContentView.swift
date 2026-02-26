import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Label("Send Love", systemImage: "heart.fill")
                }
                .tag(0)

            LoveLetterBuilderView()
                .tabItem {
                    Label("Love Letter", systemImage: "text.page.fill")
                }
                .tag(1)

            RizzRouletteView()
                .tabItem {
                    Label("Rizz", systemImage: "dice.fill")
                }
                .tag(2)

            SentMessagesView()
                .tabItem {
                    Label("My Notes", systemImage: "envelope.fill")
                }
                .tag(3)
        }
        .tint(ValentineTheme.roseRed)
    }
}
