import Testing
import Foundation
@testable import Places
import NetworkPackage

@Suite("LocationsService")
struct LocationsServiceTests {
    private let validJSON = #"""
    {"locations":[{"name":"Amsterdam","lat":52.3547498,"long":4.8339215}]}
    """#.data(using: .utf8)!

    @Test("Returns decoded locations on success")
    func returnsLocationsOnSuccess() async throws {
        let client = MockNetworkClient()
        client.behaviors = [.success(validJSON)]
        let service = LocationsService(networkClient: client, retryDelay: .zero)

        let locations = try await service.fetchLocations()
        #expect(locations.count == 1)
        #expect(locations[0].name == "Amsterdam")
    }

    @Test("Retries after a transient failure")
    func retriesAfterTransientFailure() async throws {
        let client = MockNetworkClient()
        client.behaviors = [
            .failure(URLError(.networkConnectionLost)),
            .success(validJSON),
        ]
        let service = LocationsService(networkClient: client, retryDelay: .zero)

        let locations = try await service.fetchLocations()
        #expect(locations.count == 1)
    }

    @Test("Fails after max attempts")
    func failsAfterMaxAttempts() async {
        let client = MockNetworkClient()
        client.behaviors = Array(repeating: .failure(URLError(.networkConnectionLost)), count: 3)
        let service = LocationsService(networkClient: client, retryDelay: .zero)

        await #expect(throws: (any Error).self) {
            try await service.fetchLocations()
        }
    }

    @Test("Does not return partial data after failure")
    func noPartialDataOnFailure() async {
        let client = MockNetworkClient()
        client.behaviors = Array(repeating: .failure(URLError(.networkConnectionLost)), count: 3)
        let service = LocationsService(networkClient: client, retryDelay: .zero)

        var result: [Location]? = nil
        do {
            result = try await service.fetchLocations()
        } catch {}
        #expect(result == nil)
    }
}
