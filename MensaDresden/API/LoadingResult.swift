import Foundation

enum LoadingResult<T> {
    case success(T)
    /// Request was a success, but there's no data to be shown (e.g. no meals for that day)
    case noData
    case loading
    case failure(Error)
}

extension LoadingResult where T: RandomAccessCollection & MutableCollection {
    mutating func sort(by closure: (T.Element, T.Element) -> Bool) {
        guard case LoadingResult.success(var elements) = self else {
            return
        }
        elements.sort(by: closure)
        self = .success(elements)
    }
}

struct CachedLoadingResult<T> {
    var lastRequested: Date?
    var result: LoadingResult<T> = .loading

    init(result: LoadingResult<T>) {
        self.lastRequested = Date()
        self.result = result
    }

    func isOlder(than interval: TimeInterval) -> Bool {
        guard let lastRequested = lastRequested else { return false }
        return Date().timeIntervalSince(lastRequested) > interval
    }
}
