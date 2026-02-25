import SwiftUI

struct HomeView: View {
    @State private var showCompose = false

    var body: some View {
        NavigationStack {
            ZStack {
                // Background gradient
                GradientBackground(style: .hero)

                // Floating hearts
                HeartParticleView()

                // Main content
                VStack(spacing: 32) {
                    Spacer()

                    // App title
                    VStack(spacing: 8) {
                        Image(systemName: "heart.text.clipboard.fill")
                            .font(.system(size: 56))
                            .foregroundStyle(.white)
                            .shadow(color: .black.opacity(0.2), radius: 4, y: 2)

                        Text("LoveNote")
                            .font(.system(size: 42, weight: .bold, design: .serif))
                            .foregroundStyle(.white)
                            .shimmer(duration: 3.0)

                        Text("Send anonymous love messages\nto someone special")
                            .font(.system(size: 16, weight: .medium, design: .serif))
                            .foregroundStyle(.white.opacity(0.85))
                            .multilineTextAlignment(.center)
                            .lineSpacing(4)
                    }

                    Spacer()

                    // CTA Button
                    NavigationLink(destination: ComposeMessageView()) {
                        HStack(spacing: 12) {
                            PulsingHeartView(size: 20, color: ValentineTheme.roseRed)

                            Text("Send a Love Note")
                                .font(.system(size: 19, weight: .bold, design: .rounded))
                                .foregroundStyle(ValentineTheme.roseRed)
                        }
                        .padding(.vertical, 18)
                        .padding(.horizontal, 40)
                        .background(
                            Capsule()
                                .fill(.white)
                                .shadow(color: .black.opacity(0.2), radius: 12, y: 6)
                        )
                    }

                    // Subtitle
                    Text("Your identity stays secret \u{1F90D}")
                        .font(.system(size: 13, weight: .medium, design: .rounded))
                        .foregroundStyle(.white.opacity(0.7))

                    Spacer()
                        .frame(height: 40)
                }
                .padding()
            }
            .toolbar(.hidden, for: .navigationBar)
        }
    }
}
