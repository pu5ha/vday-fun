import Foundation

struct MessageTemplate: Identifiable {
    let id = UUID()
    let category: Category
    let text: String
    let emoji: String

    enum Category: String, CaseIterable {
        case romantic = "Romantic"
        case sweet = "Sweet"
        case funny = "Funny"
        case poetic = "Poetic"
        case friendship = "Friendship"
    }

    static let all: [MessageTemplate] = [
        // Romantic
        MessageTemplate(category: .romantic, text: "Every love story is beautiful, but ours is my favorite.", emoji: "\u{1F495}"),
        MessageTemplate(category: .romantic, text: "You are my today and all of my tomorrows.", emoji: "\u{1F339}"),
        MessageTemplate(category: .romantic, text: "In a sea of people, my eyes will always search for you.", emoji: "\u{1F440}"),
        MessageTemplate(category: .romantic, text: "I fell in love with you because of a million tiny things you never knew you were doing.", emoji: "\u{2728}"),

        // Sweet
        MessageTemplate(category: .sweet, text: "You make my heart smile.", emoji: "\u{1F60A}"),
        MessageTemplate(category: .sweet, text: "Life is better with you in it.", emoji: "\u{1F338}"),
        MessageTemplate(category: .sweet, text: "You are the reason I believe in love.", emoji: "\u{1F497}"),
        MessageTemplate(category: .sweet, text: "Thinking of you always makes my day brighter.", emoji: "\u{2600}\u{FE0F}"),

        // Funny
        MessageTemplate(category: .funny, text: "Are you a magician? Because whenever I look at you, everyone else disappears.", emoji: "\u{1F3A9}"),
        MessageTemplate(category: .funny, text: "I love you more than pizza. And that's saying a lot.", emoji: "\u{1F355}"),
        MessageTemplate(category: .funny, text: "You're the cheese to my macaroni.", emoji: "\u{1F9C0}"),
        MessageTemplate(category: .funny, text: "If you were a vegetable, you'd be a cute-cumber.", emoji: "\u{1F952}"),

        // Poetic
        MessageTemplate(category: .poetic, text: "If I had a flower for every time you made me smile, I'd walk in an endless garden.", emoji: "\u{1F33A}"),
        MessageTemplate(category: .poetic, text: "You are the poem I never knew how to write and the story I always wanted to read.", emoji: "\u{1F4D6}"),
        MessageTemplate(category: .poetic, text: "My heart is, and always will be, yours.", emoji: "\u{1F49E}"),

        // Friendship
        MessageTemplate(category: .friendship, text: "A friend like you is a treasure beyond measure. Happy Valentine's Day!", emoji: "\u{1F49D}"),
        MessageTemplate(category: .friendship, text: "You make the world a better place just by being you.", emoji: "\u{1F30D}"),
        MessageTemplate(category: .friendship, text: "Here's to the one who always has my back. Love you, friend!", emoji: "\u{1F917}"),
    ]

    static func templates(for category: Category) -> [MessageTemplate] {
        all.filter { $0.category == category }
    }
}
