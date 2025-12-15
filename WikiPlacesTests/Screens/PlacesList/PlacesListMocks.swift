@testable import WikiPlaces

final class PlacesListInteractingMock: PlacesListInteracting {
    var presenter: PlacesListPresenting
    var router: PlacesListRouting

    init(presenter: PlacesListPresenting, router: PlacesListRouting) {
        self.presenter = presenter
        self.router = router
    }

    var loadPlacesRequestCalled = false
    var loadPlacesRequestReceivedRequest: PlacesList.LoadPlaces.Request?

    func loadPlaces(request: PlacesList.LoadPlaces.Request) async {
        loadPlacesRequestCalled = true
        loadPlacesRequestReceivedRequest = request
    }

    var prepareDeepLinkRequestCalled = false
    var prepareDeepLinkRequestReceivedRequest: PlacesList.PrepareDeepLink.Request?

    func prepareDeepLink(request: PlacesList.PrepareDeepLink.Request) {
        prepareDeepLinkRequestCalled = true
        prepareDeepLinkRequestReceivedRequest = request
    }

    var handleDeepLinkingErrorResponseCalled = false
    var handleDeepLinkingErrorResponseReceivedResponse: PlacesList.PrepareDeepLink.Response?

    func handleDeepLinkingError(response: PlacesList.PrepareDeepLink.Response) {
        handleDeepLinkingErrorResponseCalled = true
        handleDeepLinkingErrorResponseReceivedResponse = response
    }
}

final class PlacesListPresentingMock: PlacesListPresenting {
    var presentLocationsResponseCalled = false
    var presentLocationsResponseReceivedResponse: PlacesList.LoadPlaces.Response?

    func presentLocations(response: PlacesList.LoadPlaces.Response) {
        presentLocationsResponseCalled = true
        presentLocationsResponseReceivedResponse = response
    }

    var presentDeepLinkingErrorResponseCalled = false
    var presentDeepLinkingErrorResponseReceivedResponse: PlacesList.PrepareDeepLink.Response?

    func presentDeepLinkingError(response: PlacesList.PrepareDeepLink.Response) {
        presentDeepLinkingErrorResponseCalled = true
        presentDeepLinkingErrorResponseReceivedResponse = response
    }
}

final class PlacesListRoutingMock: PlacesListRouting {
    var interactor: PlacesListInteracting?

    var routeWithDeepLinkRoutingContextCalled = false
    var routeWithDeepLinkRoutingContextReceivedRoutingContext: PlacesList.PrepareDeepLink.RoutingContext?

    func routeWithDeepLink(routingContext: PlacesList.PrepareDeepLink.RoutingContext) {
        routeWithDeepLinkRoutingContextCalled = true
        routeWithDeepLinkRoutingContextReceivedRoutingContext = routingContext
    }
}
