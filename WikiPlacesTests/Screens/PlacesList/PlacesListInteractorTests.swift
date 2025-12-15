import XCTest
@testable import WikiPlaces

final class PlacesListInteractorTests: XCTestCase {

    var subject: PlacesListInteractor!
    var presenterMock: PlacesListPresentingMock!
    var routerMock: PlacesListRoutingMock!
    var apiClientMock: APIClientTypeMock!
    var coordinateValidatorMock: CoordinateValidatorTypeMock!

    override func setUp() {
        super.setUp()
        presenterMock = PlacesListPresentingMock()
        routerMock = PlacesListRoutingMock()
        apiClientMock = APIClientTypeMock()
        coordinateValidatorMock = CoordinateValidatorTypeMock()

        subject = PlacesListInteractor(
            presenter: presenterMock,
            router: routerMock,
            apiClient: apiClientMock,
            coordinateValidator: coordinateValidatorMock)
    }

    override func tearDown() {
        super.tearDown()
        subject = nil
        presenterMock = nil
        routerMock = nil
        apiClientMock = nil
        coordinateValidatorMock = nil
    }

    @MainActor
    func testLoadPlacesSuccess() async {
        // Arrange
        let expectedLocations = [
            Location(name: "Place 1", lat: 10.0, long: 20.0),
            Location(name: "Place 2", lat: 30.0, long: 40.0)
        ]

        apiClientMock.requestAPIRouteReturnValue = LocationsResponse(locations: expectedLocations)

        // Act
        await subject.loadPlaces(request: .init())

        // Assert
        XCTAssertTrue(presenterMock.presentLocationsResponseCalled)
        XCTAssertEqual(presenterMock.presentLocationsResponseReceivedResponse?.locations, expectedLocations)
        XCTAssertNil(presenterMock.presentLocationsResponseReceivedResponse?.errorMessage)
    }

    @MainActor
    func testLoadPlacesFailure() async throws {
        // Arrange
        apiClientMock.requestAPIRouteReturnValue = nil

        // Act
        await subject.loadPlaces(request: .init())

        // Assert
        XCTAssertTrue(presenterMock.presentLocationsResponseCalled)
        XCTAssertEqual(presenterMock.presentLocationsResponseReceivedResponse?.locations, [])
        XCTAssertNotNil(presenterMock.presentLocationsResponseReceivedResponse?.errorMessage)
    }

    func testprepareDeepLinkWithValidCoordinates() {
        // Arrange
        coordinateValidatorMock.validCoordinatesLatitudeLongitudeReturnValue = true

        // Act
        subject.prepareDeepLink(request: .init(name: "Test Place", latitude: 10.0, longitude: 20.0))

        // Assert
        XCTAssertTrue(routerMock.routeWithDeepLinkRoutingContextCalled)
        XCTAssertFalse(presenterMock.presentDeepLinkingErrorResponseCalled)

        let url = routerMock.routeWithDeepLinkRoutingContextReceivedRoutingContext?.url
        XCTAssertEqual(url?.absoluteString, "wikipedia://places?name=Test%20Place&latitude=10.0&longitude=20.0")
    }

    func testPrepareDeepLinkWithInvalidCoordinates() {
        // Arrange
        coordinateValidatorMock.validCoordinatesLatitudeLongitudeReturnValue = false

        // Act
        subject.prepareDeepLink(request: .init(name: "Test Place", latitude: 100.0, longitude: 200.0))

        // Assert
        XCTAssertFalse(routerMock.routeWithDeepLinkRoutingContextCalled)
        XCTAssertTrue(presenterMock.presentDeepLinkingErrorResponseCalled)
        XCTAssertEqual(presenterMock.presentDeepLinkingErrorResponseReceivedResponse?.errorMessage, "Unable to deep link, the coordinates are invalid.")
    }

    func testHandleDeepLinkingError() {
        // Arrange
        let errorMessage = "deep link error"

        // Act
        subject.handleDeepLinkingError(response: .init(errorMessage: errorMessage))

        // Assert
        XCTAssertTrue(presenterMock.presentDeepLinkingErrorResponseCalled)
        XCTAssertEqual(presenterMock.presentDeepLinkingErrorResponseReceivedResponse?.errorMessage, errorMessage)
    }
}
