import Foundation

enum LoadingResult<T> {
    case loading

    case success(T)
    case failure(Error)

    init(from result: Result<T, Error>) {
        switch result {
        case .failure(let error):
            self = .failure(error)
        case .success(let value):
            self = .success(value)
        }
    }
}

struct CachedResult<T> {
    var lastRequested: Date?
    var result: Result<T, Error>

    init(result: Result<T, Error>) {
        self.lastRequested = Date()
        self.result = result
    }

    func isOlder(than interval: TimeInterval) -> Bool {
        guard let lastRequested = lastRequested else { return false }
        return Date().timeIntervalSince(lastRequested) > interval
    }
}
