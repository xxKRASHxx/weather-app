import UIKit
import SnapKit

class CardView: UIView {
  let titleLabel = UILabel()
  let subtitleLabel = UILabel()
  let imageView = UIImageView()
  let locationIcon = UIImageView(image: #imageLiteral(resourceName: "current_location"))
  let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
  let vibrancyEffectView = UIVisualEffectView(effect: UIVibrancyEffect(blurEffect: UIBlurEffect(style: .light)))
  
  required init?(coder aDecoder: NSCoder) { fatalError() }
  override init(frame: CGRect) {
    super.init(frame: frame)
    clipsToBounds = true
    setupViewHierarchy()
    setupLayout()
    setupStyle()
  }
  
  private func setupViewHierarchy() {
    addSubview(imageView)
    addSubview(visualEffectView)
    visualEffectView.contentView.addSubview(vibrancyEffectView)
    vibrancyEffectView.contentView.addSubview(titleLabel)
    vibrancyEffectView.contentView.addSubview(subtitleLabel)
    vibrancyEffectView.contentView.addSubview(locationIcon)
  }
  
  private func setupLayout() {
    imageView.snp.makeConstraints { make in
      make.edges.equalTo(self)
    }
    titleLabel.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(8)
      make.left.equalToSuperview().offset(8)
    }
    locationIcon.setContentHuggingPriority(UILayoutPriority(rawValue: 500), for: .horizontal)
    locationIcon.snp.makeConstraints { make in
      make.centerY.equalTo(titleLabel)
      make.left.equalTo(titleLabel.snp.right).offset(8)
      make.right.equalToSuperview().offset(-8)
    }
    subtitleLabel.snp.makeConstraints { make in
      make.top.equalTo(titleLabel.snp.bottom).offset(8)
      make.leading.equalTo(titleLabel.snp.leading)
      make.right.equalToSuperview().offset(8)
      make.bottom.equalTo(vibrancyEffectView).offset(-8)
    }
    visualEffectView.snp.makeConstraints { make in
      make.top.equalToSuperview()
      make.left.equalToSuperview()
      make.right.equalToSuperview()
    }
    vibrancyEffectView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }
  
  private func setupStyle() {
    titleLabel.numberOfLines = 0
    subtitleLabel.numberOfLines = 0
    
    titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
    subtitleLabel.font = UIFont.systemFont(ofSize: 12)
    
    imageView.contentMode = .scaleAspectFill
    locationIcon.isHidden = true
  }
}
