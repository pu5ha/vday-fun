import SwiftUI

struct GradientBackground: View {
    var style: Style = .hero

    enum Style {
        case hero
        case soft
        case dark
    }

    var body: some View {
        switch style {
        case .hero:
            LinearGradient(
                colors: [
                    ValentineTheme.deepRed,
                    ValentineTheme.roseRed,
                    ValentineTheme.hotPink
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

        case .soft:
            LinearGradient(
                colors: [
                    ValentineTheme.blushPink,
                    ValentineTheme.cream,
                    .white
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

        case .dark:
            LinearGradient(
                colors: [
                    ValentineTheme.darkBurgundy,
                    Color(red: 0.15, green: 0.01, blue: 0.05)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
        }
    }
}
