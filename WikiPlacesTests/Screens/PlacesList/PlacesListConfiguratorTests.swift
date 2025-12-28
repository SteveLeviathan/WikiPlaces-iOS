import XCTest
@testable import WikiPlaces

@MainActor
final class PlacesListConfiguratorTests: XCTestCase {

    @MainActor
    final class PlacesListConfigurationUnwrapper: Sendable {
        private let configuredView: PlacesListView

        var presenter: PlacesListPresenter {
            return interactor.presenter as! PlacesListPresenter
        }


        var interactor: PlacesListInteractor {
            return configuredView.interactor as! PlacesListInteractor
        }

        var router: PlacesListRouter {
            return interactor.router as! PlacesListRouter
        }

        init(configuredView: PlacesListView) {
            self.configuredView = configuredView
        }
    }

    var configuredView: PlacesListView!
    var presenter: PlacesListPresenter!
    var interactor: PlacesListInteractor!
    var router: PlacesListRouter!

    override func setUp() async throws {
        try await super.setUp()
        configuredView = PlacesListConfigurator().configurePlacesListView()
        let unwrapper = PlacesListConfigurationUnwrapper(configuredView: configuredView)

        presenter = unwrapper.presenter
        router = unwrapper.router
        interactor = unwrapper.interactor
    }

    override func tearDown() async throws {
        try await super.tearDown()
        presenter = nil
        interactor = nil
        router = nil
        configuredView = nil
    }

    func testSettingUpViewDependencies() {
        XCTAssertEqual(
            ObjectIdentifier(configuredView.interactor as AnyObject),
            ObjectIdentifier(interactor as AnyObject)
        )

        XCTAssertEqual(
            ObjectIdentifier(configuredView.presenter as AnyObject),
            ObjectIdentifier(presenter as AnyObject)
        )
    }

    func testSettingUpInteractorDependencies() {
        XCTAssertEqual(
            ObjectIdentifier(interactor.presenter as AnyObject),
            ObjectIdentifier(presenter as AnyObject)
        )

        XCTAssertEqual(
            ObjectIdentifier(interactor.router as AnyObject),
            ObjectIdentifier(router as AnyObject)
        )
    }
}
