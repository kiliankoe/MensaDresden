import SwiftUI

class HostingController<Content> : UIHostingController<Content> where Content: View {
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        NotificationCenter.default.post(name: .md_onViewWillTransition, object: nil, userInfo: ["size": size])
    }
}
