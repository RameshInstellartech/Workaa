//
//  SignInViewController.swift
//  Workaa
//
//  Created by IN1947 on 07/11/16.
//  Copyright © 2016 IN1947. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController, UITextFieldDelegate, ConnectionProtocol
{
    @IBOutlet weak var emailtxtField : TextFieldClass!
    @IBOutlet weak var pwdtxtField : TextFieldClass!
    @IBOutlet weak var logoheight = NSLayoutConstraint()
    @IBOutlet weak var logoviewheight = NSLayoutConstraint()
    @IBOutlet weak var forgotlbl = UILabel()

    var validationClass = ValidationClass()
    var alertClass = AlertClass()
    var connectionClass = ConnectionClass()
    var commonmethodClass = CommonMethodClass()

    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        connectionClass.delegate = self
        
        emailtxtField.text = "ramesh@instellartech.com";
        pwdtxtField.text = "password";
        
        if(IS_IPHONE_6)
        {
            logoheight?.constant = 54.0
        }
        if(IS_IPHONE_6P)
        {
            logoheight?.constant = 64.0
        }
        if(IS_IPHONE_6 || IS_IPHONE_6P)
        {
            var logvheight = CGFloat()
            logvheight = (logoviewheight?.constant)!
            logvheight = (screenWidth/320.0)*logvheight;
            logvheight = ceil(logvheight)
            
            logoviewheight?.constant = logvheight
        }
        
        let string = String(format: "%@", (forgotlbl?.text)!)
        let range = (string as NSString).range(of: "Click Here")
        let attributedString = NSMutableAttributedString(string:string)
        attributedString.addAttribute(NSForegroundColorAttributeName, value: blueColor , range: range)
        forgotlbl?.attributedText = attributedString
        
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SignInViewController.SignUpMethod))
        tapGesture.numberOfTapsRequired = 1
        forgotlbl?.addGestureRecognizer(tapGesture)
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func SignUpMethod()
    {
//        let signUpObj = self.storyboard?.instantiateViewController(withIdentifier: "SignUpID") as? SignUpViewController
//        self.present(signUpObj!, animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        
        return true
    }
    
    @IBAction func signin(sender : AnyObject)
    {
        if emailtxtField.count == 0 || pwdtxtField.count == 0
        {
            alertClass.showAlert(alerttitle: "Info", alertmsg: signInReponse.value(forKey: "allFieldRequired") as! String)
        }
        else if pwdtxtField.count < 6 || pwdtxtField.count > 15
        {
            alertClass.showAlert(alerttitle: "Info", alertmsg: signInReponse.value(forKey: "passwordLength") as! String)
        }
//        else if !validationClass.isValidEmail(testStr: emailtxtField.text!)
//        {
//            alertClass.showAlert(alerttitle: "Info", alertmsg: signInReponse.value(forKey: "invalidEmail") as! String)
//        }
        else
        {
            connectionClass.SignIn(email: emailtxtField.text!, password: pwdtxtField.text!)
        }
    }
    
    func GetFailureReponseMethod(errorreponse: String)
    {
        print("GetFailureReponseMethod")
    }
    
    func GetReponseMethod(reponse : NSDictionary)
    {
        print("reponse => \(reponse)")
        
        if let datareponse = reponse.value(forKey: "data") as? NSDictionary
        {
            commonmethodClass.saveuserdetails(reponse: datareponse)

            if let userdatareponse = datareponse.value(forKey: "userData") as? NSDictionary
            {
                commonmethodClass.saveprofileimg(profileImg: userdatareponse.value(forKey: "profilePic") as! NSString)
            }
            if let teamInfo = datareponse.value(forKey: "teamInfo") as? NSDictionary
            {
                commonmethodClass.saveteamdetails(reponse: teamInfo)
            }
            
            appDelegate.getAppLabel()
            
            SocketIOManager.sharedInstance.VerifySocket() { (messageInfo) -> Void in
                print("Send messageInfo =>\(messageInfo)")
            }
                        
            let homedetailObj = self.storyboard?.instantiateViewController(withIdentifier: "HomeDetailViewID") as? HomeDetailViewController
            self.navigationController?.pushViewController(homedetailObj!, animated: true)
        }
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
