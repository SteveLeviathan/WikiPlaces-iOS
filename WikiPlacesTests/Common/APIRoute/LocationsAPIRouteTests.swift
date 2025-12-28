import XCTest
@testable import WikiPlaces

@MainActor
final class LocationsAPIRouteTests: XCTestCase {
    func testGetLocationsAPIRoute() {
        // Arrange & Act
        let route = LocationsAPIRoute.getLocations

        // Assert
        XCTAssertEqual(route.baseURL.absoluteString,
                       "https://raw.githubusercontent.com/abnamrocoesd/assignment-ios/main")

        XCTAssertEqual(route.path, "/locations.json")

        XCTAssertEqual(route.method, .GET)

        XCTAssertNil(route.headers)

        XCTAssertNil(route.body)
    }
}
