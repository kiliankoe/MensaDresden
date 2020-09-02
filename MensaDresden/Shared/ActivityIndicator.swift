import SwiftUI

#warning("Delete me when dropping iOS 13.")
struct ProgressView: View {
    var body: some View {
        if #available(iOS 14, *) {
            SwiftUI.ProgressView()
        } else {
            _ActivityIndicator()
        }
    }
}

fileprivate struct _ActivityIndicator: UIViewRepresentable {
    typealias UIViewType = UIActivityIndicatorView

    func makeUIView(context: UIViewRepresentableContext<_ActivityIndicator>) -> UIActivityIndicatorView {
        let indicator = UIActivityIndicatorView()
        indicator.startAnimating()
        return indicator
    }

    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<_ActivityIndicator>) { }
}
