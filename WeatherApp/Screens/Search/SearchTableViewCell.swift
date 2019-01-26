import UIKit
import TableKit

class SearchTableViewCell: UITableViewCell, ConfigurableCell {
  
  private(set) var model: SearchResultViewModel?
  
  func configure(with model: SearchResultViewModel) {
    self.model = model
    textLabel?.text = model.searchResult.qualifiedName
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    model = nil
  }
}
