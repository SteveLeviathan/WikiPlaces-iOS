import Foundation
import UIKit

protocol UIApplicationType: AnyObject {
    func open(_ url: URL, options: [UIApplication.OpenExternalURLOptionsKey: Any], completionHandler completion: (@MainActor @Sendable (Bool) -> Void)?)
    func canOpenURL(_ url: URL) -> Bool
}

extension UIApplicationType {
    func open(_ url: URL) {
        open(url, options: [:], completionHandler: nil)
    }
}

extension UIApplication: UIApplicationType {}
