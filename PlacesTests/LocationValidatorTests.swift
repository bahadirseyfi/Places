import Testing
@testable import Places

@Suite("LocationValidator")
struct LocationValidatorTests {
    let validator = LocationValidator()

    @Test("Valid coordinate returns true")
    func validCoordinate() {
        #expect(validator.isValid(latitude: "52.3547", longitude: "4.8339"))
    }

    @Test("Empty latitude returns false")
    func emptyLatitude() {
        #expect(!validator.isValid(latitude: "", longitude: "4.8339"))
    }

    @Test("Empty longitude returns false")
    func emptyLongitude() {
        #expect(!validator.isValid(latitude: "52.3547", longitude: ""))
    }

    @Test("Non-numeric latitude returns false")
    func nonNumericLatitude() {
        #expect(!validator.isValid(latitude: "abc", longitude: "4.8339"))
    }

    @Test("Latitude above 90 returns false")
    func latitudeAbove90() {
        #expect(!validator.isValidLatitude("90.0001"))
    }

    @Test("Latitude below -90 returns false")
    func latitudeBelow90() {
        #expect(!validator.isValidLatitude("-90.0001"))
    }

    @Test("Longitude above 180 returns false")
    func longitudeAbove180() {
        #expect(!validator.isValidLongitude("180.0001"))
    }

    @Test("Longitude below -180 returns false")
    func longitudeBelow180() {
        #expect(!validator.isValidLongitude("-180.0001"))
    }
}
