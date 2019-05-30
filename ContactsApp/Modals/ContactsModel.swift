import UIKit

struct indexedObject {
    var initial = ""
    var array = NSMutableArray()
}

class ContactsModel: NSObject {
    static let shared = ContactsModel()
    var list = [indexedObject]()
    
    func initialize(completion: @escaping (_ model : ContactsModel) -> () ) {
        
        Services().get(method: "contacts.json") { (result) in
            
            if let result = result as? NSArray {
                if result.count != 0 {
                    
                    //Create 26 Character Alphabetic-Notebook
                    var AllData = [indexedObject]()
                    //Crate coppy of notebook to edit
                    var AllData_copy = [indexedObject]()
                    
                    for bet in AllAlphabets() {
                        AllData.append( indexedObject(initial: (bet as! String), array: []) )
                        AllData_copy.append( indexedObject(initial: (bet as! String), array: []) )
                    }
                    
                    //go through each element to add it to Alphabetic-Notebook
                    for singleDetail in result {
                        if let dict = singleDetail as? NSDictionary {
                            let currentObjct = ContactObject().initialize(data: dict)
                            let current_initial = currentObjct.first_name.first?.description.lowercased()
                        
                            var i = 0
                            while (i < AllData.count) {
                                if AllData[i].initial.lowercased() == current_initial {
                                    AllData_copy[i].array.add(currentObjct)
                                }
                                i += 1
                            }
                        }
                    }
                    
                    //Finally set it up
                    self.list = AllData_copy
                }
            }
            completion(self)
        }
    }
    
}

class ContactObject: NSObject {
    var id = ""
    var first_name = ""
    var last_name = ""
    var profile_pic = "" //Add base url
    var favorite = ""
    var email = ""
    var phone_number = ""
    var url = "" //Single detail of user
    
    func initialize(data : NSDictionary) -> ContactObject {
        self.id = onlyString(data.value(forKey: "id"))
        self.first_name = onlyString(data.value(forKey: "first_name"))
        self.last_name = onlyString(data.value(forKey: "last_name"))
        self.profile_pic = onlyString( data.value(forKey: "profile_pic") )
        self.favorite = onlyString(data.value(forKey: "favorite"))
        self.url = onlyString(data.value(forKey: "url"))
        
        if data.value(forKey: "phone_number") != nil {
            self.phone_number = onlyString(data.value(forKey: "phone_number"))
        }

        if data.value(forKey: "email") != nil {
            self.email = onlyString(data.value(forKey: "email"))
        }

        
        return self
    }
}
