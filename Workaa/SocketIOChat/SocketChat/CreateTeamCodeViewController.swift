//
//  CreateTeamCodeViewController.swift
//  Workaa
//
//  Created by IN1947 on 04/04/17.
//  Copyright © 2017 IN1947. All rights reserved.
//

import UIKit

class CreateTeamCodeViewController: UIViewController, UITextFieldDelegate, ConnectionProtocol
{
    @IBOutlet weak var codetxtField : TextFieldClass!

    var alertClass = AlertClass()
    var connectionClass = ConnectionClass()
    var commonmethodClass = CommonMethodClass()
    var validationClass = ValidationClass()
    var emailString : String!
    var newuserdetectString : String!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        print("emailString =>\(emailString)")
        print("newuserdetectString =>\(newuserdetectString)")

        connectionClass.delegate = self
        
        let nextButton : UIBarButtonItem = UIBarButtonItem(title: "Next", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.NextAction))
        self.navigationItem.rightBarButtonItem = nextButton
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        self.title = ""
        
        self.navigationController?.navigationBar.isHidden = false
        
        navigationController?.navigationBar.barTintColor = blueColor
    }
    
    func NextAction()
    {
        if codetxtField.text?.characters.count == 0
        {
            alertClass.showAlert(alerttitle: "Info", alertmsg: "Code Required")
        }
        else
        {
            connectionClass.verifyEmail(email: emailString, code: codetxtField.text!)
        }
    }
    
    func GetFailureReponseMethod(errorreponse: String)
    {
        print("GetFailureReponseMethod")
    }
    
    func GetReponseMethod(reponse : NSDictionary)
    {
        print("reponse => \(reponse)")
        
        if newuserdetectString == "0"
        {
            let createteamObj = self.storyboard?.instantiateViewController(withIdentifier: "CreateTeamID") as? CreateTeamViewController
            createteamObj?.emailString = String(format: "%@", emailString)
            self.navigationController?.pushViewController(createteamObj!, animated: true)
        }
        else
        {
            let createteampassObj = self.storyboard?.instantiateViewController(withIdentifier: "CreateTeamPasswordViewID") as? CreateTeamPasswordViewController
            createteampassObj?.emailString = String(format: "%@", emailString)
            self.navigationController?.pushViewController(createteampassObj!, animated: true)
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
