import Foundation

@MainActor
final class PlacesListPresenter: PlacesListPresenting {
    weak var view: PlacesListDisplaying?

    func presentLocations(response: PlacesList.LoadPlaces.Response) {
        let places: [PlacesList.Place] = response.locations.map {
            PlacesList.Place(name: $0.name ?? "Unnamed place", latitude: $0.lat, longitude: $0.long)
        }

        let viewModel = PlacesList.LoadPlaces.ViewModel(
            places: places,
            errorMessage: response.errorMessage)

        view?.displayPlaces(viewModel: viewModel)
    }

    func presentDeepLinkingError(response: PlacesList.PrepareDeepLink.Response) {
        view?.displayInvalidDeepLink(viewModel: .init(errorTitle: "Attention", errorMessage: response.errorMessage))
    }
}
