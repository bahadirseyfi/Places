import Foundation

struct StubLocationsService: LocationsServiceProtocol {
    func fetchLocations() async throws -> [Location] {
        [
            Location(name: "Amsterdam", latitude: 52.3547498, longitude: 4.8339215),
            Location(name: "Madrid", latitude: 40.4380638, longitude: -3.7495758),
            Location(name: nil, latitude: 40.4381311, longitude: -3.7496797),
        ]
    }
}

struct FailingLocationsService: LocationsServiceProtocol {
    func fetchLocations() async throws -> [Location] {
        throw URLError(.notConnectedToInternet)
    }
}
