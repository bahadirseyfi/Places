import Foundation
import Observation

enum LocationsViewState: Equatable, Sendable {
    case idle
    case loading
    case loaded([Location])
    case empty
    case failed(String)
}

@Observable
@MainActor
final class LocationsListViewModel {
    var state: LocationsViewState = .idle
    var showWikiUnavailableAlert = false

    private let service: any LocationsServiceProtocol
    private let deeplinkBuilder: any DeeplinkBuilderProtocol
    private let router: any LocationsRouterProtocol

    init(
        service: any LocationsServiceProtocol,
        deeplinkBuilder: any DeeplinkBuilderProtocol,
        router: any LocationsRouterProtocol
    ) {
        self.service = service
        self.deeplinkBuilder = deeplinkBuilder
        self.router = router
    }

    func loadLocations() async {
        state = .loading
        do {
            let locations = try await service.fetchLocations()
            state = locations.isEmpty ? .empty : .loaded(locations)
        } catch {
            state = .failed(error.localizedDescription)
        }
    }

    func retry() async {
        await loadLocations()
    }

    func openInWikipedia(latitude: Double, longitude: Double, name: String?) async {
        guard let url = deeplinkBuilder.build(latitude: latitude, longitude: longitude, name: name) else {
            return
        }
        let opened = await router.open(url)
        if !opened {
            showWikiUnavailableAlert = true
        }
    }

    func openLocation(_ location: Location) async {
        await openInWikipedia(latitude: location.latitude, longitude: location.longitude, name: location.name)
    }
}
