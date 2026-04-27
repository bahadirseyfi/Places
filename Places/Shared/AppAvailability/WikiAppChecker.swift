import UIKit

final class WikiAppChecker: WikiAppCheckerProtocol {
    private let wikiURL = URL(string: "wikipedia://")!

    func isAvailable() -> Bool {
        UIApplication.shared.canOpenURL(wikiURL)
    }
}
