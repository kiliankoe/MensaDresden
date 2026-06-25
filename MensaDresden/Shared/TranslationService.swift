import Foundation
import Translation

class TranslationService: ObservableObject {
    static let shared = TranslationService()

    @Published var hasPromptedUser: Bool {
        didSet {
            UserDefaults.standard.set(hasPromptedUser, forKey: "hasPromptedForTranslation")
        }
    }

    private init() {
        self.hasPromptedUser = UserDefaults.standard.bool(forKey: "hasPromptedForTranslation")
    }

    var shouldTranslate: Bool {
        #if targetEnvironment(simulator)
        return false
        #else
        if #available(iOS 18, watchOS 9, *) {
            return Locale.current.language.languageCode?.identifier != "de"
        }
        return false
        #endif
    }
}
