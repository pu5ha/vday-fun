import SwiftUI

struct CardDesignView: View {
    let message: LoveMessage

    var body: some View {
        Group {
            switch message.cardStyle {
            case .classicRed:
                classicRedCard
            case .pinkGradient:
                pinkGradientCard
            case .roseGold:
                roseGoldCard
            case .darkRomance:
                darkRomanceCard
            case .playful:
                playfulCard
            }
        }
    }

    // MARK: - Classic Red

    private var classicRedCard: some View {
        ZStack {
            ValentineTheme.deepRed

            // Corner hearts
            VStack {
                HStack {
                    heartCorner
                    Spacer()
                    heartCorner
                }
                Spacer()
                HStack {
                    heartCorner
                    Spacer()
                    heartCorner
                }
            }
            .padding(16)

            // Gold border
            RoundedRectangle(cornerRadius: 12)
                .strokeBorder(ValentineTheme.gold, lineWidth: 3)
                .padding(24)

            cardContent(
                textColor: .white,
                accentColor: ValentineTheme.gold
            )
        }
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    // MARK: - Pink Gradient

    private var pinkGradientCard: some View {
        ZStack {
            LinearGradient(
                colors: [ValentineTheme.hotPink, ValentineTheme.softPink, ValentineTheme.blushPink],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            // Scattered small hearts
            ForEach(0..<8, id: \.self) { i in
                Image(systemName: "heart.fill")
                    .font(.system(size: CGFloat.random(in: 8...16)))
                    .foregroundStyle(.white.opacity(0.25))
                    .offset(
                        x: CGFloat([-120, 100, -60, 130, -90, 70, -140, 110][i]),
                        y: CGFloat([-180, -140, -50, 30, 80, 140, 170, -100][i])
                    )
            }

            cardContent(
                textColor: ValentineTheme.darkBurgundy,
                accentColor: ValentineTheme.roseRed
            )
        }
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }

    // MARK: - Rose Gold

    private var roseGoldCard: some View {
        ZStack {
            ValentineTheme.cream

            // Thin elegant border
            RoundedRectangle(cornerRadius: 8)
                .strokeBorder(
                    LinearGradient(
                        colors: [ValentineTheme.gold, ValentineTheme.softPink, ValentineTheme.gold],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 2
                )
                .padding(20)

            cardContent(
                textColor: ValentineTheme.textPrimary,
                accentColor: ValentineTheme.gold
            )
        }
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    // MARK: - Dark Romance

    private var darkRomanceCard: some View {
        ZStack {
            Color(red: 0.10, green: 0.02, blue: 0.05)

            // Subtle heart pattern overlay
            VStack(spacing: 30) {
                ForEach(0..<5, id: \.self) { row in
                    HStack(spacing: 30) {
                        ForEach(0..<5, id: \.self) { _ in
                            Image(systemName: "heart.fill")
                                .font(.system(size: 12))
                                .foregroundStyle(.white.opacity(0.04))
                        }
                    }
                    .offset(x: row % 2 == 0 ? 0 : 15)
                }
            }

            cardContent(
                textColor: ValentineTheme.softPink,
                accentColor: ValentineTheme.roseRed
            )
        }
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    // MARK: - Playful

    private var playfulCard: some View {
        ZStack {
            ValentineTheme.hotPink

            // Emoji hearts scattered
            ForEach(0..<6, id: \.self) { i in
                Text(["\u{2764}\u{FE0F}", "\u{1F495}", "\u{1F496}", "\u{1F497}", "\u{1F49D}", "\u{1F49E}"][i])
                    .font(.system(size: CGFloat.random(in: 20...36)))
                    .rotationEffect(.degrees(Double([-15, 20, -10, 25, -20, 15][i])))
                    .offset(
                        x: CGFloat([-110, 120, -80, 100, -130, 90][i]),
                        y: CGFloat([-170, -120, 60, 140, 170, -60][i])
                    )
                    .opacity(0.4)
            }

            cardContent(
                textColor: .white,
                accentColor: .yellow,
                useRoundedFont: true
            )
        }
        .clipShape(RoundedRectangle(cornerRadius: 24))
    }

    // MARK: - Shared Card Content

    private func cardContent(
        textColor: Color,
        accentColor: Color,
        useRoundedFont: Bool = false
    ) -> some View {
        VStack(spacing: 20) {
            Spacer()

            // "To" header
            Text("To: \(message.recipientName)")
                .font(useRoundedFont
                    ? .system(size: 18, weight: .bold, design: .rounded)
                    : .system(size: 18, weight: .semibold, design: .serif)
                )
                .foregroundStyle(accentColor)

            // Decorative divider
            HStack(spacing: 8) {
                Rectangle()
                    .frame(width: 40, height: 1)
                    .foregroundStyle(accentColor.opacity(0.5))
                Image(systemName: "heart.fill")
                    .font(.system(size: 10))
                    .foregroundStyle(accentColor)
                Rectangle()
                    .frame(width: 40, height: 1)
                    .foregroundStyle(accentColor.opacity(0.5))
            }

            // Message body
            Text(message.messageBody)
                .font(useRoundedFont
                    ? .system(size: 20, weight: .medium, design: .rounded)
                    : .system(size: 20, weight: .regular, design: .serif)
                )
                .foregroundStyle(textColor)
                .multilineTextAlignment(.center)
                .lineSpacing(6)
                .padding(.horizontal, 32)

            Spacer()

            // Footer
            HStack(spacing: 4) {
                Image(systemName: "heart.fill")
                    .font(.system(size: 10))
                Text("Happy Valentine's Day")
                    .font(useRoundedFont
                        ? .system(size: 13, weight: .semibold, design: .rounded)
                        : .system(size: 13, weight: .medium, design: .serif)
                    )
                Image(systemName: "heart.fill")
                    .font(.system(size: 10))
            }
            .foregroundStyle(accentColor.opacity(0.7))
            .padding(.bottom, 24)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var heartCorner: some View {
        Image(systemName: "heart.fill")
            .font(.system(size: 14))
            .foregroundStyle(ValentineTheme.gold.opacity(0.6))
    }
}
