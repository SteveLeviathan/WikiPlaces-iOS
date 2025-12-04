import XCTest
@testable import WikiPlaces

@MainActor
final class PlacesListRouterTests: XCTestCase {

    var subject: PlacesListRouter!
    var interactorMock: PlacesListInteractingMock!
    var applicationMock: UIApplicationTypeMock!

    override func setUp() {
        super.setUp()
        interactorMock = PlacesListInteractingMock(
            presenter: PlacesListPresentingMock(),
            router: PlacesListRoutingMock())

        applicationMock = UIApplicationTypeMock()
        subject = PlacesListRouter(interactor: interactorMock, application: applicationMock)
    }

    override func tearDown() {
        super.tearDown()
        subject = nil
        interactorMock = nil
        applicationMock = nil
    }

    func testRouteWithDeepLinkSuccess() {
        // Arrange
        let url = URL(string: "wikipedia://places?name=Place&latitude=10.0&longitude=20.0")!
        applicationMock.canOpenURLURLReturnValue = true

        // Act
        subject.routeWithDeepLink(routingContext: .init(url: url))

        // Assert
        XCTAssertTrue(applicationMock.openURLOptionsCompletionHandlerCalled)
        XCTAssertEqual(applicationMock.openURLOptionsCompletionHandlerReceivedURL, url)
    }

    func testRouteWithDeepLinkFailure() {
        // Arrange
        let url = URL(string: "wikipedia://places?name=Place&latitude=10.0&longitude=20.0")!
        applicationMock.canOpenURLURLReturnValue = false

        // Act
        subject.routeWithDeepLink(routingContext: .init(url: url))

        // Assert
        XCTAssertFalse(applicationMock.openURLOptionsCompletionHandlerCalled)
        XCTAssertTrue(interactorMock.handleDeepLinkingErrorResponseCalled)
        XCTAssertEqual(
            interactorMock.handleDeepLinkingErrorResponseReceivedResponse?.errorMessage,
            "Can't open invalid deep link URL!")
    }
}
