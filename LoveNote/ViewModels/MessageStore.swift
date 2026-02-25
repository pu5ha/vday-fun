import SwiftUI

class MessageStore: ObservableObject {
    @Published var messages: [LoveMessage] = []

    init() {
        messages = PersistenceService.load()
    }

    func save(_ message: LoveMessage) {
        messages.insert(message, at: 0)
        PersistenceService.save(messages)
    }

    func markAsSent(_ id: UUID) {
        if let index = messages.firstIndex(where: { $0.id == id }) {
            messages[index].wasSent = true
            PersistenceService.save(messages)
        }
    }

    func delete(_ id: UUID) {
        messages.removeAll { $0.id == id }
        PersistenceService.save(messages)
    }
}
