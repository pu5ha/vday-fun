import SwiftUI
import UIKit

struct LetterPrompt: Identifiable {
    let id = UUID()
    let question: String
    let placeholder: String
    let emoji: String
}

struct LoveLetterBuilderView: View {
    @State private var recipientName = ""
    @State private var answers: [String]
    @State private var currentStep = 0
    @State private var showLetter = false
    @State private var letterStyle: LetterStyle = .heartfelt

    enum LetterStyle: String, CaseIterable, Identifiable {
        case heartfelt
        case poetic
        case playful

        var id: String { rawValue }

        var label: String {
            switch self {
            case .heartfelt: return "Heartfelt"
            case .poetic: return "Poetic"
            case .playful: return "Playful"
            }
        }

        var emoji: String {
            switch self {
            case .heartfelt: return "\u{1F497}"
            case .poetic: return "\u{1F339}"
            case .playful: return "\u{1F60A}"
            }
        }
    }

    static let prompts: [LetterPrompt] = [
        LetterPrompt(question: "What's their name?", placeholder: "Their name...", emoji: "\u{1F495}"),
        LetterPrompt(question: "What's your favorite memory together?", placeholder: "That time we...", emoji: "\u{1F4F8}"),
        LetterPrompt(question: "What do they do that makes you smile?", placeholder: "The way they...", emoji: "\u{1F60A}"),
        LetterPrompt(question: "What do you love most about them?", placeholder: "I love that you...", emoji: "\u{2764}\u{FE0F}"),
        LetterPrompt(question: "What do you want them to know?", placeholder: "I want you to know that...", emoji: "\u{1F4AC}"),
        LetterPrompt(question: "What do you wish for your future together?", placeholder: "I hope we...", emoji: "\u{1F320}"),
    ]

    init() {
        _answers = State(initialValue: Array(repeating: "", count: Self.prompts.count))
    }

    private var isNameStep: Bool { currentStep == 0 }
    private var totalSteps: Int { Self.prompts.count }
    private var currentPrompt: LetterPrompt { Self.prompts[currentStep] }
    private var currentAnswer: Binding<String> {
        Binding(
            get: { currentStep == 0 ? recipientName : answers[currentStep] },
            set: { newValue in
                if currentStep == 0 {
                    recipientName = newValue
                } else {
                    answers[currentStep] = newValue
                }
            }
        )
    }
    private var canProceed: Bool {
        !currentAnswer.wrappedValue.trimmingCharacters(in: .whitespaces).isEmpty
    }

    var body: some View {
        NavigationStack {
            ZStack {
                GradientBackground(style: .soft)

                if showLetter {
                    letterResultView
                } else {
                    promptFlowView
                }
            }
            .toolbar(.hidden, for: .navigationBar)
        }
    }

    // MARK: - Prompt Flow

    private var promptFlowView: some View {
        VStack(spacing: 0) {
            // Progress bar
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(ValentineTheme.softPink.opacity(0.3))
                        .frame(height: 6)

                    Capsule()
                        .fill(ValentineTheme.buttonGradient)
                        .frame(width: geo.size.width * CGFloat(currentStep + 1) / CGFloat(totalSteps), height: 6)
                        .animation(.spring(response: 0.4), value: currentStep)
                }
            }
            .frame(height: 6)
            .padding(.horizontal, 24)
            .padding(.top, 16)

            // Step indicator
            Text("Step \(currentStep + 1) of \(totalSteps)")
                .font(.system(size: 12, weight: .semibold, design: .rounded))
                .foregroundStyle(ValentineTheme.textSecondary)
                .padding(.top, 12)

            Spacer()

