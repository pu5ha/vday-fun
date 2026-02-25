import SwiftUI

struct CardRenderer {
    @MainActor
    static func render(message: LoveMessage) -> UIImage? {
        let cardView = CardDesignView(message: message)
            .frame(width: 375, height: 520)

        let renderer = ImageRenderer(content: cardView)
        renderer.scale = 3.0
        return renderer.uiImage
    }
}
