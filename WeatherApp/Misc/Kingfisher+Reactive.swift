import ReactiveSwift
import ReactiveCocoa
import Kingfisher

extension Reactive where Base: UIImageView {
  var url: BindingTarget<URL?> {
    return makeBindingTarget { imageView, url in
      imageView.kf.setImage(
        with: url,
        placeholder: #imageLiteral(resourceName: "default_background")
      )
    }
  }
}
