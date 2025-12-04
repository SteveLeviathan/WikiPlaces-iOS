import XCTest
@testable import WikiPlaces

final class CoordinateValidatorTests: XCTestCase {

    var subject: CoordinateValidator!

    override func setUp() {
        super.setUp()
        subject = CoordinateValidator()
    }

    override func tearDown() {
        super.tearDown()
        subject = nil
    }

    // MARK: - Latitude (Double)

    func testLatitudeDoubleValid() {
        XCTAssertTrue(subject.isValidLatitude(0))
        XCTAssertTrue(subject.isValidLatitude(45.123))
        XCTAssertTrue(subject.isValidLatitude(-90))
        XCTAssertTrue(subject.isValidLatitude(90))
    }

    func testLatitudeDoubleInvalid() {
        XCTAssertFalse(subject.isValidLatitude(-90.1))
        XCTAssertFalse(subject.isValidLatitude(90.01))
        XCTAssertFalse(subject.isValidLatitude(100))
    }

    // MARK: - Latitude (String)

    func testLatitudeStringValueValidWithDot() {
        let result = subject.isValidLatitude("52.3676")
        XCTAssertTrue(result.isValid)
        XCTAssertEqual(result.doubleValue, 52.3676, accuracy: 0.0001)
    }

    func testLatitudeStringValueValidWithComma() {
        let result = subject.isValidLatitude("52,3676")
        XCTAssertTrue(result.isValid)
        XCTAssertEqual(result.doubleValue, 52.3676, accuracy: 0.0001)
    }

    func testLatitudeStringValueInvalidNotANumber() {
        let result = subject.isValidLatitude("abc")
        XCTAssertFalse(result.isValid)
        XCTAssertEqual(result.doubleValue, 0)
    }

    func testLatitudeStringValueInvalidOutOfRange() {
        let result = subject.isValidLatitude("100")
        XCTAssertFalse(result.isValid)
    }

    // MARK: - Longitude (Double)

    func testLongitudeDoubleValueValid() {
        XCTAssertTrue(subject.isValidLongitude(0))
        XCTAssertTrue(subject.isValidLongitude(120.55))
        XCTAssertTrue(subject.isValidLongitude(-180))
        XCTAssertTrue(subject.isValidLongitude(180))
    }

    func testLongitudeDoubleValueInvalid() {
        XCTAssertFalse(subject.isValidLongitude(-180.01))
        XCTAssertFalse(subject.isValidLongitude(180.1))
    }

    // MARK: - Longitude (String)

    func testLongitudeStringValueValidWithDot() {
        let result = subject.isValidLongitude("4.9041")
        XCTAssertTrue(result.isValid)
        XCTAssertEqual(result.doubleValue, 4.9041, accuracy: 0.0001)
    }

    func testLongitudeStringValueValidWithComma() {
        let result = subject.isValidLongitude("4,9041")
        XCTAssertTrue(result.isValid)
        XCTAssertEqual(result.doubleValue, 4.9041, accuracy: 0.0001)
    }

    func testLongitudeStringValueInvalidNotANumber() {
        let result = subject.isValidLongitude("xyz")
        XCTAssertFalse(result.isValid)
        XCTAssertEqual(result.doubleValue, 0)
    }

    func testLongitudeStringValueOutOfRange() {
        let result = subject.isValidLongitude("181")
        XCTAssertFalse(result.isValid)
    }

    // MARK: - Combined coordinate validation

    func testCoordinatesBothValid() {
        XCTAssertTrue(subject.validCoordinates(latitude: 52.37, longitude: 4.90))
    }

    func testCoordinatesBothInvalid() {
        XCTAssertFalse(subject.validCoordinates(latitude: -200, longitude: 999))
    }

    func testCoordinatesInvalidLatitude() {
        XCTAssertFalse(subject.validCoordinates(latitude: 200, longitude: 4.90))
    }

    func testCoordinatesInvalidLongitude() {
        XCTAssertFalse(subject.validCoordinates(latitude: 52.37, longitude: -999))
    }

    // MARK: - Decimal separator replacement

    func testDecimalSeparatorReplacementForBothSeparatorsSuccessful() {
        let commaLatitude = subject.isValidLatitude("12,3")
        let dotLatitude = subject.isValidLatitude("12.3")

        XCTAssertEqual(commaLatitude.doubleValue, 12.3, accuracy: 0.0001)
        XCTAssertEqual(dotLatitude.doubleValue, 12.3, accuracy: 0.0001)
    }
}
