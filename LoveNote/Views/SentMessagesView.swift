import SwiftUI

struct SentMessagesView: View {
    @EnvironmentObject var messageStore: MessageStore
    @State private var selectedMessage: LoveMessage?

    var body: some View {
        NavigationStack {
            ZStack {
                GradientBackground(style: .soft)

                if messageStore.messages.isEmpty {
                    emptyState
                } else {
                    messageList
                }
            }
            .navigationTitle("My Notes")
            .navigationBarTitleDisplayMode(.large)
            .sheet(item: $selectedMessage) { message in
                NavigationStack {
                    ScrollView {
                        VStack(spacing: 20) {
                            CardDesignView(message: message)
                                .frame(width: 320, height: 440)
                                .shadow(color: ValentineTheme.softPink.opacity(0.3), radius: 12, y: 6)

                            HStack(spacing: 8) {
                                Image(systemName: message.wasSent ? "checkmark.circle.fill" : "clock")
                                    .foregroundStyle(message.wasSent ? .green : .orange)
                                Text(message.wasSent ? "Sent" : "Draft")
                                    .font(ValentineTheme.captionFont)
                                    .foregroundStyle(ValentineTheme.textSecondary)
                            }
                        }
                        .padding(.top, 20)
                    }
                    .background(GradientBackground(style: .soft))
                    .navigationTitle("Love Note")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            Button("Done") {
                                selectedMessage = nil
                            }
                        }
                    }
                }
            }
        }
    }

    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "envelope.heart.fill")
                .font(.system(size: 56))
                .foregroundStyle(ValentineTheme.softPink)

            Text("No love notes yet")
                .font(ValentineTheme.headlineFont)
                .foregroundStyle(ValentineTheme.textPrimary)

            Text("Your sent love notes will appear here")
                .font(ValentineTheme.captionFont)
                .foregroundStyle(ValentineTheme.textSecondary)
        }
    }

    private var messageList: some View {
        List {
            ForEach(messageStore.messages) { message in
                Button {
                    selectedMessage = message
                } label: {
                    HStack(spacing: 14) {
                        // Style indicator
                        Circle()
                            .fill(styleColor(for: message.cardStyle))
                            .frame(width: 44, height: 44)
                            .overlay(
                                Text(message.cardStyle.emoji)
                                    .font(.system(size: 20))
                            )

                        VStack(alignment: .leading, spacing: 4) {
                            Text("To: \(message.recipientName)")
                                .font(.system(size: 16, weight: .semibold, design: .serif))
                                .foregroundStyle(ValentineTheme.textPrimary)

                            Text(message.messageBody)
                                .font(.system(size: 14, weight: .regular, design: .serif))
                                .foregroundStyle(ValentineTheme.textSecondary)
                                .lineLimit(2)
                        }

                        Spacer()

                        VStack(alignment: .trailing, spacing: 4) {
                            Text(message.createdAt, style: .date)
                                .font(.system(size: 11))
                                .foregroundStyle(ValentineTheme.textSecondary)

                            if message.wasSent {
                                Image(systemName: "checkmark.circle.fill")
                                    .font(.system(size: 14))
                                    .foregroundStyle(.green)
                            }
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
            .onDelete { indexSet in
                for index in indexSet {
                    messageStore.delete(messageStore.messages[index].id)
                }
            }
            .listRowBackground(
                RoundedRectangle(cornerRadius: 12)
                    .fill(.white)
                    .padding(.vertical, 2)
                    .padding(.horizontal, 4)
            )
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
    }

    private func styleColor(for style: LoveMessage.CardStyle) -> Color {
        switch style {
        case .classicRed: return ValentineTheme.deepRed
        case .pinkGradient: return ValentineTheme.hotPink
        case .roseGold: return ValentineTheme.gold
        case .darkRomance: return ValentineTheme.darkBurgundy
        case .playful: return ValentineTheme.hotPink
        }
    }
}
