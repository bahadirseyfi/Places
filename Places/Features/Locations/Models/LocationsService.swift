import Foundation
import NetworkPackage

final class LocationsService: LocationsServiceProtocol {
    private let networkClient: any NetworkClientProtocol
    private let endpoint = URL(string: "https://raw.githubusercontent.com/abnamrocoesd/assignment-ios/main/locations.json")!
    private let maxAttempts = 3
    private let retryDelay: Duration

    nonisolated init(networkClient: any NetworkClientProtocol, retryDelay: Duration = .seconds(1)) {
        self.networkClient = networkClient
        self.retryDelay = retryDelay
    }

    nonisolated func fetchLocations() async throws -> [Location] {
        try await retry(maxAttempts: maxAttempts, delay: retryDelay) {
            try await self.networkClient.fetch(LocationsResponse.self, from: self.endpoint).locations
        }
    }

    private nonisolated func retry<T: Sendable>(
        maxAttempts: Int,
        delay: Duration,
        operation: @Sendable () async throws -> T
    ) async throws -> T {
        var lastError: Error?
        for attempt in 1...maxAttempts {
            do {
                return try await operation()
            } catch {
                lastError = error
                if attempt < maxAttempts {
                    try await Task.sleep(for: delay)
                }
            }
        }
        throw lastError!
    }
}
