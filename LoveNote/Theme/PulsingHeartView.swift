import SwiftUI

struct PulsingHeartView: View {
    @State private var isPulsing = false

    var size: CGFloat = 28
    var color: Color = ValentineTheme.roseRed

    var body: some View {
        Image(systemName: "heart.fill")
            .font(.system(size: size))
            .foregroundStyle(color)
            .scaleEffect(isPulsing ? 1.15 : 1.0)
            .animation(
                .easeInOut(duration: 0.8)
                .repeatForever(autoreverses: true),
                value: isPulsing
            )
            .onAppear {
                isPulsing = true
            }
    }
}
