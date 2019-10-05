import UIKit
import TableKit

class SearchTableViewCell: UITableViewCell, ConfigurableCell {
  
  private(set) var model: SearchResultViewModel?
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    backgroundColor = .clear
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func configure(with model: SearchResultViewModel) {
    self.model = model
    textLabel?.text = model.searchResult.qualifiedName
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    model = nil
  }
}
