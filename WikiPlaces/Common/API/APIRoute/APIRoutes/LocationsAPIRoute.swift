import Foundation

enum LocationsAPIRoute: APIRouteType {
    case getLocations

    var baseURL: URL {
        URL(string: "https://raw.githubusercontent.com/abnamrocoesd/assignment-ios/main")!
    }

    var path: String {
        switch self {
        case .getLocations:
            return "/locations.json"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .getLocations:
            return .GET
        }
    }

    var headers: [String : String]? {
        switch self {
        default:
            return nil
        }
    }

    var body: [String: Any]? {
        switch self {
        default:
            return nil
        }
    }
}
