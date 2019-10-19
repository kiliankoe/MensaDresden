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
                Text("info.image-rights").bold() + Text("Studentenwerk Dresden")
                Text("info.icon").bold() + Text("info.nounproject")

                Text("info.thanks")
                    .font(.caption)
                    .padding(.top)
            }
            .padding(.horizontal)

            VStack(alignment: .leading) {
                Button(
                    action: {
                        UIApplication.shared.open(URL(string: "https://github.com/kiliankoe/MensaDresden")!)
                    },
                    label: {
                        HStack {
                            Image(systemName: "desktopcomputer")
                            Text("info.opensource")
                        }
                })

                Button(
                    action: {
                        UIApplication.shared.open(URL(string: "mailto:me@kilian.io?subject=Mensa%20Dresden")!)
                    },
                    label: {
                        HStack {
                            Image(systemName: "envelope")
                            Text("info.email")
                        }
                })

                Button(
                    action: {
                        UIApplication.shared.open(URL(string: "https://testflight.apple.com/join/xE99ppRh")!)
                    },
                    label: {
                        HStack {
                            Image(systemName: "ant")
                            Text("info.testflight")
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
