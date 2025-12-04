@testable import WikiPlaces
import UIKit
import Foundation

final class UIApplicationTypeMock: UIApplicationType {
    var openURLOptionsCompletionHandlerCalled = false
    var openURLOptionsCompletionHandlerReceivedURL: URL?

    func open(_ url: URL, options: [UIApplication.OpenExternalURLOptionsKey : Any], completionHandler completion: (@MainActor @Sendable (Bool) -> Void)?) {
        openURLOptionsCompletionHandlerCalled = true
        openURLOptionsCompletionHandlerReceivedURL = url
    }

    var canOpenURLCalled = false
    var canOpenURLURLReceivedURL: URL?
    var canOpenURLURLReturnValue = false

    func canOpenURL(_ url: URL) -> Bool {
        canOpenURLCalled = true
        canOpenURLURLReceivedURL = url
        return canOpenURLURLReturnValue
    }
}
