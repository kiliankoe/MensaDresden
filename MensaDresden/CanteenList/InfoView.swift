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
            HStack {
                Text("Version \(shortVersion)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding(.trailing, 2)
                Text("Build \(version)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }.padding(.bottom)

            VStack(alignment: .leading) {
                Text("Image Rights: ").bold() + Text("Studentenwerk Dresden")
                Text("Icon: ").bold() + Text("Eddy Wong from the Noun Project")
            }

            HStack {
                Button(action: {
                    UIApplication.shared.open(URL(string: "mailto:me@kilian.io?subject=Mensa%20Dresden")!, options: [:])
                }) {
                    HStack {
                        Image(systemName: "envelope")
                            .font(.system(size: 20))
                            .padding()
                        Text("Feedback")
                            .font(.system(size: 20))
                    }
                }
            }

            Spacer()
        }
    }
}

struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        InfoView()
    }
}
