import SwiftUI

struct NewsfeedView: View {
    var body: some View {
        WebView(url: URL(string: "https://www.studentenwerk-dresden.de/wirueberuns/aktuelles-uebersicht.html")!)
    }
}

struct NewsfeedView_Previews: PreviewProvider {
    static var previews: some View {
        NewsfeedView()
    }
}
