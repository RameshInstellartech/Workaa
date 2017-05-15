//
//  SignUpViewController.swift
//  Workaa
//
//  Created by IN1947 on 02/11/16.
//  Copyright © 2016 IN1947. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController, UITextFieldDelegate, ConnectionProtocol
{
    @IBOutlet weak var fnametxtField : TextFieldClass!
    @IBOutlet weak var lnametxtField : TextFieldClass!
    @IBOutlet weak var usernametxtField : TextFieldClass!
    @IBOutlet weak var emailtxtField : TextFieldClass!
    @IBOutlet weak var pwdtxtField : TextFieldClass!
    @IBOutlet weak var scrollView : UIScrollView!
    @IBOutlet weak var plusbtn : UIButton!
    @IBOutlet weak var signinlbl : UILabel!
    @IBOutlet weak var titlelbl : UILabel!
    @IBOutlet weak var desclbl : UILabel!

    var validationClass = ValidationClass()
    var connectionClass = ConnectionClass()
    var commonmethodClass = CommonMethodClass()

    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        print("Your device identifires =>\(uniqueId)")
        
        plusbtn.layer.borderColor = blueColor.cgColor
        plusbtn.layer.borderWidth = 1.0
        
        commonmethodClass.delayWithSeconds(0.1, completion: {
            self.scrollView.contentSize = CGSize(width: screenWidth, height: screenHeight+200.0)
        })
        
        let string = String(format: "%@", signinlbl.text!)
        let range = (string as NSString).range(of: "Sign in")
        let attributedString = NSMutableAttributedString(string:string)
        attributedString.addAttribute(NSForegroundColorAttributeName, value: blueColor , range: range)
        signinlbl.attributedText = attributedString
        
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SignUpViewController.SignInMethod))
        tapGesture.numberOfTapsRequired = 1
        signinlbl.addGestureRecognizer(tapGesture)
        
        NotificationCenter.default.addObserver(self, selector: #selector(SignUpViewController.handleKeyboardWillShowNotification(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(SignUpViewController.handleKeyboardWillHideNotification(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        titlelbl.text = signUpReponse.value(forKey: "title") as? String
        desclbl.text = signUpReponse.value(forKey: "description") as? String
    }
    
    // MARK: - KeyboardNotification Methods
    
    func handleKeyboardWillShowNotification(notification: NSNotification)
    {
        if let userInfo = notification.userInfo
        {
            if let keyboardFrame = (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue
            {
                self.scrollView.contentSize = CGSize(width: screenWidth, height: screenHeight+200.0+keyboardFrame.size.height)
            }
        }
    }
    
    func handleKeyboardWillHideNotification(notification: NSNotification)
    {
        self.scrollView.contentSize = CGSize(width: screenWidth, height: screenHeight+200.0)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
    }

    @IBAction func signup(sender : AnyObject)
    {
        if fnametxtField.count == 0 || lnametxtField.count == 0 || emailtxtField.count == 0 || pwdtxtField.count == 0 || usernametxtField.count == 0
        {
            self.showAlert(alerttitle: "Info", alertmsg: signUpReponse.value(forKey: "allFieldRequired") as! String)
        }
        else if (fnametxtField.count > 50 || lnametxtField.count > 50)
        {
            self.showAlert(alerttitle: "Info", alertmsg: signUpReponse.value(forKey: "nameLength") as! String)
        }
        else if usernametxtField.count > 25
        {
            self.showAlert(alerttitle: "Info", alertmsg: signUpReponse.value(forKey: "usernameLength") as! String)
        }
        else if (!validationClass.containsOnlyLetters(input: fnametxtField.text!) || !validationClass.containsOnlyLetters(input: lnametxtField.text!))
        {
            self.showAlert(alerttitle: "Info", alertmsg: signUpReponse.value(forKey: "nameAlphabet") as! String)
        }
        else if !validationClass.containsAlphaNumeric(input: usernametxtField.text!)
        {
            self.showAlert(alerttitle: "Info", alertmsg: signUpReponse.value(forKey: "invalidUsername") as! String)
        }
        else if pwdtxtField.count < 6 || pwdtxtField.count > 15
        {
            self.showAlert(alerttitle: "Info", alertmsg: signUpReponse.value(forKey: "passwordLength") as! String)
        }
        else if !validationClass.isValidEmail(testStr: emailtxtField.text!)
        {
            self.showAlert(alerttitle: "Info", alertmsg: signUpReponse.value(forKey: "invalidEmail") as! String)
        }
        else
        {
            connectionClass.delegate = self
            connectionClass.SignUp(fname: fnametxtField.text!, lname: lnametxtField.text!, email: emailtxtField.text!, password: pwdtxtField.text!,username: usernametxtField.text!)
        }
    }
    
    func showAlert(alerttitle : String, alertmsg : String)
    {
        let alertController = UIAlertController(title: alerttitle, message: alertmsg, preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func GetFailureReponseMethod(errorreponse: String)
    {
        self.showAlert(alerttitle: "Info", alertmsg: errorreponse)
        print("GetFailureReponseMethod")
    }
    
    func GetReponseMethod(reponse : NSDictionary)
    {
        print("reponse => \(reponse)")
        self.dismiss(animated: true, completion: nil)
    }
    
    func SignInMethod()
    {
        self.dismiss(animated: true, completion: nil)
    }
    
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
