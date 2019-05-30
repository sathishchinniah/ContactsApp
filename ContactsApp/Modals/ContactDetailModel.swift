
import UIKit

class ContactDetailModel: NSObject {

    static let shared = ContactDetailModel()
    var currentUser = ContactObject()
    
    func initialize(profile_url : String, completion: @escaping (_ userInfo : ContactObject) -> () ) {
        
        Services().getUrl(method: profile_url) { (result) in
            
            print(result)
            if let userData = result as? NSDictionary {
                self.currentUser = ContactObject().initialize(data: userData)
                completion(self.currentUser)
            }else{
                completion(self.currentUser)
            }
        }
    }
}
