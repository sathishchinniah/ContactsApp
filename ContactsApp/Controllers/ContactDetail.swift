

import UIKit
import SDWebImage
import Foundation
import MessageUI

class ContactDetail: UIViewController {

    //MARK:- IBOutlets -
    @IBOutlet weak var user_image: UIImageView!
    @IBOutlet weak var user_name: UILabel!
    @IBOutlet weak var mobileTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var loader_view: UIView!
    @IBOutlet weak var image_star: UIImageView!
    @IBOutlet weak var gradient_view: UIView!

    //MARK:- Variables -
    var profile_url = ""
    var userInfo = ContactObject()
    var isFavourite : Bool = false
    
    //MARK:- View Life Cycle -
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        if profile_url != "" {
            self.loader_view.isHidden = false
            
            ContactDetailModel().initialize(profile_url: profile_url) { (info) in
                
                self.userInfo = info
                self.user_name.text = "\(info.first_name) \(info.last_name)"
                self.mobileTF.text = info.phone_number
                self.emailTF.text = info.email
                self.user_image.sd_setImage(with: URL(string: info.profile_pic), placeholderImage: UIImage(named: "userpik"))
                
                if info.favorite == "1"{
                    self.isFavourite = true
                    self.image_star.image = UIImage(named: "star")
                    
                }else{
                    self.isFavourite = false
                    self.image_star.image = UIImage(named: "starEmpty")
                    
                }
                
                self.loader_view.isHidden = true
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Imageview circular shape
        user_image.layer.borderWidth = 4
        user_image.layer.masksToBounds = false
        user_image.layer.borderColor = UIColor.white.cgColor
        user_image.layer.cornerRadius = user_image.frame.height/2
        
        let gradient = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.colors = [UIColor.init(red: 80/255, green: 227/255, blue: 194/255, alpha: 0.4).cgColor, UIColor.init(red: 255/255, green: 255/255, blue: 255/255, alpha: 1).cgColor]
        gradient_view.layer.insertSublayer(gradient, at: 0)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(EditAction))
    }
    
    //MARK:- Functions -
    
    func configureSMSComposer() -> MFMessageComposeViewController{
        let smsComposeVC = MFMessageComposeViewController()
        smsComposeVC.delegate = self
        smsComposeVC.messageComposeDelegate = self
        smsComposeVC.recipients = ["\(self.userInfo.phone_number)"]
        return smsComposeVC
    }
    
    func configureMailComposer() -> MFMailComposeViewController{
        let mailComposeVC = MFMailComposeViewController()
        mailComposeVC.mailComposeDelegate = self
        mailComposeVC.setToRecipients([self.userInfo.email])
        mailComposeVC.setSubject("")
        mailComposeVC.setMessageBody("", isHTML: false)
        return mailComposeVC
    }
    
    //MARK:- All Actions -
    @objc func EditAction() {
        print("Editing...")
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ContactUpdates") as! ContactUpdates
        vc.userInfo = self.userInfo
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func MessageAction(_ sender: Any) {
        print("Messaging...")
        if self.userInfo.phone_number != "" {
            let smsComposeVC = configureSMSComposer()
            if MFMessageComposeViewController.canSendText(){
                self.present(smsComposeVC, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func CallAction(_ sender: Any) {
        print("Calling...")
        if self.userInfo.phone_number != "" {
            if let url = URL(string: "tel://\(self.userInfo.phone_number)") {
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
        }
    }
    
    @IBAction func MailAction(_ sender: Any) {
        print("Mailing...")
        if self.userInfo.email != "" {
            let mailComposeViewController = configureMailComposer()
            if MFMailComposeViewController.canSendMail(){
                self.present(mailComposeViewController, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func FavouriteAction(_ sender: Any) {
        print("Addig to Favourite...")
        if self.isFavourite {
            self.isFavourite = false
            self.image_star.image = UIImage(named: "starEmpty")
            
        }else{
            self.isFavourite = true
            self.image_star.image = UIImage(named: "star")
            
        }
    }
    
}


extension ContactDetail : MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}

extension ContactDetail : UINavigationControllerDelegate, MFMessageComposeViewControllerDelegate {
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
    }
}
