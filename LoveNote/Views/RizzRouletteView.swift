import SwiftUI
import UIKit

struct RizzRouletteView: View {
    @State private var currentLine: PickupLine?
    @State private var isSpinning = false
    @State private var spinRotation: Double = 0
    @State private var flameScale: CGFloat = 1.0
    @State private var showLine = false
    @State private var cycleLines: [PickupLine] = []
    @State private var cycleIndex = 0
    @State private var copyConfirm = false

    // Shake detection
    @State private var shakeDetector = ShakeDetector()

    var body: some View {
        NavigationStack {
            ZStack {
                // Background
                LinearGradient(
                    colors: [
                        Color(red: 0.12, green: 0.02, blue: 0.15),
                        Color(red: 0.25, green: 0.02, blue: 0.20),
                        Color(red: 0.10, green: 0.01, blue: 0.10)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                // Floating emoji background
                floatingEmojis

                VStack(spacing: 0) {
                    // Title
                    VStack(spacing: 4) {
                        Text("RIZZ ROULETTE")
                            .font(.system(size: 28, weight: .black, design: .rounded))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.yellow, .orange, .pink],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .shimmer(duration: 2.0, color: .white)

                        Text("Shake your phone or tap to spin!")
                            .font(.system(size: 13, weight: .medium, design: .rounded))
                            .foregroundStyle(.white.opacity(0.6))
                    }
                    .padding(.top, 16)

                    Spacer()

                    // Main card area
                    if isSpinning {
                        spinningView
                    } else if let line = currentLine {
                        resultCard(line: line)
                            .transition(.asymmetric(
                                insertion: .scale(scale: 0.5).combined(with: .opacity),
                                removal: .opacity
                            ))
                    } else {
                        promptCard
                    }

                    Spacer()

                    // Spin button
                    Button {
                        spin()
                    } label: {
                        HStack(spacing: 10) {
                            Image(systemName: "dice.fill")
                                .font(.system(size: 22))
                                .rotationEffect(.degrees(spinRotation))
                            Text(currentLine == nil ? "Test Your Rizz" : "Spin Again")
                                .font(.system(size: 19, weight: .bold, design: .rounded))
                        }
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(
                            LinearGradient(
                                colors: [.purple, .pink, .orange],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .clipShape(Capsule())
                        .shadow(color: .purple.opacity(0.5), radius: 12, y: 6)
                    }
                    .disabled(isSpinning)
                    .opacity(isSpinning ? 0.5 : 1.0)
                    .padding(.horizontal, 32)

                    // Copy button (when there's a result)
                    if let line = currentLine, !isSpinning {
                        Button {
                            UIPasteboard.general.string = line.text
                            let generator = UINotificationFeedbackGenerator()
                            generator.notificationOccurred(.success)
                            withAnimation(.spring(response: 0.3)) {
                                copyConfirm = true
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                withAnimation { copyConfirm = false }
                            }
                        } label: {
                            HStack(spacing: 6) {
                                Image(systemName: copyConfirm ? "checkmark.circle.fill" : "doc.on.doc")
                                Text(copyConfirm ? "Copied!" : "Copy to Use in Love Note")
                            }
                            .font(.system(size: 15, weight: .semibold, design: .rounded))
                            .foregroundStyle(copyConfirm ? .green : .white.opacity(0.8))
                        }
                        .padding(.top, 12)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                    }

                    Spacer().frame(height: 20)
                }
            }
            .toolbar(.hidden, for: .navigationBar)
            .onShake {
                if !isSpinning { spin() }
            }
        }
    }

    // MARK: - Prompt Card (initial state)

    private var promptCard: some View {
        VStack(spacing: 20) {
            Text("\u{1F3B0}")
                .font(.system(size: 80))

            Text("Ready to find out\nyour rizz level?")
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)

            Text("Each spin reveals a pickup line\nrated from Smooth to... legal trouble")
                .font(.system(size: 14, weight: .medium, design: .rounded))
                .foregroundStyle(.white.opacity(0.5))
                .multilineTextAlignment(.center)
        }
        .padding(32)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 24)
                        .strokeBorder(
                            LinearGradient(
                                colors: [.purple.opacity(0.5), .pink.opacity(0.3)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
        )
        .padding(.horizontal, 24)
    }

    // MARK: - Spinning View

    private var spinningView: some View {
        VStack(spacing: 16) {
            Text(cycleLines.isEmpty ? "\u{1F3B0}" : cycleLines[cycleIndex % cycleLines.count].emoji)
                .font(.system(size: 64))
                .scaleEffect(1.2)
                .animation(.easeInOut(duration: 0.08), value: cycleIndex)

            Text(cycleLines.isEmpty ? "..." : cycleLines[cycleIndex % cycleLines.count].text)
                .font(.system(size: 18, weight: .semibold, design: .rounded))
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)
                .lineLimit(3)
                .frame(height: 80)
                .animation(.easeInOut(duration: 0.08), value: cycleIndex)
        }
        .padding(32)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 24)
                        .strokeBorder(
                            LinearGradient(
                                colors: [.yellow.opacity(0.6), .orange.opacity(0.4), .red.opacity(0.6)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 2
                        )
                )
        )
        .padding(.horizontal, 24)
    }

    // MARK: - Result Card

    private func resultCard(line: PickupLine) -> some View {
        VStack(spacing: 16) {
            // Rizz level badge
            HStack(spacing: 6) {
                Text(line.rizzLevel.emoji)
                    .font(.system(size: 18))
                Text(line.rizzLevel.label.uppercased())
                    .font(.system(size: 14, weight: .black, design: .rounded))
                    .foregroundStyle(rizzColor(for: line.rizzLevel))
                Text(line.rizzLevel.emoji)
                    .font(.system(size: 18))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(
                Capsule()
                    .fill(rizzColor(for: line.rizzLevel).opacity(0.15))
                    .overlay(
                        Capsule()
                            .strokeBorder(rizzColor(for: line.rizzLevel).opacity(0.4), lineWidth: 1)
                    )
            )

            // Rizz meter
            rizzMeter(level: line.rizzLevel)

            // Emoji
            Text(line.emoji)
                .font(.system(size: 52))

            // The pickup line
            Text("\"\(line.text)\"")
                .font(.system(size: 18, weight: .medium, design: .serif))
                .italic()
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)
                .lineSpacing(4)
                .padding(.horizontal, 8)

            // Fire rating
            HStack(spacing: 4) {
                ForEach(0..<5, id: \.self) { i in
                    Text(i < line.rizzLevel.rawValue ? "\u{1F525}" : "\u{1F9CA}")
                        .font(.system(size: 24))
                        .scaleEffect(flameScale)
                }
            }
            .onAppear {
                withAnimation(.easeInOut(duration: 0.4).repeatForever(autoreverses: true)) {
                    flameScale = 1.15
                }
            }
        }
        .padding(28)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 24)
                        .strokeBorder(
                            LinearGradient(
                                colors: [
                                    rizzColor(for: line.rizzLevel).opacity(0.6),
                                    rizzColor(for: line.rizzLevel).opacity(0.2)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 2
                        )
                )
        )
        .padding(.horizontal, 24)
    }

