import Foundation

extension String {
  
  //    "Hi" = "Привет";
  var localized: String {
    return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
  }
  
  //    /* with !!! */
  //    "Hi" = "Привет!!!";
  func localizedWithComment(_ comment: String) -> String {
    return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: comment)
  }
  
}

extension String {
  
  var isEmail: Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,20}"
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailTest.evaluate(with: self)
  }
  
}
