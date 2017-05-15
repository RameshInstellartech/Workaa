//
//  CreateTeamPasswordViewController.swift
//  Workaa
//
//  Created by IN1947 on 04/04/17.
//  Copyright © 2017 IN1947. All rights reserved.
//

import UIKit

class CreateTeamPasswordViewController: UIViewController, UITextFieldDelegate, ConnectionProtocol
{
    @IBOutlet weak var passwordtxtField : TextFieldClass!
    @IBOutlet weak var confirmpasswordtxtField : TextFieldClass!
    
    var alertClass = AlertClass()
    var connectionClass = ConnectionClass()
    var commonmethodClass = CommonMethodClass()
    var validationClass = ValidationClass()
    var emailString : String!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
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
        if passwordtxtField.text?.characters.count == 0
        {
            alertClass.showAlert(alerttitle: "Info", alertmsg: "Password Required")
        }
        else if confirmpasswordtxtField.text?.characters.count == 0
        {
            alertClass.showAlert(alerttitle: "Info", alertmsg: "Confirm Password Required")
        }
        else if passwordtxtField.text != confirmpasswordtxtField.text
        {
            alertClass.showAlert(alerttitle: "Info", alertmsg: "Password and Confirm Password does not match")
        }
        else
        {
            connectionClass.register(email: emailString, password: passwordtxtField.text!)
        }
    }
    
    func GetFailureReponseMethod(errorreponse: String)
    {
        print("GetFailureReponseMethod")
    }
    
    func GetReponseMethod(reponse : NSDictionary)
    {
        print("reponse => \(reponse)")
        
        let createteamObj = self.storyboard?.instantiateViewController(withIdentifier: "CreateTeamID") as? CreateTeamViewController
        createteamObj?.emailString = String(format: "%@", emailString)
        self.navigationController?.pushViewController(createteamObj!, animated: true)
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
