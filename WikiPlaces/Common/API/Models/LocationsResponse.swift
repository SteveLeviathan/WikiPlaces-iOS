import Foundation

struct LocationsResponse: Decodable {
    let locations: [Location]
}

struct Location: Decodable, Equatable {
    let name: String?
    let lat: Double
    let long: Double
}
