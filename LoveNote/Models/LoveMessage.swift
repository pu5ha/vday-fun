import Foundation

struct LoveMessage: Identifiable, Codable {
    let id: UUID
    var recipientName: String
    var messageBody: String
    var templateUsed: String?
    var cardStyle: CardStyle
    var createdAt: Date
    var wasSent: Bool

    enum CardStyle: String, Codable, CaseIterable, Identifiable {
        case classicRed
        case pinkGradient
        case roseGold
        case darkRomance
        case playful

        var id: String { rawValue }

        var displayName: String {
            switch self {
            case .classicRed: return "Classic Red"
            case .pinkGradient: return "Pink Gradient"
            case .roseGold: return "Rose Gold"
            case .darkRomance: return "Dark Romance"
            case .playful: return "Playful"
            }
        }

        var emoji: String {
            switch self {
            case .classicRed: return "\u{2764}\u{FE0F}"
            case .pinkGradient: return "\u{1F495}"
            case .roseGold: return "\u{1F339}"
            case .darkRomance: return "\u{1F5A4}"
            case .playful: return "\u{1F49D}"
            }
        }
    }
}
