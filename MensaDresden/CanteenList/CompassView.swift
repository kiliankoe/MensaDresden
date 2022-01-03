import SwiftUI
import CoreLocation

struct CompassView: View {
    @EnvironmentObject var locationManager: LocationManager

    var compassHeading: Double {
        locationManager.currentHeading?.magneticHeading ?? 0
    }

    var userPosition: CLLocationCoordinate2D {
        locationManager.lastLocation?.coordinate ?? CLLocationCoordinate2D()
    }

    var destination: CLLocationCoordinate2D

    var destinationBearing: Double {
        let deltaL = destination.longitude.radians - userPosition.longitude.radians
        let thetaB = destination.latitude.radians
        let thetaA = userPosition.latitude.radians

        let x = cos(thetaB) * sin(deltaL)
        let y = cos(thetaA) * sin(thetaB) - sin(thetaA) * cos(thetaB) * cos(deltaL)
        let bearing = atan2(x,y)

        return bearing.degrees
    }

    var destinationHeading: Double {
        destinationBearing - compassHeading
    }

    init(towards: CLLocationCoordinate2D) {
        self.destination = towards
    }

    var body: some View {
        Image(systemName: "arrow.up.circle")
            .font(.system(size: 15))
            .rotationEffect(.degrees(destinationHeading))
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
        Measurement(value: self, unit: UnitAngle.degrees)
            .converted(to: .radians)
            .value
    }

    var degrees: Double {
        Measurement(value: self, unit: UnitAngle.radians)
            .converted(to: .degrees)
            .value
    }
}
