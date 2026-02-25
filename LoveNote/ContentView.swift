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

            SentMessagesView()
                .tabItem {
                    Label("My Notes", systemImage: "envelope.fill")
                }
                .tag(1)
        }
        .tint(ValentineTheme.roseRed)
    }
}
