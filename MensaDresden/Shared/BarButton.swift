import SwiftUI

struct BarButtonNavigationLink<DestinationView: View>: View {
    var destination: DestinationView
    var image: Image

    var body: some View {
        NavigationLink(destination: destination) {
            image
        }
    }
}

struct BarButtonButton<ButtonView: View>: View {
    var view: ButtonView
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            view
        }
    }
}

struct BarButton_Previews: PreviewProvider {
    static var previews: some View {
        BarButtonNavigationLink(destination: Text("Foo"), image: Image(systemName: "square.and.arrow.up"))
    }
}
