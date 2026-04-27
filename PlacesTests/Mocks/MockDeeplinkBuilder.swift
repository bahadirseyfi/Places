import Foundation
@testable import Places

final class MockDeeplinkBuilder: DeeplinkBuilderProtocol, @unchecked Sendable {
    var builtURL: URL? = URL(string: "wikipedia://namedPlace?latitude=0&longitude=0")
    nonisolated func build(latitude: Double, longitude: Double, name: String?) -> URL? { builtURL }
}
