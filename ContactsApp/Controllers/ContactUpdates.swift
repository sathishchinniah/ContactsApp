
import UIKit

class ContactUpdates: UIViewController {

    //MARK:- IBOutlets -
    @IBOutlet weak var user_image: UIImageView!
    @IBOutlet weak var first_nameTF: UITextField!
    @IBOutlet weak var last_nameTF: UITextField!
    @IBOutlet weak var mobileTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var loader_view: UIView!

    //MARK:- Variables -
    var isCreating = false
    var imagePicker = UIImagePickerController()
    var userInfo = ContactObject()
    
    //MARK:- View Life Cycle -
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(DoneAction))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(CancelAction))
        
        user_image.layer.borderWidth = 4
        user_image.layer.masksToBounds = false
        user_image.layer.borderColor = UIColor.white.cgColor
        user_image.layer.cornerRadius = user_image.frame.height/2
        user_image.clipsToBounds = true

        let gradient = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.colors = [UIColor.init(red: 80/255, green: 227/255, blue: 194/255, alpha: 0.4).cgColor, UIColor.init(red: 255/255, green: 255/255, blue: 255/255, alpha: 1).cgColor]
        self.view.layer.insertSublayer(gradient, at: 0)
        
        if !isCreating {
            self.first_nameTF.text = self.userInfo.first_name
            self.last_nameTF.text = self.userInfo.last_name
            self.mobileTF.text = self.userInfo.phone_number
            self.emailTF.text = self.userInfo.email
            self.user_image.sd_setImage(with: URL(string: self.userInfo.profile_pic), placeholderImage: UIImage(named: "userpik"))
        }
    }
    
    @objc func DoneAction() {
        print("Updating...")
        self.loader_view.isHidden = false

        
        if isCreating {
            let params : NSDictionary = ["first_name":self.first_nameTF.text!, "last_name":self.last_nameTF.text!, "email":self.emailTF.text!, "phone_number":self.mobileTF.text!, "favorite":"false", "profile_pic":""]
            CreateContactModel().initialize(parmaters: params) { (cmodel) in
                self.loader_view.isHidden = true
                self.navigationController?.popViewController(animated: true)
            }
        }else{
            let params : NSDictionary = ["first_name":self.first_nameTF.text!, "last_name":self.last_nameTF.text!]
            UpdateContactModel().initialize(id: self.userInfo.id, parmaters: params) { (umodel) in
                self.loader_view.isHidden = true
                self.navigationController?.popViewController(animated: true)
            }
        }
        
    }
    
    @objc func CancelAction() {
        print("Cancelling...")
        self.navigationController?.popViewController(animated: true)
    }

    
    //MARK:- IBACtions -
    @IBAction func SelectImageAction(_ sender: Any) {
        OpenPicker()
    }
    
    //MARK:- Image Picker -
    func OpenPicker() {
        let sheet = UIAlertController(title: "Add Image", message: nil, preferredStyle: .actionSheet)
        sheet.addAction(UIAlertAction(title: "Camera", style: .destructive, handler: { (camera) in
            self.imagePicker.delegate = self
            self.imagePicker.sourceType = .camera
            self.imagePicker.allowsEditing = false
            self.imagePicker.cameraDevice = .rear
            sheet.dismiss(animated: true, completion: nil)
            self.present(self.imagePicker, animated: true, completion: nil)
        }))
        sheet.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { (gallery) in
            self.imagePicker.delegate = self
            self.imagePicker.sourceType = .photoLibrary
            self.imagePicker.allowsEditing = false
            sheet.dismiss(animated: true, completion: nil)
            self.present(self.imagePicker, animated: true, completion: nil)
        }))
        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (cancel) in
            sheet.dismiss(animated: true, completion: nil)
        }))
        
        sheet.popoverPresentationController?.sourceView = self.view
        sheet.popoverPresentationController?.sourceRect = CGRect(x: self.view.frame.width/2, y: self.view.frame.height/2, width: 2, height: 2)
        sheet.popoverPresentationController?.permittedArrowDirections = .up
        
        self.present(sheet, animated: true, completion: nil)
        
    }
    
}


extension ContactUpdates : UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.user_image.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
      
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
