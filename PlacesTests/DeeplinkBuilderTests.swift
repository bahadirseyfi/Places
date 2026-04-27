import Testing
import Foundation
@testable import Places

@Suite("DeeplinkBuilder")
struct DeeplinkBuilderTests {
    let builder = DeeplinkBuilder()

    @Test("Builds expected scheme")
    func scheme() throws {
        let url = try #require(builder.build(latitude: 52.3, longitude: 4.8, name: nil))
        #expect(url.scheme == "wikipedia")
    }

    @Test("Builds expected host")
    func host() throws {
        let url = try #require(builder.build(latitude: 52.3, longitude: 4.8, name: nil))
        #expect(url.host() == "namedPlace")
    }

    @Test("Includes latitude")
    func includesLatitude() throws {
        let url = try #require(builder.build(latitude: 52.3547498, longitude: 4.8, name: nil))
        #expect(url.absoluteString.contains("latitude=52.3547498"))
    }

    @Test("Includes longitude")
    func includesLongitude() throws {
        let url = try #require(builder.build(latitude: 52.3, longitude: 4.8339215, name: nil))
        #expect(url.absoluteString.contains("longitude=4.8339215"))
    }

    @Test("Includes locationName when present")
    func includesName() throws {
        let url = try #require(builder.build(latitude: 52.3, longitude: 4.8, name: "Amsterdam"))
        #expect(url.absoluteString.contains("locationName=Amsterdam"))
    }

    @Test("Omits locationName when absent")
    func omitsName() throws {
        let url = try #require(builder.build(latitude: 52.3, longitude: 4.8, name: nil))
        #expect(!url.absoluteString.contains("locationName"))
    }

    @Test("Encodes special characters in name")
    func encodesSpecialCharacters() throws {
        let url = try #require(builder.build(latitude: 52.3, longitude: 4.8, name: "New York"))
        #expect(url.absoluteString.contains("locationName=New%20York"))
    }
}
