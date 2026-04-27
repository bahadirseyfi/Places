@testable import Places

final class MockLocationsService: LocationsServiceProtocol, @unchecked Sendable {
    var result: Result<[Location], Error> = .success([])
    var fetchCallCount = 0

    func fetchLocations() async throws -> [Location] {
        fetchCallCount += 1
        return try result.get()
    }
}
