
import UIKit

class CreateContactModel: NSObject {
    
    static let shared = CreateContactModel()
    
    func initialize(parmaters : NSDictionary, completion: @escaping (_ userInfo : CreateContactModel) -> () ) {
        
        Services().post(url: "\(BASE_URL)contacts.json", parameters: parmaters) { (result) in
            print(result)
            completion(self)
        }
    }
}
