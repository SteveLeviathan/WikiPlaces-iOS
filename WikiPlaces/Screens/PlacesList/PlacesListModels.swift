import Foundation

enum PlacesList {
    struct Place: Identifiable, Equatable {
        let id: String = UUID().uuidString
        let name: String
        let latitude: Double
        let longitude: Double
    }

    enum LoadPlaces {
        struct Request {}

        struct Response {
            let locations: [Location]
            let errorMessage: String?
        }

        struct ViewModel {
            let places: [Place]
            let errorMessage: String?
        }
    }

    enum PrepareDeepLink {
        struct Request {
            let name: String
            let latitude: Double
            let longitude: Double
        }

        struct Response {
            let errorMessage: String
        }

        struct RoutingContext {
            let url: URL?
        }

        struct ViewModel {
            let errorTitle: String
            let errorMessage: String
        }
    }
}
