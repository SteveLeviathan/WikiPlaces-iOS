import XCTest
@testable import WikiPlaces

final class PlacesListInteractorTests: XCTestCase {

    var subject: PlacesListInteractor!
    var presenterMock: PlacesListPresentingMock!
    var routerMock: PlacesListRoutingMock!
    var apiClientMock: APIClientTypeMock!
    var coordinateValidatorMock: CoordinateValidatorTypeMock!

    override func setUp() async throws {
        try await super.setUp()
        presenterMock = PlacesListPresentingMock()
        routerMock = await PlacesListRoutingMock()
        apiClientMock = APIClientTypeMock()
        coordinateValidatorMock = CoordinateValidatorTypeMock()

        subject = await PlacesListInteractor(
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
        let presentLocationsResponseCalled = await presenterMock.presentLocationsResponseCalled
        XCTAssertTrue(presentLocationsResponseCalled)

        let locations = await presenterMock.presentLocationsResponseReceivedResponse?.locations
        XCTAssertEqual(locations, expectedLocations)

        let errorMessage = await presenterMock.presentLocationsResponseReceivedResponse?.errorMessage
        XCTAssertNil(errorMessage)
    }

    func testLoadPlacesFailure() async throws {
        // Arrange
        apiClientMock.requestAPIRouteReturnValue = nil

        // Act
        await subject.loadPlaces(request: .init())

        // Assert
        let presentLocationsResponseCalled = await presenterMock.presentLocationsResponseCalled
        XCTAssertTrue(presentLocationsResponseCalled)

        let locations = await presenterMock.presentLocationsResponseReceivedResponse?.locations
        XCTAssertEqual(locations, [])

        let errorMessage = await presenterMock.presentLocationsResponseReceivedResponse?.errorMessage
        XCTAssertNotNil(errorMessage)
    }

    func testprepareDeepLinkWithValidCoordinates() async {
        // Arrange
        coordinateValidatorMock.validCoordinatesLatitudeLongitudeReturnValue = true

        // Act
        await subject.prepareDeepLink(request: .init(name: "Test Place", latitude: 10.0, longitude: 20.0))

        // Assert
        let routeWithDeepLinkRoutingContextCalled = await routerMock.routeWithDeepLinkRoutingContextCalled
        XCTAssertTrue(routeWithDeepLinkRoutingContextCalled)

        let presentDeepLinkingErrorResponseCalled = await presenterMock.presentDeepLinkingErrorResponseCalled
        XCTAssertFalse(presentDeepLinkingErrorResponseCalled)

        let url = await routerMock.routeWithDeepLinkRoutingContextReceivedRoutingContext?.url
        XCTAssertEqual(url?.absoluteString, "wikipedia://places?name=Test%20Place&latitude=10.0&longitude=20.0")
    }

    func testPrepareDeepLinkWithInvalidCoordinates() async {
        // Arrange
        coordinateValidatorMock.validCoordinatesLatitudeLongitudeReturnValue = false

        // Act
        await subject.prepareDeepLink(request: .init(name: "Test Place", latitude: 100.0, longitude: 200.0))

        // Assert
        let routeWithDeepLinkRoutingContextCalled = await routerMock.routeWithDeepLinkRoutingContextCalled
        XCTAssertFalse(routeWithDeepLinkRoutingContextCalled)

        let presentDeepLinkingErrorResponseCalled = await presenterMock.presentDeepLinkingErrorResponseCalled
        XCTAssertTrue(presentDeepLinkingErrorResponseCalled)

        let errorMessage = await presenterMock.presentDeepLinkingErrorResponseReceivedResponse?.errorMessage
        XCTAssertEqual(errorMessage, "Unable to deep link, the coordinates are invalid.")
    }

    func testHandleDeepLinkingError() async {
        // Arrange
        let errorMessage = "deep link error"

        // Act
        await subject.handleDeepLinkingError(response: .init(errorMessage: errorMessage))

        // Assert
        let presentDeepLinkingErrorResponseCalled = await presenterMock.presentDeepLinkingErrorResponseCalled
        XCTAssertTrue(presentDeepLinkingErrorResponseCalled)

        let errorMessageReceived = await presenterMock.presentDeepLinkingErrorResponseReceivedResponse?.errorMessage
        XCTAssertEqual(errorMessageReceived, errorMessage)
    }
}
