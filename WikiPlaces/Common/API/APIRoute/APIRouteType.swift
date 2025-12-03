import Foundation

enum HTTPMethod: String {
    case GET
    case POST
    case PUT
}

protocol APIRouteType {
    var baseURL: URL { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }
    var body: [String: Any]? { get }

    func asURLRequest() throws -> URLRequest
}

extension APIRouteType {
    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(path)

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue

        headers?.forEach { key, value in
            request.addValue(value, forHTTPHeaderField: key)
        }

        if let body = body {
            let data = try JSONSerialization.data(withJSONObject: body)
            request.httpBody = data
        }

        return request
    }
}

