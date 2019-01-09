import UIKit
import WebKit
import PKHUD

class FeedItemViewController: ConfigurableViewController, WKUIDelegate {
  
  var webView: WKWebView!
  var refreshButton: UIBarButtonItem?
  var feedItem: FeedItem?
  
  override func loadView() {
    let webConfiguration = WKWebViewConfiguration()
    webView = WKWebView(frame: .zero, configuration: webConfiguration)
    webView.uiDelegate = self
    webView.navigationDelegate = self
    view = webView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configuration = .navigationBarVisible
    setupRefreshButton()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    loadContent()
  }
  
  // MARK: - Private Functions
  private func setupRefreshButton() {
    refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshContent))
    navigationItem.rightBarButtonItem = refreshButton
  }
  
  private func loadContent() {
    guard let url = feedItem?.link else {
      HUD.flash(.labeledError(title: "Ooops!", subtitle: "Unable to load the feed."), delay: 2.0)
      return
    }
    HUD.show(.progress)
    webView.load(URLRequest(url: url))
    updateUI()
  }
  
  @objc private func refreshContent() {
    if !webView.isLoading {
      webView.reload()
      updateUI()
    }
  }
  
  private func updateUI() {
    refreshButton?.isEnabled = !webView.isLoading
  }
  
}

// MARK: - WKNavigationDelegate
extension FeedItemViewController: WKNavigationDelegate {
  
  func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
    
  }
  
  func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
    HUD.hide()
  }
  
  func webView(_ webView: WKWebView,
               didFail navigation: WKNavigation!,
               withError error: Error)
  {
    HUD.hide()
    HUD.flash(.labeledError(title: "Ooops!", subtitle: error.localizedDescription), delay: 2.0)
    updateUI()
  }
  
  func webView(_ webView: WKWebView,
               didFailProvisionalNavigation navigation: WKNavigation!,
               withError error: Error)
  {
    HUD.hide()
    HUD.flash(.labeledError(title: "Ooops!", subtitle: error.localizedDescription), delay: 2.0)
    updateUI()
  }
  
  func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    HUD.hide()
    updateUI()
  }
  
}
