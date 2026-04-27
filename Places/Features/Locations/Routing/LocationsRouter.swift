import UIKit

protocol LocationsRouterProtocol: Sendable {
    func open(_ url: URL) async -> Bool
}

final class LocationsRouter: LocationsRouterProtocol {
    @MainActor
    func open(_ url: URL) async -> Bool {
        await UIApplication.shared.open(url)
    }
}
