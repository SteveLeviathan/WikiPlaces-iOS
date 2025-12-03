import Foundation

struct LocationsResponse: Decodable {
    let locations: [Location]
}

struct Location: Decodable {
    let name: String?
    let lat: Double
    let long: Double
}
