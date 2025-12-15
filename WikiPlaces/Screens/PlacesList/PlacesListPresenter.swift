import Foundation

@MainActor
@Observable
final class PlacesListPresenter: PlacesListPresenting {
    enum LoadingState {
        case idle
        case loading
        case error
    }

    var loadingState: LoadingState = .idle

    struct PlacesDataStore {
        var remotePlaces: [PlacesList.Place] = []
        var localPlaces: [PlacesList.Place] = []
    }

    var placesDataStore = PlacesDataStore()

    var errorMessage: String?

    var showAlert = false
    var alertTitle = ""
    var alertMessage = ""

    func presentLocations(response: PlacesList.LoadPlaces.Response) {
        let places: [PlacesList.Place] = response.locations.map {
            PlacesList.Place(name: $0.name ?? "Unnamed place", latitude: $0.lat, longitude: $0.long)
        }

        if let errorMessage = response.errorMessage {
            loadingState = .error
            self.errorMessage = errorMessage
            return
        }

        loadingState = .idle
        placesDataStore.remotePlaces = places
    }

    func presentDeepLinkingError(response: PlacesList.PrepareDeepLink.Response) {
        showAlert = true
        alertTitle = "Attention"
        alertMessage = response.errorMessage
    }
}
