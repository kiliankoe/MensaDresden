import Foundation
import SafariServices
import SwiftUI

struct SafariView {
    let url: URL

    func present() {
        let safariView = SFSafariViewController(url: self.url)
        let windowScene = (UIApplication.shared.connectedScenes.first as? UIWindowScene)
        windowScene?.windows.first?.rootViewController?.present(safariView, animated: true, completion: nil)
    }
}
