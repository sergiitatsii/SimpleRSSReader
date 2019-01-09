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
      
      let items = feed.items?.compactMap { FeedItem(title: $0.title!, link: URL(string:$0.link!)!) }
      DispatchQueue.main.async {
        completion(items!, nil)
      }
    }
  }

}
