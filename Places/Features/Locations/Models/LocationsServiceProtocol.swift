protocol LocationsServiceProtocol: Sendable {
    func fetchLocations() async throws -> [Location]
}
