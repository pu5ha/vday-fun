import SwiftUI
import UIKit

enum ShareHelper {
    @MainActor
    static func share(image: UIImage, completion: @escaping (Bool) -> Void) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootVC = windowScene.windows.first?.rootViewController else {
            completion(false)
            return
        }

        // Walk up to the topmost presented controller
        var topVC = rootVC
        while let presented = topVC.presentedViewController {
            topVC = presented
        }

        let ac = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        ac.completionWithItemsHandler = { _, completed, _, _ in
            completion(completed)
        }

        // iPad support
        if let popover = ac.popoverPresentationController {
            popover.sourceView = topVC.view
            popover.sourceRect = CGRect(x: topVC.view.bounds.midX, y: topVC.view.bounds.midY, width: 0, height: 0)
            popover.permittedArrowDirections = []
        }

        topVC.present(ac, animated: true)
    }
}