    // MARK: - Rizz Meter

    private func rizzMeter(level: PickupLine.RizzLevel) -> some View {
        VStack(spacing: 4) {
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    // Track
                    Capsule()
                        .fill(.white.opacity(0.1))
                        .frame(height: 8)

                    // Fill
                    Capsule()
                        .fill(
                            LinearGradient(
                                colors: [.green, .yellow, .orange, .red, .purple],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: geo.size.width * CGFloat(level.rawValue) / 5.0, height: 8)
                        .animation(.spring(response: 0.6, dampingFraction: 0.7), value: level.rawValue)
                }
            }
            .frame(height: 8)

            // Labels
            HStack {
                Text("Smooth")
                    .font(.system(size: 9, weight: .medium, design: .rounded))
                    .foregroundStyle(.green.opacity(0.7))
                Spacer()
                Text("Jail Time")
                    .font(.system(size: 9, weight: .medium, design: .rounded))
                    .foregroundStyle(.purple.opacity(0.7))
            }
        }
        .padding(.horizontal, 8)
    }

    // MARK: - Floating Emojis Background

    private var floatingEmojis: some View {
        ZStack {
            ForEach(0..<10, id: \.self) { i in
                let emojis = ["\u{1F525}", "\u{1F48B}", "\u{1F60E}", "\u{2764}\u{FE0F}", "\u{1F525}", "\u{1F4AF}", "\u{1F389}", "\u{1F451}", "\u{1F48E}", "\u{1F31F}"]
                Text(emojis[i])
                    .font(.system(size: CGFloat.random(in: 16...30)))
                    .opacity(0.12)
                    .offset(
                        x: CGFloat([-140, 120, -80, 150, -110, 90, -50, 130, -100, 60][i]),
                        y: CGFloat([-300, -220, -100, -40, 50, 120, 200, 260, -170, 160][i])
                    )
            }
        }
        .allowsHitTesting(false)
    }

    // MARK: - Helpers

    private func rizzColor(for level: PickupLine.RizzLevel) -> Color {
        switch level {
        case .smooth: return .green
        case .charming: return .mint
        case .bold: return .orange
        case .downBad: return .pink
        case .restrainingOrder: return .purple
        }
    }

    private func spin() {
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred()

        withAnimation(.spring(response: 0.3)) {
            showLine = false
            isSpinning = true
            copyConfirm = false
        }

        withAnimation(.linear(duration: 0.5).repeatForever(autoreverses: false)) {
            spinRotation += 360
        }

        // Rapid cycling through random lines
        cycleLines = PickupLine.all.shuffled()
        cycleIndex = 0

        // Cycle animation - starts fast, slows down
        let totalCycles = 20
        var delay: Double = 0

        for i in 0..<totalCycles {
            let interval = 0.06 + Double(i) * 0.02 // speeds up the slowdown
            delay += interval

            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                cycleIndex = i
                let tick = UIImpactFeedbackGenerator(style: i < totalCycles - 3 ? .light : .medium)
                tick.impactOccurred()
            }
        }

        // Final result
        DispatchQueue.main.asyncAfter(deadline: .now() + delay + 0.3) {
            let finalLine = PickupLine.random()
            let finalGenerator = UINotificationFeedbackGenerator()

            withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) {
                currentLine = finalLine
                isSpinning = false
                showLine = true
                spinRotation = 0
                flameScale = 1.0
            }

            finalGenerator.notificationOccurred(
                finalLine.rizzLevel.rawValue >= 4 ? .warning : .success
            )
        }
    }
}

