//
//  ForgotViewController.swift
//  Workaa
//
//  Created by IN1947 on 14/06/17.
//  Copyright © 2017 IN1947. All rights reserved.
//

import UIKit

class ForgotViewController: UIViewController, ConnectionProtocol
{
    @IBOutlet weak var closebtn = UIButton()
    @IBOutlet weak var emailtxtField : TextFieldClass!

    var validationClass = ValidationClass()
    var alertClass = AlertClass()
    var connectionClass = ConnectionClass()
    var commonmethodClass = CommonMethodClass()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        connectionClass.delegate = self
        
        closebtn?.setTitle(closeIcon, for: .normal)
        closebtn?.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func closeaction(sender : AnyObject)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func resetpassword(sender : AnyObject)
    {
        if emailtxtField.count == 0
        {
            self.showAlert(alerttitle: "", alertmsg: "Email Required")
        }
        else
        {
            connectionClass.ForgotEmail(email: emailtxtField.text!)
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
        print("GetFailureReponseMethod")
        self.showAlert(alerttitle: "", alertmsg: errorreponse)
    }
    
    func GetReponseMethod(reponse : NSDictionary)
    {
        print("reponse => \(reponse)")
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
