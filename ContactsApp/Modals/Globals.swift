
import Foundation
import UIKit
import Alamofire

var BASE_URL = "http://gojek-contacts-app.herokuapp.com/"

func AllAlphabets() -> NSMutableArray {
    let AllLetters = NSMutableArray()
    let aScalars = "A".unicodeScalars
    let aCode = aScalars[aScalars.startIndex].value
    
    let letters: [Character] = (0..<26).map {
        i in Character(UnicodeScalar(aCode + i)!)
    }
    
    for stringLetter in letters {
        AllLetters.add(stringLetter.description)
    }
    
    return AllLetters
}

func onlyBool( _ value: Any?) -> Bool {
    let boolString = onlyString(value)
    if boolString == "1" {
        return true
    } else {
        return false
    }
}

func onlyString( _ value: Any?) -> String {
    if let stringValue = value as? String {
        return stringValue
    } else if let numberValue = value as? NSNumber {
        return "\(numberValue)"
    }else{
        return ""
    }
}

struct Services {
    func get(method: String, completion: @escaping ( _ result : AnyObject) -> ()) {
        Alamofire.request("\(BASE_URL)\(method)", method: .get).responseJSON { response in
            completion(response.result.value as AnyObject)
        }
    }

    func getUrl(method: String, completion: @escaping ( _ result : AnyObject) -> ()) {
        Alamofire.request(method, method: .get).responseJSON { response in
            completion(response.result.value as AnyObject)
        }
    }
    
    func post(url: String, parameters : NSDictionary, completion: @escaping ( _ result : AnyObject) -> ()) {
        Alamofire.request(url, method: .post ,parameters: parameters as? Parameters).responseJSON { response in
            completion(response.result.value as AnyObject)
        }
    }
    
    func put(url: String, parameters : NSDictionary, completion: @escaping ( _ result : AnyObject) -> ()) {
        Alamofire.request(url, method: .put ,parameters: parameters as? Parameters).responseJSON { response in
            completion(response.result.value as AnyObject)
        }
    }
}
