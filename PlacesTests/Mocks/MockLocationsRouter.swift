import Foundation
@testable import Places

final class MockLocationsRouter: LocationsRouterProtocol, @unchecked Sendable {
    var openedURLs: [URL] = []
    var shouldSucceed = true
    func open(_ url: URL) async -> Bool {
        openedURLs.append(url)
        return shouldSucceed
    }
}
