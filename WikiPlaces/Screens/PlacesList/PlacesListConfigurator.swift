import Foundation

struct PlacesListConfigurator: PlacesListConfiguring {
    func configurePlacesListView() -> PlacesListView {
        let viewModel = PlacesListViewModel()
        let presenter = PlacesListPresenter()
        presenter.view = viewModel

        let apiClient: APIClientType = APIClient()
        let coordinateValidator: CoordinateValidatorType = CoordinateValidator()

        let router = PlacesListRouter()

        let interactor = PlacesListInteractor(
            presenter: presenter,
            router: router,
            apiClient: apiClient,
            coordinateValidator: coordinateValidator)

        router.interactor = interactor

        let view = PlacesListView(interactor: interactor, viewModel: viewModel)

        return view
    }
}