            // Prompt card
            VStack(spacing: 24) {
                Text(currentPrompt.emoji)
                    .font(.system(size: 56))
                    .id(currentStep) // force re-render for transition

                Text(currentPrompt.question)
                    .font(.system(size: 24, weight: .bold, design: .serif))
                    .foregroundStyle(ValentineTheme.textPrimary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 16)
                    .id("q-\(currentStep)")

                if isNameStep {
                    TextField(currentPrompt.placeholder, text: currentAnswer)
                        .font(.system(size: 20, weight: .medium, design: .serif))
                        .multilineTextAlignment(.center)
                        .padding(.vertical, 16)
                        .padding(.horizontal, 24)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(.white)
                                .shadow(color: ValentineTheme.softPink.opacity(0.3), radius: 8, y: 4)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .strokeBorder(ValentineTheme.softPink, lineWidth: 1.5)
                        )
                        .padding(.horizontal, 32)
                } else {
                    TextEditor(text: currentAnswer)
                        .font(.system(size: 17, weight: .regular, design: .serif))
                        .scrollContentBackground(.hidden)
                        .frame(minHeight: 100, maxHeight: 140)
                        .padding(16)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(.white)
                                .shadow(color: ValentineTheme.softPink.opacity(0.3), radius: 8, y: 4)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .strokeBorder(ValentineTheme.softPink, lineWidth: 1.5)
                        )
                        .overlay(
                            Group {
                                if currentAnswer.wrappedValue.isEmpty {
                                    Text(currentPrompt.placeholder)
                                        .font(.system(size: 17, weight: .regular, design: .serif))
                                        .foregroundStyle(ValentineTheme.textSecondary.opacity(0.4))
                                        .padding(20)
                                        .allowsHitTesting(false)
                                }
                            },
                            alignment: .topLeading
                        )
                        .padding(.horizontal, 24)
                }

                // Style picker (show on last step)
                if currentStep == totalSteps - 1 {
                    VStack(spacing: 8) {
                        Text("Letter Style")
                            .font(.system(size: 13, weight: .semibold, design: .rounded))
                            .foregroundStyle(ValentineTheme.textSecondary)

                        HStack(spacing: 12) {
                            ForEach(LetterStyle.allCases) { style in
                                Button {
                                    withAnimation(.spring(response: 0.3)) {
                                        letterStyle = style
                                    }
                                } label: {
                                    VStack(spacing: 4) {
                                        Text(style.emoji)
                                            .font(.system(size: 24))
                                        Text(style.label)
                                            .font(.system(size: 11, weight: .bold, design: .rounded))
                                    }
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 10)
                                    .background(
                                        Capsule()
                                            .fill(letterStyle == style
                                                ? ValentineTheme.roseRed.opacity(0.15)
                                                : .white
                                            )
                                            .overlay(
                                                Capsule()
                                                    .strokeBorder(
                                                        letterStyle == style
                                                            ? ValentineTheme.roseRed
                                                            : ValentineTheme.softPink.opacity(0.3),
                                                        lineWidth: 1.5
                                                    )
                                            )
                                    )
                                    .foregroundStyle(
                                        letterStyle == style
                                            ? ValentineTheme.roseRed
                                            : ValentineTheme.textSecondary
                                    )
                                }
                            }
                        }
                    }
                }
            }

            Spacer()

            // Navigation buttons
            HStack(spacing: 16) {
                if currentStep > 0 {
                    Button {
                        withAnimation(.spring(response: 0.4)) {
                            currentStep -= 1
                        }
                    } label: {
                        HStack(spacing: 6) {
                            Image(systemName: "chevron.left")
                            Text("Back")
                        }
                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                        .foregroundStyle(ValentineTheme.roseRed)
                        .padding(.vertical, 14)
                        .padding(.horizontal, 24)
                        .background(
                            Capsule()
                                .strokeBorder(ValentineTheme.roseRed, lineWidth: 2)
                        )
                    }
                }

                Button {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    if currentStep < totalSteps - 1 {
                        withAnimation(.spring(response: 0.4)) {
                            currentStep += 1
                        }
                    } else {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                            withAnimation(.spring(response: 0.5)) {
                                showLetter = true
                            }
                        }
                    }
                } label: {
                    HStack(spacing: 6) {
                        Text(currentStep < totalSteps - 1 ? "Next" : "Create Letter")
                        Image(systemName: currentStep < totalSteps - 1 ? "chevron.right" : "heart.fill")
                    }
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .foregroundStyle(.white)
                    .padding(.vertical, 14)
                    .padding(.horizontal, 24)
                    .background(
                        Capsule()
                            .fill(canProceed
                                ? AnyShapeStyle(ValentineTheme.buttonGradient)
                                : AnyShapeStyle(Color.gray.opacity(0.4))
                            )
                    )
                }
                .disabled(!canProceed)
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 24)
        }
    }

    // MARK: - Letter Result

    private var letterResultView: some View {
        VStack(spacing: 0) {
            Spacer().frame(height: 0) // ensure VStack fills space
            // Header
            HStack {
                Button {
                    withAnimation(.spring(response: 0.4)) {
                        showLetter = false
                    }
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                        Text("Edit")
                    }
                    .font(.system(size: 15, weight: .semibold, design: .rounded))
                    .foregroundStyle(ValentineTheme.roseRed)
                }

                Spacer()

                Text("Your Love Letter")
                    .font(.system(size: 17, weight: .bold, design: .serif))
                    .foregroundStyle(ValentineTheme.textPrimary)

                Spacer()

                // Invisible spacer to center title
                Text("Edit").opacity(0)
                    .font(.system(size: 15, weight: .semibold))
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)

            ScrollView {
                VStack(spacing: 20) {
                    // The letter
                    letterCard

                    // Share button
                    Button {
                        shareLetter()
                    } label: {
                        HStack(spacing: 8) {
                            Image(systemName: "paperplane.fill")
                            Text("Send to \(recipientName)")
                        }
                        .font(.system(size: 17, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(ValentineTheme.buttonGradient)
                        .clipShape(Capsule())
                        .shadow(color: ValentineTheme.roseRed.opacity(0.4), radius: 8, y: 4)
                    }
                    .padding(.horizontal, 24)

                    // Start over
                    Button {
                        withAnimation(.spring(response: 0.4)) {
                            resetAll()
                        }
                    } label: {
                        Text("Write Another Letter")
                            .font(.system(size: 14, weight: .semibold, design: .rounded))
                            .foregroundStyle(ValentineTheme.textSecondary)
                    }
                    .padding(.bottom, 24)
                }
                .padding(.top, 16)
            }
        }
    }

    // MARK: - Letter Card

    private var letterCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            // "Dear..."
            Text("Dear \(recipientName),")
                .font(.system(size: 22, weight: .bold, design: .serif))
                .foregroundStyle(ValentineTheme.deepRed)

            // Generated letter text
            Text(generateLetter())
                .font(.system(size: 16, weight: .regular, design: .serif))
                .foregroundStyle(ValentineTheme.textPrimary)
                .lineSpacing(8)

            // Closing
            VStack(alignment: .leading, spacing: 4) {
                Text("With all my love,")
                    .font(.system(size: 16, weight: .medium, design: .serif))
                    .italic()
                    .foregroundStyle(ValentineTheme.textPrimary)

                Text("Your Secret Admirer \u{2764}\u{FE0F}")
                    .font(.system(size: 16, weight: .semibold, design: .serif))
                    .foregroundStyle(ValentineTheme.roseRed)
            }
            .padding(.top, 8)

            // Decorative footer
            HStack {
                Spacer()
                HStack(spacing: 6) {
                    Image(systemName: "heart.fill")
                        .font(.system(size: 10))
                    Text("Happy Valentine's Day")
                        .font(.system(size: 12, weight: .medium, design: .serif))
                    Image(systemName: "heart.fill")
                        .font(.system(size: 10))
                }
                .foregroundStyle(ValentineTheme.softPink)
                Spacer()
            }
            .padding(.top, 8)
        }
        .padding(28)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.white)
                .shadow(color: ValentineTheme.softPink.opacity(0.3), radius: 12, y: 6)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .strokeBorder(ValentineTheme.softPink.opacity(0.3), lineWidth: 1)
        )
        .padding(.horizontal, 16)
    }

    // MARK: - Generate Letter

    private func generateLetter() -> String {
        let memory = answers[1]
        let smile = answers[2]
        let loveMost = answers[3]
        let wantToKnow = answers[4]
        let future = answers[5]
        let name = recipientName

        switch letterStyle {
        case .heartfelt:
            return """
            I've been thinking about you, and I couldn't let this Valentine's Day pass without telling you how I feel.

            One of my favorite memories with you is \(memory.lowercasedFirst). Every time I think about it, it reminds me of how special what we have is.

            You probably don't even realize it, but \(smile.lowercasedFirst). It's one of those little things that makes my whole day better.

            \(name), what I love most about you is that \(loveMost.lowercasedFirst). It's something I never want to take for granted.

            I want you to know that \(wantToKnow.lowercasedFirst). You deserve to hear that more often.

            When I think about the future, \(future.lowercasedFirst). And honestly, I can't imagine it without you in it.
            """

        case .poetic:
            return """
            In the garden of my days, you are the bloom I never expected — the one that changed the entire landscape.

            I carry with me the memory of \(memory.lowercasedFirst), like a pressed flower between the pages of my favorite book.

            There is a quiet magic in the way \(smile.lowercasedFirst) — a spell I never want to break.

            If I were to name the stars, \(name), I would name the brightest one after what I love most about you: \(loveMost.lowercasedFirst).

            Let these words find you softly: \(wantToKnow.lowercasedFirst). Let them settle into the spaces between your heartbeats.

            And for tomorrow, and all the tomorrows after — \(future.lowercasedFirst). That is my wish, written in ink that will not fade.
            """

        case .playful:
            return """
            Okay so here's the thing — I tried to write you a normal Valentine's message but everything I wrote sounded boring compared to how I actually feel about you. So I'm just going to say it.

            Remember \(memory.lowercasedFirst)? Yeah, I think about that literally all the time. No big deal. (It's a very big deal.)

            Also, can we talk about how \(smile.lowercasedFirst)? Because honestly it's unfair how easily you make me happy.

            \(name), I love that \(loveMost.lowercasedFirst). Like, a lot. An embarrassing amount. Don't let it go to your head. (Let it go to your head a little.)

            Anyway, \(wantToKnow.lowercasedFirst). I mean it. For real for real.

            And if I'm being completely honest about the future? \(future.lowercasedFirst). No pressure though. \u{1F60F}
            """
        }
    }

    // MARK: - Share

    private func shareLetter() {
        let letterText = "Dear \(recipientName),\n\n\(generateLetter())\n\nWith all my love,\nYour Secret Admirer \u{2764}\u{FE0F}"

        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootVC = windowScene.windows.first?.rootViewController else { return }

        var topVC = rootVC
        while let presented = topVC.presentedViewController {
            topVC = presented
        }

        let ac = UIActivityViewController(activityItems: [letterText], applicationActivities: nil)
        if let popover = ac.popoverPresentationController {
            popover.sourceView = topVC.view
            popover.sourceRect = CGRect(x: topVC.view.bounds.midX, y: topVC.view.bounds.midY, width: 0, height: 0)
            popover.permittedArrowDirections = []
        }
        topVC.present(ac, animated: true)
    }

    // MARK: - Reset

    private func resetAll() {
        recipientName = ""
        answers = Array(repeating: "", count: Self.prompts.count)
        currentStep = 0
        showLetter = false
        letterStyle = .heartfelt
    }
}

// Helper to lowercase first character without lowercasing the entire string
extension String {
    var lowercasedFirst: String {
        guard let first = self.first else { return self }
        // If it starts with "I " or "I'" keep the I capitalized
        if self.hasPrefix("I ") || self.hasPrefix("I'") { return self }
        return first.lowercased() + self.dropFirst()
    }
}
