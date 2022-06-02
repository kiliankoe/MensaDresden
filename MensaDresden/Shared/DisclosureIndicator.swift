import Foundation
import SwiftUI

struct DisclosureIndicator: View {
    var body: some View {
        Image(systemName: "chevron.right")
            .font(.footnote)
            .foregroundColor(.secondary)
            .opacity(0.5)
    }
}
