import SwiftUI

struct InfoView: View {
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
                .font(.system(.title, design: .rounded))
            HStack(spacing: 5) {
                Text("Version \(shortVersion)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Text("Build \(version)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }.padding(.bottom)

            VStack(alignment: .leading) {
                Text("Image Rights: ").bold() + Text("Studentenwerk Dresden")
                Text("Icon: ").bold() + Text("Eddy Wong from the Noun Project")
                Text("Huge thanks to Lucas Vogel!")
            }

            VStack(alignment: .leading) {
                Button(
                    action: {
                        UIApplication.shared.open(URL(string: "https://github.com/kiliankoe/MensaDresden")!)
                    },
                    label: {
                        HStack {
                            Image(systemName: "desktopcomputer")
                            Text("This app is open source on GitHub.")
                        }
                })

                Button(
                    action: {
                        UIApplication.shared.open(URL(string: "mailto:me@kilian.io?subject=Mensa%20Dresden")!)
                    },
                    label: {
                        HStack {
                            Image(systemName: "envelope")
                            Text("Feedback? Send me an E-Mail.")
                        }
                })

                Button(
                    action: {
                        UIApplication.shared.open(URL(string: "https://testflight.apple.com/join/xE99ppRh")!)
                    },
                    label: {
                        HStack {
                            Image(systemName: "ant")
                            Text("Want to help beta test this application?")
                        }
                })
            }.padding(.top)

            Spacer()
        }
    }
}

struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            InfoView()
        }
    }
}
