import Testing
import Foundation
@testable import Places

@Suite("Location Decoding")
struct LocationDecodingTests {
    @Test("JSON with name decodes correctly")
    func decodesWithName() throws {
        let json = #"{"name":"Amsterdam","lat":52.3547498,"long":4.8339215}"#
        let location = try decode(json)
        #expect(location.name == "Amsterdam")
        #expect(location.latitude == 52.3547498)
        #expect(location.longitude == 4.8339215)
    }

    @Test("JSON without name decodes correctly")
    func decodesWithoutName() throws {
        let json = #"{"lat":40.4381311,"long":-3.7496797}"#
        let location = try decode(json)
        #expect(location.name == nil)
    }

    @Test("lat key maps to latitude")
    func latMapsToLatitude() throws {
        let json = #"{"lat":12.345,"long":0.0}"#
        let location = try decode(json)
        #expect(location.latitude == 12.345)
    }

    @Test("long key maps to longitude")
    func longMapsToLongitude() throws {
        let json = #"{"lat":0.0,"long":-67.890}"#
        let location = try decode(json)
        #expect(location.longitude == -67.890)
    }

    private func decode(_ json: String) throws -> Location {
        try JSONDecoder().decode(Location.self, from: Data(json.utf8))
    }
}
