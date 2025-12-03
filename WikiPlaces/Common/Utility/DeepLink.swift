import Foundation

protocol DeepLinkType {
    var scheme: String { get }
    var host: String { get }
    var path: String { get }
    var queryItems: [URLQueryItem]? { get }
    var url: URL? { get }
}

extension DeepLinkType {
    var url: URL? {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = path.isEmpty || path.hasPrefix("/") ? path : "/" + path
        components.queryItems = queryItems

        return components.url
    }
}

enum DeepLink: DeepLinkType {
    case wikipediaPlaces(name: String, latitude: String, longitude: String)

    var scheme: String {
        switch self {
        case .wikipediaPlaces:
            return "wikipedia"
        }
    }

    var host: String {
        switch self {
        case .wikipediaPlaces: 
            return "places"
        }
    }

    var path: String {
        switch self {
        case .wikipediaPlaces: 
            return ""
        }
    }

    var queryItems: [URLQueryItem]? {
        switch self {
        case .wikipediaPlaces(let name, let latitude, let longitude):
            return [
                URLQueryItem(name: "name", value: name),
                URLQueryItem(name: "latitude", value: latitude),
                URLQueryItem(name: "longitude", value: longitude)]
        }
    }
}

