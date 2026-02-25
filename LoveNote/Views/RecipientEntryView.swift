import SwiftUI

struct RecipientEntryView: View {
    @Binding var recipientName: String
    @Environment(\.dismiss) private var dismiss
    @FocusState private var isFocused: Bool

    var body: some View {
        ZStack {
            GradientBackground(style: .soft)

            VStack(spacing: 32) {
                // Header
                VStack(spacing: 8) {
                    Image(systemName: "person.heart.fill")
                        .font(.system(size: 48))
                        .foregroundStyle(ValentineTheme.roseRed)

                    Text("Who is this for?")
                        .font(ValentineTheme.headlineFont)
                        .foregroundStyle(ValentineTheme.textPrimary)

                    Text("Enter the name of your special someone")
                        .font(ValentineTheme.captionFont)
                        .foregroundStyle(ValentineTheme.textSecondary)
                }
                .padding(.top, 40)

                // Name input
                VStack(spacing: 12) {
                    TextField("Their name...", text: $recipientName)
                        .font(.system(size: 22, weight: .medium, design: .serif))
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
                        .focused($isFocused)
                        .padding(.horizontal, 32)
                }

                // Done button
                if !recipientName.trimmingCharacters(in: .whitespaces).isEmpty {
                    Button {
                        dismiss()
                    } label: {
                        Text("Done")
                            .font(.system(size: 17, weight: .semibold, design: .rounded))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(ValentineTheme.buttonGradient)
                            .clipShape(Capsule())
                    }
                    .padding(.horizontal, 48)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }

                Spacer()
            }
        }
        .animation(.spring(response: 0.4), value: recipientName.isEmpty)
        .onAppear {
            isFocused = true
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}
