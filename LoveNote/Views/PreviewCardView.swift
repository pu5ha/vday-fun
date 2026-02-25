import SwiftUI

struct PreviewCardView: View {
    @Bindable var viewModel: ComposeViewModel
    @EnvironmentObject var messageStore: MessageStore
    @Environment(\.dismiss) private var dismiss
    @State private var showSuccess = false

    var body: some View {
        ZStack {
            GradientBackground(style: .soft)

            VStack(spacing: 20) {
                Text("Your Love Note")
                    .font(ValentineTheme.headlineFont)
                    .foregroundStyle(ValentineTheme.textPrimary)

                // Card preview
                CardDesignView(message: viewModel.buildMessage())
                    .frame(width: 320, height: 440)
                    .shadow(color: ValentineTheme.softPink.opacity(0.4), radius: 16, y: 8)

                // Action buttons
                HStack(spacing: 16) {
                    Button {
                        dismiss()
                    } label: {
                        HStack(spacing: 6) {
                            Image(systemName: "pencil")
                            Text("Edit")
                        }
                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                        .foregroundStyle(ValentineTheme.roseRed)
                        .padding(.vertical, 14)
                        .padding(.horizontal, 32)
                        .background(
                            Capsule()
                                .strokeBorder(ValentineTheme.roseRed, lineWidth: 2)
                        )
                    }

                    Button {
                        shareCard()
                    } label: {
                        HStack(spacing: 6) {
                            Image(systemName: "paperplane.fill")
                            Text("Share")
                        }
                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                        .foregroundStyle(.white)
                        .padding(.vertical, 14)
                        .padding(.horizontal, 32)
                        .background(ValentineTheme.buttonGradient)
                        .clipShape(Capsule())
                        .shadow(color: ValentineTheme.roseRed.opacity(0.4), radius: 6, y: 3)
                    }
                }
                .padding(.top, 8)
            }
            .padding()

            // Success overlay
            if showSuccess {
                successOverlay
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }

    private func shareCard() {
        let message = viewModel.buildMessage()
        guard let image = CardRenderer.render(message: message) else { return }

        ShareHelper.share(image: image) { completed in
            if completed {
                let savedMessage = LoveMessage(
                    id: message.id,
                    recipientName: message.recipientName,
                    messageBody: message.messageBody,
                    templateUsed: message.templateUsed,
                    cardStyle: message.cardStyle,
                    createdAt: message.createdAt,
                    wasSent: true
                )
                messageStore.save(savedMessage)
                withAnimation(.spring()) {
                    showSuccess = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    viewModel.reset()
                    dismiss()
                }
            }
        }
    }

    private var successOverlay: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()

            VStack(spacing: 16) {
                Image(systemName: "heart.circle.fill")
                    .font(.system(size: 64))
                    .foregroundStyle(ValentineTheme.roseRed)
                    .symbolEffect(.bounce, value: showSuccess)

                Text("Love Note Sent!")
                    .font(ValentineTheme.headlineFont)
                    .foregroundStyle(.white)

                Text("Your anonymous message is on its way")
                    .font(ValentineTheme.captionFont)
                    .foregroundStyle(.white.opacity(0.8))
            }
            .padding(40)
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .fill(.ultraThinMaterial)
            )
            .transition(.scale.combined(with: .opacity))
        }
    }
}
