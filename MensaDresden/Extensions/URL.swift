import Foundation

extension URL: Identifiable {
    public var id: String { self.absoluteString }
}
