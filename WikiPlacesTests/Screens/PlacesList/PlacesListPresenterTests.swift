import XCTest
@testable import WikiPlaces

@MainActor
final class PlacesListPresenterTests: XCTestCase {

    var subject: PlacesListPresenter!

    override func setUp() async throws {
        try await super.setUp()
        subject = PlacesListPresenter()
    }

    override func tearDown() async throws {
        try await super.tearDown()
        subject = nil
    }

    func testPresentLocationsWithLocations() {
        // Arrange
        let locations = [
            Location(name: "Place 1", lat: 10.0, long: 20.0),
            Location(name: "Place 2", lat: 30.0, long: 40.0)
        ]

        let expectedPlaces = [
            PlacesList.Place(name: "Place 1", latitude: 10.0, longitude: 20.0),
            PlacesList.Place(name: "Place 2", latitude: 30.0, longitude: 40.0)
        ]

        let response = PlacesList.LoadPlaces.Response(locations: locations, errorMessage: nil)

        // Act
        subject.presentLocations(response: response)

        // Assert
        XCTAssertEqual(subject.placesDataStore.remotePlaces, expectedPlaces)
        XCTAssertNil(subject.errorMessage)
        XCTAssertEqual(subject.loadingState, .idle)
    }

    func testPresentLocationsWithErrorMessage() {
        // Arrange
        let errorMessage = "Failed to load places"
        let response = PlacesList.LoadPlaces.Response(locations: [], errorMessage: errorMessage)

        // Act
        subject.presentLocations(response: response)

        // Assert
        XCTAssertEqual(subject.placesDataStore.remotePlaces, [])
        XCTAssertEqual(subject.errorMessage, errorMessage)
        XCTAssertEqual(subject.loadingState, .error)
    }

    func testPresentDeepLinkingError() {
        // Arrange
        let errorMessage = "Invalid deep link"
        let response = PlacesList.PrepareDeepLink.Response(errorMessage: errorMessage)

        // Act
        subject.presentDeepLinkingError(response: response)

        // Assert
        XCTAssertEqual(subject.alertTitle, "Attention")
        XCTAssertEqual(subject.alertMessage, errorMessage)
        XCTAssertTrue(subject.showAlert)
    }
}
