import UIKit
import DTTableViewManager
import DTModelStorage
import PKHUD
import SafariServices


class FeedListViewController: ConfigurableViewController, DTTableViewManageable {
  
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var noContentLabel: UILabel!
  private var refreshControl: UIRefreshControl!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configuration = .navigationBarVisible
    navigationItem.title = "RSS Feed".localized
    setupRefreshControl()
    setupTableView()
    setupNoContentView()
    fetchRSSFeed()
  }
  
  // MARK: - Private Functions
  private func fetchRSSFeed() {
    HUD.show(.progress)
    
    RSSFeedService.loadRSSFeed { [weak self] items, errorOrNil in
      HUD.hide()
      
      guard let `self` = self else { return }
      self.refreshControl.endRefreshing()
      self.manager.memoryStorage.setItems(items)
      self.updateUI()
      
      if let error = errorOrNil {
        HUD.flash(.labeledError(title: "Ooops!", subtitle: error.localizedDescription), delay: 2.0)
      }
    }
  }
  
  private func setupRefreshControl() {
    refreshControl = UIRefreshControl()
    refreshControl.addTarget(self, action: #selector(refreshFeed), for: .valueChanged)
  }
  
  private func setupTableView() {
    tableView.estimatedRowHeight = 60.0
    tableView.rowHeight = 60
    
    if #available(iOS 10.0, *) {
      tableView.refreshControl = refreshControl
    } else {
      tableView.addSubview(refreshControl)
    }
    
    manager.register(FeedItemTableViewCell.self)
    manager.startManaging(withDelegate: self)
    
    manager.didSelect(FeedItemTableViewCell.self) { [weak self] cell, model, indexPath in
      self?.tableView.deselectRow(at: indexPath, animated: true)
      
      guard let feedItemVC = FeedItemViewController.instantiate() else { return }
      feedItemVC.feedItem = model
      self?.navigationController?.pushViewController(feedItemVC, animated: true)
      
//      let config = SFSafariViewController.Configuration()
//      config.entersReaderIfAvailable = true
//      let vc = SFSafariViewController(url: model.link, configuration: config)
//      self?.present(vc, animated: true)
    }
    
    manager.tableViewUpdater?.didUpdateContent = { [weak self] _ in
      self?.updateUI()
    }
  }
  
  private func setupNoContentView() {
    noContentLabel.isHidden = true
    noContentLabel.text = "Sorry, there are no feed entries.".localized
  }
  
  @objc private func refreshFeed() {
    refreshControl.beginRefreshing()
    fetchRSSFeed()
  }
  
  private func updateUI() {
    if (manager.storage.sections.first?.numberOfItems ?? 0) > 0 {
      //tableView.isHidden = false
      noContentLabel.isHidden = true
    } else {
      //tableView.isHidden = true
      noContentLabel.isHidden = false
    }
  }
  
}
