import Foundation

final class PlacesListInteractor: PlacesListInteracting {
    private let presenter: PlacesListPresenting
    private let router: PlacesListRouting
    private let apiClient: APIClientType
    private let coordinateValidator: CoordinateValidatorType

    init(
        presenter: PlacesListPresenting,
        router: PlacesListRouting,
        apiClient: APIClientType,
        coordinateValidator: CoordinateValidatorType) {
            self.presenter = presenter
            self.router = router
            self.apiClient = apiClient
            self.coordinateValidator = coordinateValidator
    }

    func loadPlaces(request: PlacesList.LoadPlaces.Request) async {
        var locationsResponse: LocationsResponse?

        do {
            let apiRoute = LocationsAPIRoute.getLocations
            locationsResponse = try await apiClient.request(apiRoute)

            let locations = locationsResponse?.locations ?? []
            presentLocations(locations: locations, errorMessage: nil)
        } catch {
            let errorMessage = error.localizedDescription
            presentLocations(locations: [], errorMessage: errorMessage)
        }
    }

    private func presentLocations(locations: [Location], errorMessage: String?) {
        let response = PlacesList.LoadPlaces.Response(
            locations: locations,
            errorMessage: errorMessage)

        presenter.presentLocations(response: response)
    }

    func prepareDeepLink(request: PlacesList.PrepareDeepLink.Request) {
        let name = request.name
        let latitude = request.latitude
        let longitude = request.longitude

        // Check if latitude and longitude are valid before routing with deep link
        if validCoordinates(latitude: latitude, longitude: longitude) {
            let url = DeepLink.wikipediaPlaces(
                name: name,
                latitude: String(latitude),
                longitude: String(longitude)).url

            router.routeWithDeepLink(routingContext: .init(url: url))
        } else {
            presenter.presentDeepLinkingError(response: .init(errorMessage: "Unable to deep link, the coordinates are invalid."))
        }
    }

    func handleDeepLinkingError(response: PlacesList.PrepareDeepLink.Response) {
        presenter.presentDeepLinkingError(response: response)
    }

    private func validCoordinates(latitude: Double, longitude: Double) -> Bool {
        coordinateValidator.validCoordinates(latitude: latitude, longitude: longitude)
    }
}


