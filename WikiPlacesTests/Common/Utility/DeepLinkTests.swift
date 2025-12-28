import XCTest
@testable import WikiPlaces

@MainActor
final class DeepLinkTests: XCTestCase {

    func testWikipediaPlacesDeepLink() {
        // Arrange & Act
        let link = DeepLink.wikipediaPlaces(
            name: "Amsterdam",
            latitude: "52.3676",
            longitude: "4.9041"
        )

        // Assert
        XCTAssertEqual(link.scheme, "wikipedia")

        XCTAssertEqual(link.host, "places")

        XCTAssertEqual(link.path, "")

        guard let items = link.queryItems else {
            XCTFail("Expected query items")
            return
        }

        XCTAssertEqual(items[0].name, "name")
        XCTAssertEqual(items[0].value, "Amsterdam")

        XCTAssertEqual(items[1].name, "latitude")
        XCTAssertEqual(items[1].value, "52.3676")

        XCTAssertEqual(items[2].name, "longitude")
        XCTAssertEqual(items[2].value, "4.9041")
    }
}
