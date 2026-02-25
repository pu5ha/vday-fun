import SwiftUI

struct ValentineTheme {
    // Primary palette
    static let deepRed       = Color(red: 0.72, green: 0.07, blue: 0.15)
    static let roseRed       = Color(red: 0.89, green: 0.15, blue: 0.28)
    static let hotPink       = Color(red: 0.95, green: 0.30, blue: 0.50)
    static let softPink      = Color(red: 0.98, green: 0.60, blue: 0.70)
    static let blushPink     = Color(red: 1.00, green: 0.85, blue: 0.88)
    static let cream         = Color(red: 1.00, green: 0.96, blue: 0.94)
    static let gold          = Color(red: 0.85, green: 0.65, blue: 0.30)
    static let darkBurgundy  = Color(red: 0.35, green: 0.02, blue: 0.10)

    // Functional
    static let background    = Color(red: 1.00, green: 0.95, blue: 0.96)
    static let cardBg        = Color.white
    static let textPrimary   = Color(red: 0.20, green: 0.05, blue: 0.10)
    static let textSecondary = Color(red: 0.55, green: 0.30, blue: 0.35)

    // Gradients
    static let heroGradient = LinearGradient(
        colors: [deepRed, roseRed, hotPink],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let cardGradient = LinearGradient(
        colors: [softPink, blushPink, cream],
        startPoint: .top,
        endPoint: .bottom
    )

    static let buttonGradient = LinearGradient(
        colors: [roseRed, hotPink],
        startPoint: .leading,
        endPoint: .trailing
    )

    // Typography
    static let titleFont    = Font.system(size: 32, weight: .bold, design: .serif)
    static let headlineFont = Font.system(size: 22, weight: .semibold, design: .serif)
    static let bodyFont     = Font.system(size: 16, weight: .regular, design: .serif)
    static let captionFont  = Font.system(size: 13, weight: .medium, design: .rounded)
}
