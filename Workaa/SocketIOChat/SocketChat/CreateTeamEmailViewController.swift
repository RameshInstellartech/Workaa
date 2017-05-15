//
//  CreateTeamEmailViewController.swift
//  Workaa
//
//  Created by IN1947 on 04/04/17.
//  Copyright © 2017 IN1947. All rights reserved.
//

import UIKit

class CreateTeamEmailViewController: UIViewController, UITextFieldDelegate, ConnectionProtocol
{
    @IBOutlet weak var emailtxtField : UITextField!
    
    var alertClass = AlertClass()
    var connectionClass = ConnectionClass()
    var commonmethodClass = CommonMethodClass()
    var validationClass = ValidationClass()

    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        connectionClass.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        self.title = ""
        
        self.navigationController?.navigationBar.isHidden = false
        
        navigationController?.navigationBar.barTintColor = blueColor
    }
    
    @IBAction func nextAction(sender : AnyObject)
    {
        if emailtxtField.text?.characters.count == 0
        {
            alertClass.showAlert(alerttitle: "Info", alertmsg: "Email Required")
        }
        else if !validationClass.isValidEmail(testStr: emailtxtField.text!)
        {
            alertClass.showAlert(alerttitle: "Info", alertmsg: "invalidEmail")
        }
        else
        {
            connectionClass.emailIdVerify(email: emailtxtField.text!)
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
            let createteamcodeObj = self.storyboard?.instantiateViewController(withIdentifier: "CreateTeamCodeViewID") as? CreateTeamCodeViewController
            createteamcodeObj?.emailString = String(format: "%@", emailtxtField.text!)
            createteamcodeObj?.newuserdetectString = String(format: "%@", datareponse.value(forKey: "new_email") as! CVarArg)
            self.navigationController?.pushViewController(createteamcodeObj!, animated: true)
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        
        return true
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
