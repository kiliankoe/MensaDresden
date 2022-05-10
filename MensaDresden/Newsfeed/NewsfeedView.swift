import SwiftUI
import os.log

struct NewsfeedView: View {
    var body: some View {
        WebView.newsfeed
        .onAppear {
            Logger.breadcrumb.info("Appear NewsfeedView")
        }
    }
}

struct NewsfeedView_Previews: PreviewProvider {
    static var previews: some View {
        NewsfeedView()
    }
}
