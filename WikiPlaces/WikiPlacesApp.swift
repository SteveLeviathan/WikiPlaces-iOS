import SwiftUI

@main
struct WikiPlacesApp: App {
    var body: some Scene {
        WindowGroup {
            if isRunningTests {
                Text("Running tests!")
            } else {
                PlacesListConfigurator().configurePlacesListView()
            }
        }
    }

    var isRunningTests: Bool {
        NSClassFromString("XCTestCase") != nil
    }
}

