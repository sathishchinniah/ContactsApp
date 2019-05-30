

import UIKit

class UpdateContactModel: NSObject {
    static let shared = UpdateContactModel()
    
    func initialize(id : String, parmaters : NSDictionary, completion: @escaping (_ userInfo : UpdateContactModel) -> () ) {
        
        Services().put(url: "\(BASE_URL)contacts/\(id).json", parameters: parmaters) { (result) in
            print(result)
            completion(self)
        }
    }
}
