import SwiftUI

struct AboutView: View {
    var shortVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
    }

    var version: String {
        Bundle.main.infoDictionary?["CFBundleVersion"] as! String
    }

    var body: some View {
        VStack {
            Image("Icon")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 150)
                .cornerRadius(30)
                .shadow(radius: 10)

            Text("Mensa Dresden")
                .font(.largeTitle)
                .fontWeight(.medium)

            Text("\(shortVersion) (\(version))")
                .font(.subheadline)
                .foregroundColor(.gray)
                .padding(.bottom)

            VStack(alignment: .leading) {
                Text("info.developed-by")
                    .font(.caption)
                    .bold()
                Button {
                    UIApplication.shared.open(URL(string: "https://twitter.com/kiliankoe")!)
                } label: {
                    Text("Kilian Költzsch")
                }
                .padding(.bottom, 10)

                Text("info.image-rights")
                    .font(.caption)
                    .bold()
                Text("Studentenwerk Dresden")
                    .padding(.bottom, 10)

                Text("info.icon")
                    .font(.caption)
                    .bold()
                Text("info.nounproject")
                    .padding(.bottom, 30)

                Text("info.thanks")
            }
            .padding(.horizontal)

            Spacer()
        }
        .onAppear {
            Analytics.send(.openedAboutView)
        }
    }
}

struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AboutView()
        }
    }
}
