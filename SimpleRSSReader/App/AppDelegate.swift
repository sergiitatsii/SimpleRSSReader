import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    guard let vc = FeedListViewController.instantiate() else { return false }
    let navVC = UINavigationController(rootViewController: vc)
    window?.backgroundColor = UIColor.white
    window?.rootViewController = navVC
    
    return true
  }

}
