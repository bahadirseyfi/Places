import Foundation

public protocol NetworkClientProtocol: Sendable {
    func fetch<T: Decodable & Sendable>(_ type: T.Type, from url: URL) async throws -> T
}

public final class NetworkClient: NetworkClientProtocol {
    private let session: URLSession

    public init(session: URLSession = .shared) {
        self.session = session
    }

    public func fetch<T: Decodable & Sendable>(_ type: T.Type, from url: URL) async throws -> T {
        let (data, _) = try await session.data(from: url)
        return try JSONDecoder().decode(type, from: data)
    }
}
