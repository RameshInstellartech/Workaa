//
//  CreateTeamViewController.swift
//  Workaa
//
//  Created by IN1947 on 02/11/16.
//  Copyright © 2016 IN1947. All rights reserved.
//

import UIKit
import Photos

class CreateTeamViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, ConnectionProtocol, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    @IBOutlet weak var scrollView : UIScrollView!
    @IBOutlet weak var firstnametxtField : TextFieldClass!
    @IBOutlet weak var lastnametxtField : TextFieldClass!
    @IBOutlet weak var usernametxtField : TextFieldClass!
    @IBOutlet weak var teamnametxtField : TextFieldClass!
    @IBOutlet weak var domainnametxtField : TextFieldClass!
    @IBOutlet weak var industrytxtField : TextFieldClass!
    @IBOutlet weak var noofemptxtField : TextFieldClass!

    
    @IBOutlet weak var addresstxtField : TextFieldClass!
    @IBOutlet weak var desctxtField : TextFieldClass!
    @IBOutlet weak var emailidtxtField : TextFieldClass!
    @IBOutlet weak var mobiletxtField : TextFieldClass!
    @IBOutlet weak var countrytxtField : TextFieldClass!
    @IBOutlet weak var statetxtField : TextFieldClass!
    @IBOutlet weak var citytxtField : TextFieldClass!
    @IBOutlet weak var pincodetxtField : TextFieldClass!
    @IBOutlet weak var contactpersontxtField : TextFieldClass!
    @IBOutlet weak var profileimage: UIImageView!

    var alertClass = AlertClass()
    var connectionClass = ConnectionClass()
    var commonmethodClass = CommonMethodClass()
    var imgData : NSData!
    var emailString : String!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        NotificationCenter.default.addObserver(self, selector: #selector(SignUpViewController.handleKeyboardWillShowNotification(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(SignUpViewController.handleKeyboardWillHideNotification(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
//        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CreateTeamViewController.profileaction))
//        tapGesture.numberOfTapsRequired = 1
//        profileimage.addGestureRecognizer(tapGesture)
//        
//        profileimage.layer.borderWidth = 0.5
//        profileimage.layer.borderColor = UIColor.lightGray.cgColor
        
        connectionClass.delegate = self
        
        commonmethodClass.delayWithSeconds(0.1, completion: {
            self.scrollView.contentSize = CGSize(width: screenWidth, height: 600.0)
        })
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = false
        
        navigationController?.navigationBar.barTintColor = blueColor
        
        self.title = "Create Team"
    }
    
    func camera()
    {
        if UIImagePickerController.isSourceTypeAvailable(
            UIImagePickerControllerSourceType.camera)
        {
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .camera
            imagePicker.delegate = self
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func library()
    {
        if UIImagePickerController.isSourceTypeAvailable(
            UIImagePickerControllerSourceType.savedPhotosAlbum)
        {
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .photoLibrary
            imagePicker.delegate = self
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    // MARK: - UIImagePickerControllerDelegate Methods
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        dismiss(animated: true, completion: nil)
        
        if let pickImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
            print("pickImage => \(pickImage)")
            
            profileimage.image = pickImage
            
            let assetUrl = info[UIImagePickerControllerReferenceURL] as? NSURL
            print("assetUrl => \(String(describing: assetUrl))")
            if (assetUrl != nil)
            {
                let fetchResult = PHAsset.fetchAssets(withALAssetURLs: [assetUrl! as URL], options: nil)
                if let phAsset = fetchResult.firstObject! as? PHAsset
                {
                    PHImageManager.default().requestImageData(for: phAsset, options: nil) {
                        (imageData, dataURI, orientation, info) -> Void in
                        
                        print("imageData => \(String(describing: imageData?.count))")
                        
                        self.imgData = imageData as NSData!
                    }
                }
            }
            else
            {
                let imageData = UIImageJPEGRepresentation(pickImage, 1.0)
                print("imageData => \(String(describing: imageData?.count))")
                
                self.imgData = imageData as NSData!
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - KeyboardNotification Methods
    
    func handleKeyboardWillShowNotification(notification: NSNotification)
    {
        if let userInfo = notification.userInfo
        {
            if let keyboardFrame = (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue
            {
                self.scrollView.contentSize = CGSize(width: screenWidth, height: 600.0+keyboardFrame.size.height)
            }
        }
    }
    
    func handleKeyboardWillHideNotification(notification: NSNotification)
    {
        self.scrollView.contentSize = CGSize(width: screenWidth, height: 600.0)
    }

    // MARK: - UITextField Delegate

    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: - Actions Methods
    
    @IBAction func createteam(sender : AnyObject)
    {
        if firstnametxtField.count == 0 || lastnametxtField.count == 0 || usernametxtField.count == 0 || teamnametxtField.count == 0 || domainnametxtField.count == 0 || industrytxtField.count == 0 || noofemptxtField.count == 0
        {
            alertClass.showAlert(alerttitle: "Info", alertmsg: "All fields are required")
        }
        else
        {
            connectionClass.CreateTeam(fname: firstnametxtField.text!, lname: lastnametxtField.text!, username: usernametxtField.text!, name: teamnametxtField.text!, domain: domainnametxtField.text!, industry: industrytxtField.text!, employees: noofemptxtField.text!, email: emailString)
        }
    }
    
    func profileaction()
    {
        alertClass.createTeamAttachment()
    }
    
    // MARK: - Connection Delegate
    
    func GetFailureReponseMethod(errorreponse: String)
    {
        print("GetFailureReponseMethod")
    }
    
    func GetReponseMethod(reponse : NSDictionary)
    {
        print("reponse => \(reponse)")
        
        if let datareponse = reponse.value(forKey: "data") as? NSDictionary
        {
            if let baseURL = datareponse.value(forKey: "url") as? String
            {
                kBaseURL = baseURL
                
                let signinObj = self.storyboard?.instantiateViewController(withIdentifier: "SignInID") as? SignInViewController
                self.navigationController?.pushViewController(signinObj!, animated: true)
            }
        }
    }
    
    // MARK: - didReceiveMemoryWarning

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}
