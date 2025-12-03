import Foundation

protocol CoordinateValidatorType {
    func isValidLatitude(_ latitude: Double) -> Bool
    func isValidLatitude(_ latitude: String) -> (isValid: Bool, doubleValue: Double)
    func isValidLongitude(_ longitude: Double) -> Bool
    func isValidLongitude(_ longitude: String) -> (isValid: Bool, doubleValue: Double)
    func validCoordinates(latitude: Double, longitude: Double) -> Bool
}

struct CoordinateValidator: CoordinateValidatorType {
    func isValidLatitude(_ latitude: Double) -> Bool {
        (-90.0...90.0).contains(latitude)
    }

    func isValidLatitude(_ latitude: String) -> (isValid: Bool, doubleValue: Double) {
        let latitude = replaceDecimalSeparatorForCurrentLocale(coordinate: latitude)

        do {
            let latitude = try Double(latitude, format: .number)
            return (isValidLatitude(latitude), latitude)
        } catch {
            return (false, 0)
        }
    }

    func isValidLongitude(_ longitude: Double) -> Bool {
        (-180.0...180.0).contains(longitude)
    }

    func isValidLongitude(_ longitude: String) -> (isValid: Bool, doubleValue: Double) {
        let longitude = replaceDecimalSeparatorForCurrentLocale(coordinate: longitude)

        do {
            let longitude = try Double(longitude, format: .number)
            return (isValidLongitude(longitude), longitude)
        } catch {
            return (false, 0)
        }
    }

    func validCoordinates(latitude: Double, longitude: Double) -> Bool {
        isValidLatitude(latitude) && isValidLongitude(longitude)
    }

    // Replace decimal separator in String coordinate with that of the current locale.
    // This allows user input for both decimal separators "." and "," so the string coordinate
    // can be used to cast to Double with number style formatting.
    private func replaceDecimalSeparatorForCurrentLocale(coordinate: String) -> String {
        let currentLocaleDecimalSeparator = Locale.current.decimalSeparator ?? "."
        let oppositeDecimalSeparator = currentLocaleDecimalSeparator == "." ? "," : "."

        var formattedCoordinate: String?

        if coordinate.contains(oppositeDecimalSeparator) {
            formattedCoordinate = coordinate.replacingOccurrences(of: oppositeDecimalSeparator, with: currentLocaleDecimalSeparator)
        }

        return formattedCoordinate ?? coordinate
    }
}
