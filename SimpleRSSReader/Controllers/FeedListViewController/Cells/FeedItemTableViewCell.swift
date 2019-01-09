import UIKit
import DTModelStorage

class FeedItemTableViewCell: UITableViewCell, ModelTransfer {
  
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var linkLabel: UILabel!
  
  func update(with model: FeedItem) {
    titleLabel.text = model.title
    linkLabel.text = model.link.absoluteString
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    accessoryType = .disclosureIndicator
    titleLabel.text = nil
    linkLabel.text = nil
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    titleLabel.text = nil
    linkLabel.text = nil
  }
  
}
