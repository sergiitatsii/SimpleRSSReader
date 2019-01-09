import WebKit

extension WKWebView {
  
  func loadUrl(string: String) {
    if let url = URL(string: string) {
      load(URLRequest(url: url))
    }
  }
  
}
