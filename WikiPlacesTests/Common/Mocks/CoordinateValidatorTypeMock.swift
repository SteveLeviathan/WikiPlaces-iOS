@testable import WikiPlaces
import Foundation

final class CoordinateValidatorTypeMock: @unchecked Sendable, CoordinateValidatorType {
    private(set) var isValidCoordinateLatitudeLongitudeCalled = false
    var isValidCoordinateLatitudeLongitudeReceivedArguments: (latitude: Double, longitude: Double)?
    var isValidCoordinateLatitudeLongitudeReturnValue = false

    func isValidCoordinate(latitude: Double, longitude: Double) -> Bool {
        isValidCoordinateLatitudeLongitudeCalled = true
        isValidCoordinateLatitudeLongitudeReceivedArguments?.latitude = latitude
        isValidCoordinateLatitudeLongitudeReceivedArguments?.longitude = longitude
        return isValidCoordinateLatitudeLongitudeReturnValue
    }

    var isValidLatitudeLatitudeCalled = false
    var isValidLatitudeLatitudeReceivedLatitude: Double?
    var isValidLatitudeLatitudeReturnValue = false

    func isValidLatitude(_ latitude: Double) -> Bool {
        isValidLatitudeLatitudeCalled = true
        isValidLatitudeLatitudeReceivedLatitude = latitude
        return isValidLatitudeLatitudeReturnValue
    }

    var isValidLatitudeLatitudeStringValueCalled = false
    var isValidLatitudeLatitudeStringValueReceivedLatitude: String?
    var isValidLatitudeLatitudeStringValueReturnValue: (isValid: Bool, doubleValue: Double) = (false, 0)

    func isValidLatitude(_ latitude: String) -> (isValid: Bool, doubleValue: Double) {
        isValidLatitudeLatitudeStringValueCalled = true
        isValidLatitudeLatitudeStringValueReceivedLatitude = latitude
        return isValidLatitudeLatitudeStringValueReturnValue
    }

    var isValidLongitudeLongitudeCalled = false
    var isValidLongitudeLongitudeReceivedLongitude: Double?
    var isValidLongitudeLongitudeReturnValue = false

    func isValidLongitude(_ longitude: Double) -> Bool {
        isValidLongitudeLongitudeCalled = true
        isValidLongitudeLongitudeReceivedLongitude = longitude
        return isValidLongitudeLongitudeReturnValue
    }

    var isValidLongitudeLongitudeStringValueCalled = false
    var isValidLongitudeLongitudeStringValueReceivedLongitude: String?
    var isValidLongitudeLongitudeStringValueReturnValue: (isValid: Bool, doubleValue: Double) = (false, 0)

    func isValidLongitude(_ longitude: String) -> (isValid: Bool, doubleValue: Double) {
        isValidLongitudeLongitudeStringValueCalled = true
        isValidLongitudeLongitudeStringValueReceivedLongitude = longitude
        return isValidLongitudeLongitudeStringValueReturnValue
    }

    var validCoordinatesLatitudeLongitudeCalled = false
    var validCoordinatesLatitudeLongitudeReceivedArguments: (latitude: Double, longitude: Double)?
    var validCoordinatesLatitudeLongitudeReturnValue = false

    func validCoordinates(latitude: Double, longitude: Double) -> Bool {
        validCoordinatesLatitudeLongitudeCalled = true
        validCoordinatesLatitudeLongitudeReceivedArguments?.latitude = latitude
        validCoordinatesLatitudeLongitudeReceivedArguments?.longitude = longitude
        return validCoordinatesLatitudeLongitudeReturnValue
    }
}

