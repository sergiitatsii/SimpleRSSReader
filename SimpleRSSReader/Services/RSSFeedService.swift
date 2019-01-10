import Foundation
import FeedKit

typealias Completion = ([FeedItem], Error?) -> Void

enum RSSFeedServiceError: Error {
  case invalidURL(String)
}

protocol RSSFeedServiceType {
  static func loadRSSFeed(completion: @escaping Completion)
}

class RSSFeedService: RSSFeedServiceType {
  
  private static let urlString = "https://www.wired.com/feed/rss"
  
  static func loadRSSFeed(completion: @escaping Completion) {
    guard let feedURL = URL(string: urlString) else {
      completion([], RSSFeedServiceError.invalidURL(urlString))
      return
    }
    
    let parser = FeedParser(URL: feedURL)
    parser.parseAsync(queue: DispatchQueue.global(qos: .userInitiated)) { result in
      guard let feed = result.rssFeed, result.isSuccess else {
        DispatchQueue.main.async {
          completion([], result.error)
        }
        return
      }
      
      var feedItems = [FeedItem]()
      
      if let items = feed.items {
        for item in items {
          if let title = item.title, let link = item.link, let url = URL(string: link) {
            feedItems.append(FeedItem(title: title, link: url))
          }
        }
      }
      
      DispatchQueue.main.async {
        completion(feedItems, nil)
      }
    }
  }

}
