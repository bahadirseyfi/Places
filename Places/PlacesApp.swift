import SwiftUI
import NetworkPackage

@main
struct PlacesApp: App {
    var body: some Scene {
        WindowGroup {
            LocationsListView(viewModel: makeViewModel())
        }
    }

    private func makeViewModel() -> LocationsListViewModel {
        #if DEBUG
        let arguments = ProcessInfo.processInfo.arguments
        if arguments.contains("-uiTestMode") {
            return makeUITestViewModel(arguments: arguments)
        }
        #endif

        let networkClient = NetworkClient()
        let service = LocationsService(networkClient: networkClient)
        return LocationsListViewModel(
            service: service,
            deeplinkBuilder: DeeplinkBuilder(),
            router: LocationsRouter()
        )
    }

    #if DEBUG
    private func makeUITestViewModel(arguments: [String]) -> LocationsListViewModel {
        let service: any LocationsServiceProtocol
        if arguments.contains("-uiTestLocationsFailure") {
            service = FailingLocationsService()
        } else {
            service = StubLocationsService()
        }
        return LocationsListViewModel(
            service: service,
            deeplinkBuilder: DeeplinkBuilder(),
            router: NoOpLocationsRouter()
        )
    }
    #endif
}