// MARK: - Shake Detection

struct ShakeDetector: UIViewRepresentable {
    class ShakeView: UIView {
        var onShake: (() -> Void)?

        override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
            if motion == .motionShake {
                onShake?()
            }
        }

        override var canBecomeFirstResponder: Bool { true }
    }

    func makeUIView(context: Context) -> ShakeView {
        let view = ShakeView()
        return view
    }

    func updateUIView(_ uiView: ShakeView, context: Context) {}
}

// Shake gesture modifier
struct ShakeGestureModifier: ViewModifier {
    let action: () -> Void

    func body(content: Content) -> some View {
        content
            .background(ShakeDetectorView(onShake: action))
    }
}

struct ShakeDetectorView: UIViewControllerRepresentable {
    let onShake: () -> Void

    func makeUIViewController(context: Context) -> ShakeDetectorViewController {
        let vc = ShakeDetectorViewController()
        vc.onShake = onShake
        return vc
    }

    func updateUIViewController(_ uiViewController: ShakeDetectorViewController, context: Context) {
        uiViewController.onShake = onShake
    }
}

class ShakeDetectorViewController: UIViewController {
    var onShake: (() -> Void)?

    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            onShake?()
        }
    }

    override var canBecomeFirstResponder: Bool { true }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        becomeFirstResponder()
    }
}

extension View {
    func onShake(perform action: @escaping () -> Void) -> some View {
        modifier(ShakeGestureModifier(action: action))
    }
}
