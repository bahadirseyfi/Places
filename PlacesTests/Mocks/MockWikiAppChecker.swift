@testable import Places

final class MockWikiAppChecker: WikiAppCheckerProtocol, @unchecked Sendable {
    var available = true
    func isAvailable() -> Bool { available }
}
