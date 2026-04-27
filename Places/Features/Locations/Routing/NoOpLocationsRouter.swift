import Foundation

struct NoOpLocationsRouter: LocationsRouterProtocol {
    func open(_ url: URL) async -> Bool { true }
}
