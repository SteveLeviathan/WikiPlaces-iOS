import Foundation

enum ApiClientError: LocalizedError {
    case requestError(Int)
    case decodingError(Error)
    case networkError(Error)

    var errorDescription: String? {
        switch self {
        case .requestError(let code):
            return "Request failed with status code: \(code)"
        case .decodingError(let error):
            return "Failed to decode data: \(error.localizedDescription)"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        }
    }
}

protocol APIClientType {
    func request<T: Decodable>(_ endpoint: APIRouteType) async throws -> T
}

struct APIClient: APIClientType {
    let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func request<T>(_ endpoint: any APIRouteType) async throws -> T where T : Decodable {
        let request = try endpoint.asURLRequest()
        do {
            let (data, response) = try await session.data(for: request)

            if let http = response as? HTTPURLResponse,
               !(200...299).contains(http.statusCode) {
                throw ApiClientError.requestError(http.statusCode)
            }

            do {
                if let jsonString = String(data: data, encoding: .utf8) {
                   print("jsonString: \(jsonString)")
                }

                return try JSONDecoder().decode(T.self, from: data)
            } catch {
                if error is DecodingError {
                    throw ApiClientError.decodingError(error)
                } else {
                    throw ApiClientError.networkError(error)
                }
            }
        } catch {
            throw ApiClientError.networkError(error)
        }
    }
}
