import Foundation
@testable import Places
import NetworkPackage

final class MockNetworkClient: NetworkClientProtocol, @unchecked Sendable {
    enum Behavior {
        case success(Data)
        case failure(Error)
    }

    var behaviors: [Behavior] = []
    private var callCount = 0

    func fetch<T: Decodable & Sendable>(_ type: T.Type, from url: URL) async throws -> T {
        let behavior = behaviors[min(callCount, behaviors.count - 1)]
        callCount += 1
        switch behavior {
        case .success(let data):
            return try JSONDecoder().decode(type, from: data)
        case .failure(let error):
            throw error
        }
    }
}
