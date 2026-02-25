import Foundation

struct PersistenceService {
    private static let fileName = "lovenote_messages.json"

    private static var fileURL: URL {
        FileManager.default
            .urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent(fileName)
    }

    static func load() -> [LoveMessage] {
        guard FileManager.default.fileExists(atPath: fileURL.path) else {
            return []
        }
        do {
            let data = try Data(contentsOf: fileURL)
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            return try decoder.decode([LoveMessage].self, from: data)
        } catch {
            print("Failed to load messages: \(error)")
            return []
        }
    }

    static func save(_ messages: [LoveMessage]) {
        do {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            encoder.outputFormatting = .prettyPrinted
            let data = try encoder.encode(messages)
            try data.write(to: fileURL, options: .atomic)
        } catch {
            print("Failed to save messages: \(error)")
        }
    }
}
