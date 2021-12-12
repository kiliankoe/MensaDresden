import Foundation
import EmealKit

struct CardserviceErrorWrapper: LocalizedError {
    var error: CardserviceError

    var errorDescription: String? {
        switch self.error {
        case .network:
            return L10n.Emeal.Error.network
        case .invalidURL, .invalidLoginCredentials:
            return L10n.Emeal.Error.invalidCredentials
        case .server(statusCode: let statusCode):
            return L10n.Emeal.Error.server(statusCode)
        case .decoding:
            return L10n.Emeal.Error.decoding
        case .noCardDetails:
            return L10n.Emeal.Error.noCardDetails
        case .rateLimited:
            return L10n.Emeal.Error.rateLimited
        }
    }
}
