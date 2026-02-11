import Foundation
import SyndiKit
import os.log

class Feedparser: ObservableObject {
    static let stuweNewsfeedURL = URL(string: "https://www.studentenwerk-dresden.de/feeds/news.rss")!

    @Published var newsItems: LoadingResult<[NewsItem]> = .loading

    func fetchNews() async {
        do {
            Logger.newsfeed.info("Fetching newsfeed data")
            let (feedData, _) = try await URLSession.shared.data(from: Self.stuweNewsfeedURL)
            let newsfeed = try SynDecoder().decode(feedData)
            let newsItems = newsfeed.children.map { entry in
                NewsItem(
                    title: entry.title,
                    description: entry.summary ?? "",
                    date: entry.published ?? Date(),
                    detailURL: entry.url ?? Self.stuweNewsfeedURL,
                    id: entry.id.description
                )
            }
            DispatchQueue.main.async {
                self.newsItems = .success(newsItems)
            }
        } catch {
            Logger.newsfeed.error("Error on fetching newsfeed: \(String(describing: error))")
            DispatchQueue.main.async {
                self.newsItems = .failure(error)
            }
        }
    }
}

struct NewsItem: Identifiable {
    let title: String
    let description: String
    let date: Date
    let detailURL: URL
    let id: String
}
