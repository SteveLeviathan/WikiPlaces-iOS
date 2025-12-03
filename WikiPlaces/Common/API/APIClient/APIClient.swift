import Foundation

enum APIClientError: LocalizedError {
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
    func request<T: Decodable>(_ apiRoute: APIRouteType) async throws -> T
}

struct APIClient: APIClientType {
    let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func request<T>(_ apiRoute: any APIRouteType) async throws -> T where T : Decodable {
        let request = try apiRoute.asURLRequest()
        do {
            let (data, response) = try await session.data(for: request)

            if let http = response as? HTTPURLResponse,
               !(200...299).contains(http.statusCode) {
                throw APIClientError.requestError(http.statusCode)
            }

            do {
                return try JSONDecoder().decode(T.self, from: data)
            } catch {
                if error is DecodingError {
                    throw APIClientError.decodingError(error)
                } else {
                    throw APIClientError.networkError(error)
                }
            }
        } catch {
            throw APIClientError.networkError(error)
        }
    }
}
