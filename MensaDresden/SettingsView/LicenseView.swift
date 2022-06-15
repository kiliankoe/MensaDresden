import Foundation
import SwiftUI

import EmealKit

struct License: Identifiable {
    var dependencyName: String
    var licenseText: String

    var id: String { dependencyName }
}

struct LicenseView: View {
    var body: some View {
        List(License.all) { license in
            NavigationLink {
                ScrollView {
                    Text(license.licenseText)
                        .padding(.horizontal)
                }
            } label: {
                Text(license.dependencyName)
            }
        }
        .navigationTitle(L10n.Licenses.title)
    }
}

struct LicenseView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            LicenseView()
        }
    }
}
