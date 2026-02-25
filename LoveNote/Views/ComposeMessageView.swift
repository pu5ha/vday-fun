import SwiftUI

struct ComposeMessageView: View {
    @EnvironmentObject var messageStore: MessageStore
    @State private var viewModel = ComposeViewModel()
    @State private var showPreview = false
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            GradientBackground(style: .soft)

            ScrollView {
                VStack(spacing: 24) {
                    // Recipient section
                    recipientSection

                    // Message section
                    messageSection

                    // Card style picker
                    cardStyleSection

                    // Preview button
                    if viewModel.isValid {
                        Button {
                            showPreview = true
                        } label: {
                            HStack(spacing: 10) {
                                Image(systemName: "eye.fill")
                                Text("Preview Card")
                            }
                            .font(.system(size: 17, weight: .semibold, design: .rounded))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(ValentineTheme.buttonGradient)
                            .clipShape(Capsule())
                            .shadow(color: ValentineTheme.roseRed.opacity(0.4), radius: 8, y: 4)
                        }
                        .padding(.horizontal, 24)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                    }
                }
                .padding(.vertical, 20)
            }
        }
        .navigationTitle("Compose")
        .navigationBarTitleDisplayMode(.inline)
        .animation(.spring(response: 0.4), value: viewModel.isValid)
        .navigationDestination(isPresented: $showPreview) {
            PreviewCardView(viewModel: viewModel)
        }
    }

    // MARK: - Recipient Section

    private var recipientSection: some View {
        NavigationLink {
            RecipientEntryView(recipientName: $viewModel.recipientName)
        } label: {
            HStack {
                Image(systemName: "person.heart.fill")
                    .font(.system(size: 20))
                    .foregroundStyle(ValentineTheme.roseRed)

                if viewModel.recipientName.isEmpty {
                    Text("Tap to enter recipient name")
                        .font(ValentineTheme.bodyFont)
                        .foregroundStyle(ValentineTheme.textSecondary)
                } else {
                    Text("To: \(viewModel.recipientName)")
                        .font(.system(size: 18, weight: .medium, design: .serif))
                        .foregroundStyle(ValentineTheme.textPrimary)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(ValentineTheme.softPink)
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(.white)
                    .shadow(color: ValentineTheme.softPink.opacity(0.15), radius: 6, y: 3)
            )
        }
        .padding(.horizontal, 16)
    }

    // MARK: - Message Section

    private var messageSection: some View {
        VStack(spacing: 12) {
            HStack {
                Text("Your Message")
                    .font(.system(size: 15, weight: .semibold, design: .serif))
                    .foregroundStyle(ValentineTheme.textPrimary)

                Spacer()

                NavigationLink {
                    TemplatePickerView { template in
                        viewModel.applyTemplate(template)
                    }
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "sparkles")
                        Text("Get Inspired")
                    }
                    .font(.system(size: 13, weight: .semibold, design: .rounded))
                    .foregroundStyle(ValentineTheme.roseRed)
                }
            }
            .padding(.horizontal, 16)

            TextEditor(text: $viewModel.messageBody)
                .font(.system(size: 16, weight: .regular, design: .serif))
                .frame(minHeight: 120)
                .scrollContentBackground(.hidden)
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.white)
                        .shadow(color: ValentineTheme.softPink.opacity(0.15), radius: 6, y: 3)
                )
                .overlay(
                    Group {
                        if viewModel.messageBody.isEmpty {
                            Text("Write something from the heart...")
                                .font(.system(size: 16, weight: .regular, design: .serif))
                                .foregroundStyle(ValentineTheme.textSecondary.opacity(0.5))
                                .padding(20)
                                .allowsHitTesting(false)
                        }
                    },
                    alignment: .topLeading
                )
                .padding(.horizontal, 16)
        }
    }

    // MARK: - Card Style Picker

    private var cardStyleSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Card Style")
                .font(.system(size: 15, weight: .semibold, design: .serif))
                .foregroundStyle(ValentineTheme.textPrimary)
                .padding(.horizontal, 16)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(LoveMessage.CardStyle.allCases) { style in
                        Button {
                            withAnimation(.spring(response: 0.3)) {
                                viewModel.cardStyle = style
                            }
                        } label: {
                            VStack(spacing: 8) {
                                stylePreview(for: style)
                                    .frame(width: 80, height: 110)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .strokeBorder(
                                                viewModel.cardStyle == style
                                                    ? ValentineTheme.roseRed
                                                    : Color.clear,
                                                lineWidth: 2.5
                                            )
                                    )
                                    .shadow(
                                        color: viewModel.cardStyle == style
                                            ? ValentineTheme.roseRed.opacity(0.3)
                                            : .clear,
                                        radius: 6, y: 3
                                    )

                                Text(style.displayName)
                                    .font(.system(size: 11, weight: .medium, design: .rounded))
                                    .foregroundStyle(
                                        viewModel.cardStyle == style
                                            ? ValentineTheme.roseRed
                                            : ValentineTheme.textSecondary
                                    )
                            }
                        }
                    }
                }
                .padding(.horizontal, 16)
            }
        }
    }

    @ViewBuilder
    private func stylePreview(for style: LoveMessage.CardStyle) -> some View {
        switch style {
        case .classicRed:
            ZStack {
                ValentineTheme.deepRed
                VStack(spacing: 4) {
                    Image(systemName: "heart.fill")
                        .foregroundStyle(ValentineTheme.gold)
                    miniLines(color: .white)
                }
            }
        case .pinkGradient:
            ZStack {
                LinearGradient(
                    colors: [ValentineTheme.hotPink, ValentineTheme.blushPink],
                    startPoint: .top, endPoint: .bottom
                )
                VStack(spacing: 4) {
                    Image(systemName: "heart.fill")
                        .foregroundStyle(.white)
                    miniLines(color: ValentineTheme.darkBurgundy)
                }
            }
        case .roseGold:
            ZStack {
                ValentineTheme.cream
                RoundedRectangle(cornerRadius: 6)
                    .strokeBorder(ValentineTheme.gold, lineWidth: 1)
                    .padding(6)
                VStack(spacing: 4) {
                    Image(systemName: "heart.fill")
                        .foregroundStyle(ValentineTheme.gold)
                    miniLines(color: ValentineTheme.textPrimary)
                }
            }
        case .darkRomance:
            ZStack {
                Color(red: 0.10, green: 0.02, blue: 0.05)
                VStack(spacing: 4) {
                    Image(systemName: "heart.fill")
                        .foregroundStyle(ValentineTheme.roseRed)
                    miniLines(color: ValentineTheme.softPink)
                }
            }
        case .playful:
            ZStack {
                ValentineTheme.hotPink
                VStack(spacing: 4) {
                    Text("\u{1F496}")
                    miniLines(color: .white)
                }
            }
        }
    }

    private func miniLines(color: Color) -> some View {
        VStack(spacing: 3) {
            RoundedRectangle(cornerRadius: 1)
                .fill(color.opacity(0.6))
                .frame(width: 36, height: 2)
            RoundedRectangle(cornerRadius: 1)
                .fill(color.opacity(0.4))
                .frame(width: 28, height: 2)
            RoundedRectangle(cornerRadius: 1)
                .fill(color.opacity(0.3))
                .frame(width: 20, height: 2)
        }
    }
}
