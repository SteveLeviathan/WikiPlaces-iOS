import Foundation

protocol PlacesListConfiguring {
    func configurePlacesListView() -> PlacesListView
}

protocol PlacesListDisplaying: AnyObject {
    func displayPlaces(viewModel: PlacesList.LoadPlaces.ViewModel)
    func displayInvalidDeepLink(viewModel: PlacesList.PrepareDeepLink.ViewModel)
}

protocol PlacesListInteracting: AnyObject {
    var presenter: PlacesListPresenting { get set }
    var router: PlacesListRouting { get set }

    func loadPlaces(request: PlacesList.LoadPlaces.Request) async
    func prepareDeepLink(request: PlacesList.PrepareDeepLink.Request)
    func handleDeepLinkingError(response: PlacesList.PrepareDeepLink.Response)
}

protocol PlacesListPresenting {
    var view: PlacesListDisplaying? { get set }

    func presentLocations(response: PlacesList.LoadPlaces.Response)
    func presentDeepLinkingError(response: PlacesList.PrepareDeepLink.Response)
}

protocol PlacesListRouting {
    var interactor: PlacesListInteracting? { get set }

    func routeWithDeepLink(routingContext: PlacesList.PrepareDeepLink.RoutingContext)
}
