import SwiftUI
import os.log

struct NewsfeedView: View {
    @EnvironmentObject private var feedparser: Feedparser

    var body: some View {
        NavigationView {
            LoadingListView(
                result: feedparser.newsItems,
                noDataMessage: "TODO",
                retryAction: {
                    Task { await feedparser.fetchNews() }
                },
                listView: { newsItems in
                    List(newsItems) { item in
                        NewsItemView(newsItem: item)
                    }
                    .refreshable {
                        await feedparser.fetchNews()
                    }
                }
            )
            .navigationTitle(L10n.Tab.newsfeed)
        }
        .task {
            await feedparser.fetchNews()
        }
        .onAppear {
            Logger.breadcrumb.info("Appear NewsfeedView")
        }
    }
}

struct NewsItemView: View {
    let newsItem: NewsItem

    @State private var showingDetails = false

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text(Formatter.string(for: newsItem.date,
                                      dateStyle: .short,
                                      timeStyle: .short))
                    .font(.caption)
                    .foregroundColor(.gray)
                Text(newsItem.title)
                    .bold()
                Text(newsItem.description)
            }

            Spacer()
            DisclosureIndicator()
        }
        .onTapGesture {
            self.showingDetails.toggle()
        }
        .sheet(isPresented: $showingDetails) {
            SafariView(url: newsItem.detailURL)
        }
    }
}

struct NewsfeedView_Previews: PreviewProvider {
    static var previews: some View {
        NewsfeedView()
            .environmentObject(Feedparser())
    }
}
