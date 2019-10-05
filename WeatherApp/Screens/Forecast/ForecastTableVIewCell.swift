import UIKit
import WeatherAppShared
import TableKit
import WeatherAppCore

private let dateFormatter: DateFormatter = execute {
  let dateFormatter = DateFormatter()
  dateFormatter.dateFormat = "EEEE"
  return dateFormatter
}

class ForecastTableViewCell: UITableViewCell, ConfigurableCell {
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: .value2, reuseIdentifier: reuseIdentifier)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func configure(with model: Weather.Forecast) {
    textLabel?.text = dateFormatter.string(from: model.date)
    detailTextLabel?.text = "\(Int(model.high)) \(Int(model.low))"
  }
}

