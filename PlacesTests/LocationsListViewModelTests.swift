import Testing
import Foundation
@testable import Places

@Suite("LocationsListViewModel")
@MainActor
struct LocationsListViewModelTests {
    private func makeViewModel(
        service: MockLocationsService = MockLocationsService(),
        builder: MockDeeplinkBuilder = MockDeeplinkBuilder(),
        router: MockLocationsRouter = MockLocationsRouter()
    ) -> LocationsListViewModel {
        LocationsListViewModel(
            service: service,
            deeplinkBuilder: builder,
            router: router
        )
    }

    @Test("Initial load moves from loading to loaded")
    func loadSucceeds() async {
        let service = MockLocationsService()
        service.result = .success([Location(name: "Amsterdam", latitude: 52.3, longitude: 4.8)])
        let vm = makeViewModel(service: service)

        await vm.loadLocations()

        if case .loaded(let locations) = vm.state {
            #expect(locations.count == 1)
        } else {
            Issue.record("Expected loaded state, got \(vm.state)")
        }
    }

    @Test("Failed load moves to failed state")
    func loadFails() async {
        let service = MockLocationsService()
        service.result = .failure(URLError(.notConnectedToInternet))
        let vm = makeViewModel(service: service)

        await vm.loadLocations()

        if case .failed = vm.state {
        } else {
            Issue.record("Expected failed state, got \(vm.state)")
        }
    }

    @Test("Retry calls service again")
    func retryCallsService() async {
        let service = MockLocationsService()
        service.result = .failure(URLError(.notConnectedToInternet))
        let vm = makeViewModel(service: service)

        await vm.loadLocations()
        await vm.retry()

        #expect(service.fetchCallCount == 2)
    }

    @Test("Opening a location builds and opens URL when Wikipedia is available")
    func opensURLWhenAvailable() async {
        let router = MockLocationsRouter()
        router.shouldSucceed = true
        let vm = makeViewModel(router: router)

        await vm.openLocation(Location(name: "Amsterdam", latitude: 52.3, longitude: 4.8))

        #expect(router.openedURLs.count == 1)
        #expect(!vm.showWikiUnavailableAlert)
    }

    @Test("Opening a location shows unavailable alert when Wikipedia is not installed")
    func showsAlertWhenUnavailable() async {
        let router = MockLocationsRouter()
        router.shouldSucceed = false
        let vm = makeViewModel(router: router)

        await vm.openLocation(Location(name: "Amsterdam", latitude: 52.3, longitude: 4.8))

        #expect(router.openedURLs.count == 1)
        #expect(vm.showWikiUnavailableAlert)
    }
}
