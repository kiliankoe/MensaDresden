import SwiftUI
import CoreLocation

struct CompassView: View {
    @ObservedObject var userLocation = UserLocation.shared
    var dest: CLLocationCoordinate2D

    init(towards: CLLocationCoordinate2D) {
        self.dest = towards
    }

    private var bearing: Double {
        guard let loc = userLocation.lastLocation?.coordinate else { return 0 }

        let ΔL = loc.longitude - dest.longitude
        let X = cos(dest.latitude.radians) * sin(ΔL.radians)
        let Y = cos(loc.latitude.radians) * sin(dest.latitude.radians) - sin(loc.latitude.radians) * cos(dest.latitude.radians) * cos(ΔL.radians)
        let bearing = atan2(X, Y)
        return bearing
    }

    private var heading: Angle {
        guard let userHeading = userLocation.currentHeading?.trueHeading else { return .zero }
        return Angle(radians: bearing) - Angle(degrees: userHeading)
    }

    var body: some View {
        Image(systemName: "arrow.up.circle")
            .rotationEffect(heading)
    }
}

struct CompassView_Previews: PreviewProvider {
    static var previews: some View {
        CompassView(towards: CLLocationCoordinate2D(latitude: 51.026819, longitude: 13.726348))
            .padding()
            .previewLayout(.sizeThatFits)

    }
}

private extension Double {
    var radians: Double {
        self * .pi / 180
    }
}
