import Foundation

struct Location: Identifiable, Decodable, Equatable, Sendable {
    nonisolated let id: UUID
    nonisolated let name: String?
    nonisolated let latitude: Double
    nonisolated let longitude: Double

    init(id: UUID = UUID(), name: String?, latitude: Double, longitude: Double) {
        self.id = id
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
    }

    enum CodingKeys: String, CodingKey {
        case name
        case latitude = "lat"
        case longitude = "long"
    }

    nonisolated init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = UUID()
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.latitude = try container.decode(Double.self, forKey: .latitude)
        self.longitude = try container.decode(Double.self, forKey: .longitude)
    }
}

struct LocationsResponse: Decodable, Sendable {
    let locations: [Location]

    nonisolated init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.locations = try container.decode([Location].self, forKey: .locations)
    }

    enum CodingKeys: String, CodingKey { case locations }
}
