import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    var coordinate: CLLocationCoordinate2D

    func makeUIView(context: Context) -> MKMapView {
        MKMapView(frame: .zero)
    }

    func updateUIView(_ view: MKMapView, context: Context) {
        let camera = MKMapCamera()
        camera.centerCoordinate = self.coordinate
        camera.pitch = 45
        camera.altitude = 200
        camera.heading = 45
        view.camera = camera

        view.pointOfInterestFilter = .excludingAll
        view.isUserInteractionEnabled = false
        view.showsBuildings = true

        view.mapType = .satelliteFlyover
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(coordinate: CLLocationCoordinate2D(latitude: 51.02696733929933, longitude: 13.726491630077364))
    }
}
