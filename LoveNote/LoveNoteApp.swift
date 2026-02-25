import SwiftUI

@main
struct LoveNoteApp: App {
    @StateObject private var messageStore = MessageStore()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(messageStore)
        }
    }
}
