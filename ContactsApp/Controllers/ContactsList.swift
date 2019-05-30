

import UIKit
import SDWebImage

class ContactsList: UIViewController {
    //MARK:- IBOutlets -
    @IBOutlet weak var table_contacts: UITableView!
    @IBOutlet weak var table_alphabets: UITableView!
    @IBOutlet weak var loader_view: UIView!
    
    //MARK:- Variables -
    
    //MARK:- View Life Cycle -
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        //Get all contacts
        self.loader_view.isHidden = false
        ContactsModel().initialize { (model) in
            
            ContactsModel.shared.list = model.list
            self.table_contacts.reloadData()
            self.loader_view.isHidden = true
        }
    }
    
    //MARK: - Functions -
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        _ = HighlightAlphabet(touches)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        //Scroll main contacts list to selected alphabet
        let index = HighlightAlphabet(touches)
        if index != -1 {
            self.table_contacts.scrollToRow(at: IndexPath(row: 0, section: index), at: .top, animated: false)
        }
    }
    
    func HighlightAlphabet(_ touches: Set<UITouch>) -> Int {
        let touch = touches.first!
        let location = touch.location(in: self.view)
        let innerLocation = table_alphabets.convert(location, from: self.view)
        if let indy = table_alphabets.indexPathForRow(at: innerLocation) {
            return indy.row
        }else{
            return -1
        }
    }
    
    //MARK:- IBActions -
    
    @IBAction func AddContactAction(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ContactUpdates") as! ContactUpdates
        vc.isCreating = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    

}


//MARK:- UITableView DataSource -
extension ContactsList : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == table_contacts {
            return AllAlphabets().count
        }else{
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == table_contacts {
            if ContactsModel.shared.list.count == 0 {
                return 0
            }else{
                return ContactsModel.shared.list[section].array.count
            }
        }else{
            return AllAlphabets().count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == table_contacts {
            return 64
        }else{
           return tableView.frame.height / 26
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == table_contacts {
            //Contacts Cell
            var cell = tableView.dequeueReusableCell(withIdentifier: "contactCell", for: indexPath) as? contactCell
            if cell == nil {
                cell = contactCell(style: .default, reuseIdentifier: "contactCell")
            }
            cell?.selectionStyle = .none
            
            if let object = ContactsModel.shared.list[indexPath.section].array.object(at: indexPath.row) as? ContactObject {
                cell?.user_name.text = "\(object.first_name) \(object.last_name)"
                cell?.user_image.sd_setImage(with: URL(string: object.profile_pic), placeholderImage: UIImage(named: "userpik"))
                
                if object.favorite == "1" {
                    cell?.favourite.isHidden = false
                }else{
                    cell?.favourite.isHidden = true
                }
            }
            
            return cell!
        }else{
            //Alphabetical indexes
            var cell = tableView.dequeueReusableCell(withIdentifier: "indexCell", for: indexPath) as? indexCell
            if cell == nil {
                cell = indexCell(style: .default, reuseIdentifier: "indexCell")
            }
            cell?.selectionStyle = .none
            cell?.labelAlphabet.text = AllAlphabets().object(at: indexPath.row) as? String ?? ""
            return cell!
        }
    }
    
    
    //MARK:- Header -
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView == table_contacts {
            return 32
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if tableView == table_contacts {
            return AllAlphabets().object(at: section) as? String
        }else{
            return ""
        }
    }
}

//MARK:- UITableView Delegate -
extension ContactsList : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == table_contacts {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ContactDetail") as! ContactDetail
            if let object = ContactsModel.shared.list[indexPath.section].array.object(at: indexPath.row) as? ContactObject {
                vc.profile_url = object.url
            }else{
                vc.profile_url = ""
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }else{}
    }
}
