import Foundation
import UIKit

public struct Configuration {
  
  var navigationBarShadowImage: UIImage?
  var navigationBarBackgroundImage: UIImage?
  var navigationBarHidden: Bool?
  var preferredStatusBarStyle: UIStatusBarStyle = .lightContent
  var supportedInterfaceOrientations: UIInterfaceOrientationMask = {
    if UI_USER_INTERFACE_IDIOM() == .pad {
      return [.all]
    }
    return [.portrait]
  }()
  
  init(navigationBarHidden: Bool? = false, preferredStatusBarStyle: UIStatusBarStyle = .lightContent) {
    self.navigationBarHidden = navigationBarHidden
    self.preferredStatusBarStyle = preferredStatusBarStyle
  }
  
  static var navigationBarHidden: Configuration {
    return Configuration(navigationBarHidden: true, preferredStatusBarStyle: .default)
  }
  
  static var navigationBarVisible: Configuration {
    return Configuration(navigationBarHidden: false)
  }
  
  static var withHiddenShadowUnderNavigationBar: Configuration {
    var config = Configuration.navigationBarVisible
    config.navigationBarShadowImage = UIImage()
    config.navigationBarBackgroundImage = UIImage()
    return config
  }
  
}

public class ConfigurableViewController: UIViewController {
  
  var configuration: Configuration?
  
  override public func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.navigationBar.shadowImage = configuration?.navigationBarShadowImage
  navigationController?.navigationBar.setBackgroundImage(configuration?.navigationBarBackgroundImage, for: .any, barMetrics: .default)
    
    guard let navBarHidden = configuration?.navigationBarHidden else { return }
    navigationController?.setNavigationBarHidden(navBarHidden, animated: true)
  }
  
  override public var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    guard let configuration = configuration else { return super.supportedInterfaceOrientations }
    return configuration.supportedInterfaceOrientations
  }
  
  override public var preferredStatusBarStyle: UIStatusBarStyle {
    guard let configuration = configuration else { return super.preferredStatusBarStyle }
    return configuration.preferredStatusBarStyle
  }
  
}
