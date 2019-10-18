import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    typealias UIViewType = WKWebView

    var url: URL

    func makeUIView(context: UIViewRepresentableContext<WebView>) -> WKWebView {
        let webView = WKWebView()
        webView.load(URLRequest(url: url))
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: UIViewRepresentableContext<WebView>) {}

    static var autoload: some View {
        WebView(url: URL(string: "https://www.studentenwerk-dresden.de/mensen/emeal-autoload.html")!)
            .navigationBarTitle("Autoload", displayMode: .inline)
    }
}
