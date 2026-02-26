import Foundation

struct PickupLine: Identifiable {
    let id = UUID()
    let text: String
    let rizzLevel: RizzLevel
    let emoji: String

    enum RizzLevel: Int, CaseIterable {
        case smooth = 1
        case charming = 2
        case bold = 3
        case downBad = 4
        case restrainingOrder = 5

        var label: String {
            switch self {
            case .smooth: return "Smooth"
            case .charming: return "Charming"
            case .bold: return "Bold"
            case .downBad: return "Down Bad"
            case .restrainingOrder: return "Restraining Order"
            }
        }

        var emoji: String {
            switch self {
            case .smooth: return "\u{1F60E}"
            case .charming: return "\u{1F609}"
            case .bold: return "\u{1F525}"
            case .downBad: return "\u{1F62D}"
            case .restrainingOrder: return "\u{1F6A8}"
            }
        }

        var color: String {
            rawValue.description
        }
    }

    static let all: [PickupLine] = [
        // Smooth (1)
        PickupLine(text: "Do you have a map? I just got lost in your eyes.", rizzLevel: .smooth, emoji: "\u{1F5FA}"),
        PickupLine(text: "I must be a snowflake, because I've fallen for you.", rizzLevel: .smooth, emoji: "\u{2744}\u{FE0F}"),
        PickupLine(text: "Are you a time traveler? Because I can see you in my future.", rizzLevel: .smooth, emoji: "\u{231A}"),
        PickupLine(text: "Is your name Google? Because you have everything I've been searching for.", rizzLevel: .smooth, emoji: "\u{1F50D}"),
        PickupLine(text: "If beauty were time, you'd be an eternity.", rizzLevel: .smooth, emoji: "\u{2728}"),

        // Charming (2)
        PickupLine(text: "Are you a parking ticket? Because you've got 'fine' written all over you.", rizzLevel: .charming, emoji: "\u{1F697}"),
        PickupLine(text: "Do you believe in love at first sight, or should I walk by again?", rizzLevel: .charming, emoji: "\u{1F6B6}"),
        PickupLine(text: "I'm not a photographer, but I can picture us together.", rizzLevel: .charming, emoji: "\u{1F4F8}"),
        PickupLine(text: "If you were a fruit, you'd be a fineapple.", rizzLevel: .charming, emoji: "\u{1F34D}"),
        PickupLine(text: "Are you Wi-Fi? Because I'm feeling a connection.", rizzLevel: .charming, emoji: "\u{1F4F6}"),

        // Bold (3)
        PickupLine(text: "Are you a bank loan? Because you've got my interest.", rizzLevel: .bold, emoji: "\u{1F4B0}"),
        PickupLine(text: "Do you have a Band-Aid? I just scraped my knee falling for you.", rizzLevel: .bold, emoji: "\u{1FA79}"),
        PickupLine(text: "Is your dad a boxer? Because you're a knockout.", rizzLevel: .bold, emoji: "\u{1F94A}"),
        PickupLine(text: "I'd say God bless you, but it looks like he already did.", rizzLevel: .bold, emoji: "\u{1F607}"),
        PickupLine(text: "You must be tired because you've been running through my mind all day.", rizzLevel: .bold, emoji: "\u{1F3C3}"),

        // Down Bad (4)
        PickupLine(text: "I wrote your name in the sky, but the clouds blew it away. I wrote your name in the sand, but the waves washed it away. So I wrote your name in my heart, and nothing can take it away.", rizzLevel: .downBad, emoji: "\u{1F62D}"),
        PickupLine(text: "I'd rearrange the alphabet to put U and I together.", rizzLevel: .downBad, emoji: "\u{1F524}"),
        PickupLine(text: "If I had a star for every time you brightened my day, I'd have the entire galaxy.", rizzLevel: .downBad, emoji: "\u{1F30C}"),
        PickupLine(text: "I'm not drunk, I'm just intoxicated by you.", rizzLevel: .downBad, emoji: "\u{1F943}"),
        PickupLine(text: "Can you touch my hand? I want to tell my friends I was touched by an angel.", rizzLevel: .downBad, emoji: "\u{1F47C}"),

        // Restraining Order (5)
        PickupLine(text: "I seem to have lost my phone number. Can I have yours? Also my keys, my wallet, and all sense of dignity.", rizzLevel: .restrainingOrder, emoji: "\u{1F4F1}"),
        PickupLine(text: "Are you a campfire? Because you're hot and I want s'more. I'll bring the tent. I already know where you live.", rizzLevel: .restrainingOrder, emoji: "\u{1F3D5}"),
        PickupLine(text: "I'm learning about important dates in history. Wanna be one? I've already cleared my calendar. For the next 50 years.", rizzLevel: .restrainingOrder, emoji: "\u{1F4C5}"),
        PickupLine(text: "Do you have a sunburn, or are you always this hot? Don't answer. I've been watching long enough to know.", rizzLevel: .restrainingOrder, emoji: "\u{2600}\u{FE0F}"),
        PickupLine(text: "I must be a squirrel because I want to hoard you for winter. And spring. And summer. And fall. Forever.", rizzLevel: .restrainingOrder, emoji: "\u{1F43F}\u{FE0F}"),
    ]

    static func random() -> PickupLine {
        all.randomElement()!
    }
}
