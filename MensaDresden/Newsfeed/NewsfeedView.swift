import SwiftUI
import os.log

struct NewsfeedView: View {
    @EnvironmentObject private var feedparser: Feedparser
    @State private var selectedDetail: URL? = nil

    var body: some View {
        NavigationView {
            LoadingListView(
                result: feedparser.newsItems,
                noDataMessage: "",
                retryAction: {
                    Task { await feedparser.fetchNews() }
                },
                listView: { newsItems in
                    List(newsItems) { item in
                        NewsItemView(newsItem: item)
                            .onTapGesture {
                                selectedDetail = item.detailURL
                            }
                    }
                    .refreshable {
                        await feedparser.fetchNews()
                    }
                }
            )
            .navigationTitle(L10n.Tab.newsfeed)
        }
        .sheet(item: $selectedDetail) { detailURL in
            SafariView(url: detailURL)
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
        }
    }
}

struct NewsfeedView_Previews: PreviewProvider {
    static var previews: some View {
        NewsfeedView()
            .environmentObject(Feedparser())
    }
}
