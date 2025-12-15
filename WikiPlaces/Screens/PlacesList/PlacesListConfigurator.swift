import Foundation

struct PlacesListConfigurator: PlacesListConfiguring {
    func configurePlacesListView() -> PlacesListView {
        let presenter = PlacesListPresenter()

        let apiClient: APIClientType = APIClient()
        let coordinateValidator: CoordinateValidatorType = CoordinateValidator()

        let router = PlacesListRouter()

        let interactor = PlacesListInteractor(
            presenter: presenter,
            router: router,
            apiClient: apiClient,
            coordinateValidator: coordinateValidator)

        router.interactor = interactor

        let view = PlacesListView(interactor: interactor, presenter: presenter)

        return view
    }
}
