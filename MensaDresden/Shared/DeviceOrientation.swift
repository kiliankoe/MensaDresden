import Foundation
import SwiftUI
import Combine
import os.log

class DeviceOrientation: ObservableObject {
    @Published var isLandscape: Bool

    init(isLandscape: Bool) {
        self.isLandscape = isLandscape
        NotificationCenter.default.addObserver(self, selector: #selector(onViewWillTransition(notification:)), name: .md_onViewWillTransition, object: nil)
    }

    @objc func onViewWillTransition(notification: Notification) {
        guard let size = notification.userInfo?["size"] as? CGSize else { return }
        isLandscape = size.width > size.height
        Logger.deviceOrientation.info("Shifting orientation to \(self.isLandscape ? "landscape" : "portrait")")
    }
}

extension Notification.Name {
    static let md_onViewWillTransition = Notification.Name("MainUIHostingController_viewWillTransition")
}
