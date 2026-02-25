import Foundation

struct Recipient: Identifiable, Codable, Hashable {
    let id: UUID
    var name: String
    var lastUsed: Date?

    init(id: UUID = UUID(), name: String, lastUsed: Date? = nil) {
        self.id = id
        self.name = name
        self.lastUsed = lastUsed
    }
}
