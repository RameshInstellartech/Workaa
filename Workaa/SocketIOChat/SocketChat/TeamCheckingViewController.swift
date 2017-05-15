//
//  TeamCheckingViewController.swift
//  Workaa
//
//  Created by IN1947 on 03/04/17.
//  Copyright © 2017 IN1947. All rights reserved.
//

import UIKit

class TeamCheckingViewController: UIViewController, UITextFieldDelegate, ConnectionProtocol
{
    @IBOutlet weak var teamtxtField : UITextField!
    
    var alertClass = AlertClass()
    var connectionClass = ConnectionClass()
    var commonmethodClass = CommonMethodClass()

    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        connectionClass.delegate = self
        
        teamtxtField.text = "in1947"
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = false
        
        navigationController?.navigationBar.barTintColor = blueColor
    }
    
    @IBAction func nextAction(sender : AnyObject)
    {
        if teamtxtField.text?.characters.count == 0
        {
            alertClass.showAlert(alerttitle: "Info", alertmsg: "Team Required")
        }
        else
        {
            connectionClass.teamVerify(domain: teamtxtField.text!)
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
            if let baseURL = datareponse.value(forKey: "url") as? String
            {
                kBaseURL = baseURL
                
                let signinObj = self.storyboard?.instantiateViewController(withIdentifier: "SignInID") as? SignInViewController
                self.navigationController?.pushViewController(signinObj!, animated: true)
            }
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
