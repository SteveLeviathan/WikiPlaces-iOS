import XCTest
@testable import WikiPlaces

@MainActor
final class PlacesListViewModelTests: XCTestCase {

    var subject: PlacesListViewModel!

    override func setUp() {
        super.setUp()
        subject = PlacesListViewModel()
    }

    override func tearDown() {
        super.tearDown()
        subject = nil
    }

    func testDisplayPlacesSuccess() {
        // Arrange
        let places = [
            PlacesList.Place(name: "Place 1", latitude: 10.0, longitude: 20.0),
            PlacesList.Place(name: "Place 2", latitude: 30.0, longitude: 40.0)
        ]

        // Act
        subject.displayPlaces(viewModel: .init(places: places, errorMessage: nil))

        // Assert
        XCTAssertEqual(subject.placesDataStore.remotePlaces, places)
        XCTAssertEqual(subject.loadingState, .idle)
        XCTAssertNil(subject.errorMessage)
    }

    func testDisplayPlacesWithErrorMessage() {
        // Arrange
        let errorMessage = "Failed to load places"
        // Act
        subject.displayPlaces(viewModel: .init(places: [], errorMessage: errorMessage))

        // Assert
        XCTAssertEqual(subject.placesDataStore.remotePlaces, [])
        XCTAssertEqual(subject.loadingState, .error)
        XCTAssertEqual(subject.errorMessage, errorMessage)
    }

    func testDisplayInvalidDeepLink() {
        // Arrange
        let errorTitle = "Warning"
        let errorMessage = "Invalid deep link"

        // Act
        subject.displayInvalidDeepLink(viewModel: .init(errorTitle: errorTitle, errorMessage: errorMessage))

        // Assert
        XCTAssertTrue(subject.showAlert)
        XCTAssertEqual(subject.alertTitle, errorTitle)
        XCTAssertEqual(subject.alertMessage, errorMessage)
    }
}
