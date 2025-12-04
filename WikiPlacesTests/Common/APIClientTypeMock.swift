@testable import WikiPlaces
import Foundation

final class APIClientTypeMock: APIClientType {
    var requestAPIRouteCalled = false
    var requestAPIRouteReceivedAPIRoute: APIRouteType?
    var requestAPIRouteReturnValue: Any?

    func request<T: Decodable>(_ apiRoute: APIRouteType) async throws -> T {
        requestAPIRouteCalled = true
        requestAPIRouteReceivedAPIRoute = apiRoute

        guard requestAPIRouteReturnValue == nil else {
            return requestAPIRouteReturnValue as! T
        }

        throw APIClientError.networkError(
            NSError(
                domain: "APIClientTypeMock",
                code: 1,
                userInfo: [NSLocalizedDescriptionKey: "Mocked API call failed"]
            )
        )
    }
}
