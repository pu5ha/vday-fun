import SwiftUI

@Observable
class ComposeViewModel {
    var recipientName: String = ""
    var messageBody: String = ""
    var selectedTemplate: MessageTemplate?
    var cardStyle: LoveMessage.CardStyle = .classicRed

    var isValid: Bool {
        !recipientName.trimmingCharacters(in: .whitespaces).isEmpty &&
        !messageBody.trimmingCharacters(in: .whitespaces).isEmpty
    }

    func buildMessage() -> LoveMessage {
        LoveMessage(
            id: UUID(),
            recipientName: recipientName.trimmingCharacters(in: .whitespaces),
            messageBody: messageBody.trimmingCharacters(in: .whitespaces),
            templateUsed: selectedTemplate?.text,
            cardStyle: cardStyle,
            createdAt: Date(),
            wasSent: false
        )
    }

    func applyTemplate(_ template: MessageTemplate) {
        selectedTemplate = template
        messageBody = template.text
    }

    func reset() {
        recipientName = ""
        messageBody = ""
        selectedTemplate = nil
        cardStyle = .classicRed
    }
}
