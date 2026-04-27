import CoreLocation

struct LocationValidator: Sendable {
    nonisolated func isValidLatitude(_ value: String) -> Bool {
        guard let latitude = Double(value) else { return false }
        return (-90...90).contains(latitude)
    }

    nonisolated func isValidLongitude(_ value: String) -> Bool {
        guard let longitude = Double(value) else { return false }
        return (-180...180).contains(longitude)
    }

    nonisolated func isValid(latitude: String, longitude: String) -> Bool {
        isValidLatitude(latitude) && isValidLongitude(longitude)
    }
}
