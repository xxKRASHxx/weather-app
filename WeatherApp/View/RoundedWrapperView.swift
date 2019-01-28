import UIKit

class RoundedWrapperView<Base: UIView>: UIView {
  
  let base = Base()
  
  var isTouched: Bool = false {
    didSet {
      var transform = CGAffineTransform.identity
      if isTouched { transform = transform.scaledBy(x: 0.96, y: 0.96) }
      UIView.animate(
        withDuration: 0.3,
        delay: 0,
        usingSpringWithDamping: 0.8,
        initialSpringVelocity: 0,
        options: [],
        animations: {
          self.transform = transform
      },
        completion: nil)
    }
  }
  
  required init?(coder aDecoder: NSCoder) { fatalError() }
  override init(frame: CGRect) {
    super.init(frame: frame)
    base.layer.cornerRadius = 12
    base.layer.masksToBounds = true
    layer.shadowColor = UIColor.black.cgColor
    layer.shadowRadius = 12
    layer.shadowOpacity = 0.15
    layer.shadowOffset = CGSize(width: 0, height: 8)
    addSubview(base)
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    if base.superview == self {
      base.frame = bounds
    }
    layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: layer.cornerRadius).cgPath
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesBegan(touches, with: event)
    isTouched = true
  }
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesEnded(touches, with: event)
    isTouched = false
  }
  override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesCancelled(touches, with: event)
    isTouched = false
  }
}

