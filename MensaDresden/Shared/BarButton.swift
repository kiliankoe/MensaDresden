import SwiftUI

struct BarButtonNavigationLink<DestinationView: View>: View {
    var destination: DestinationView
    var image: Image

    var body: some View {
        NavigationLink(destination: destination) {
            image.font(.system(size: 22))
        }
    }
}

struct BarButtonButton: View {
    var action: () -> Void
    var image: Image

    var body: some View {
        Button(action: action, label: { image.font(.system(size: 22)) })
    }
}

struct BarButton_Previews: PreviewProvider {
    static var previews: some View {
        BarButtonNavigationLink(destination: Text("Foo"), image: Image(systemName: "square.and.arrow.up"))
    }
}
