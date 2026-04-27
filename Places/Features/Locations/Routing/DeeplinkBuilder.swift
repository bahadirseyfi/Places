import Foundation

protocol DeeplinkBuilderProtocol: Sendable {
    nonisolated func build(latitude: Double, longitude: Double, name: String?) -> URL?
}

struct DeeplinkBuilder: DeeplinkBuilderProtocol {
    nonisolated func build(latitude: Double, longitude: Double, name: String?) -> URL? {
        var components = URLComponents()
        components.scheme = "wikipedia"
        components.host = "namedPlace"

        var items: [URLQueryItem] = [
            URLQueryItem(name: "latitude", value: "\(latitude)"),
            URLQueryItem(name: "longitude", value: "\(longitude)"),
        ]

        if let name, !name.isEmpty {
            items.append(URLQueryItem(name: "locationName", value: name))
        }

        components.queryItems = items
        return components.url
    }
}
