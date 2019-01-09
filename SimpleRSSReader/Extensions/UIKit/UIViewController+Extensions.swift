import UIKit

public protocol BundleForClassInstantiable { }
extension UIViewController: BundleForClassInstantiable { }
extension BundleForClassInstantiable where Self: UIViewController {
  /// Instantiates controller from storyboard.
  ///
  /// - parameter storyboardName: storyboard name to be used, if nil - String(self) will be used
  /// - parameter initial: If true - instantiates initial viewController and if it's UINavigationController - tries to take it rootViewController. If no - instantiates viewController with identifier String(self)
  /// - returns: controller instance if everything is ok
  public static func instantiate(storyboardName: String? = nil, initial: Bool = false) -> Self? {
    let storyboardName = storyboardName ?? String(describing: self)
    let bundle = Bundle(for: self)
    guard bundle.path(forResource: storyboardName, ofType: "storyboardc") != nil else { return nil }
    return UIStoryboard(storyboardName, bundle: bundle).instantiateViewController(self, initial: initial)
  }
  
}

extension UIViewController {
  /// Instantiates controller from xib.
  ///
  /// - parameter xibName: xib name to be used, if nil - String(self) will be used
  /// - returns: controller instance if everything is ok
  public class func instantiateFromXib(_ xibName: String? = nil) -> Self? {
    return _instantiateFromXib(self, xibName: xibName ?? String(describing: self))
  }
  
  fileprivate class func _instantiateFromXib<T: UIViewController>(_ :T.Type, xibName: String) -> T? {
    let bundle = Bundle(for: self)
    guard bundle.path(forResource: xibName, ofType: "nib") != nil else { return nil }
    return T(nibName: xibName, bundle: bundle)
  }
  
}
