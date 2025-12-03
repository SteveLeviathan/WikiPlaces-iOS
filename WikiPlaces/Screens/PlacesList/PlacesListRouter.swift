import Foundation
import UIKit

final class PlacesListRouter: PlacesListRouting {
    weak var interactor: PlacesListInteracting?
    private let application: UIApplicationType

    init(interactor: PlacesListInteractor? = nil, application: UIApplicationType = UIApplication.shared) {
        self.interactor = interactor
        self.application = application
    }

    func routeWithDeepLink(routingContext: PlacesList.PrepareDeepLink.RoutingContext) {
        guard let url = routingContext.url, application.canOpenURL(url) else {
            handDeepLinkingError()
            return
        }

        application.open(url)
    }

    private func handDeepLinkingError() {
        interactor?.handleDeepLinkingError(response: .init(errorMessage: "Can't open invalid deep link URL!"))
    }
}
