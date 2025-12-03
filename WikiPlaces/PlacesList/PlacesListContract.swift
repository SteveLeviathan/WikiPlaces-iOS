import Foundation

protocol PlacesListConfiguring {
    func configurePlacesListView() -> PlacesListView
}

protocol PlacesListDisplaying: AnyObject {
    func displayPlaces(viewModel: PlacesList.LoadPlaces.ViewModel)
    func displayInvalidDeepLink(viewModel: PlacesList.PrepareDeepLink.ViewModel)
}

protocol PlacesListInteracting {
    func loadPlaces(request: PlacesList.LoadPlaces.Request) async
    func prepareDeepLink(request: PlacesList.PrepareDeepLink.Request)
    func handleDeepLinkingError(response: PlacesList.PrepareDeepLink.Response)
}

protocol PlacesListPresenting {
    func presentLocations(response: PlacesList.LoadPlaces.Response)
    func presentDeepLinkingError(response: PlacesList.PrepareDeepLink.Response)
}

protocol PlacesListRouting {
    func routeWithDeepLink(routingContext: PlacesList.PrepareDeepLink.RoutingContext)
}
