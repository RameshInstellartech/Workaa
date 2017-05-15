//
//  TeamInviteViewController.swift
//  Workaa
//
//  Created by IN1947 on 09/03/17.
//  Copyright © 2017 IN1947. All rights reserved.
//

import UIKit

class TeamInviteViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ConnectionProtocol
{
    @IBOutlet weak var emailtxtField : TextFieldClass!
    @IBOutlet weak var tblEmailList: UITableView!

    var validationClass = ValidationClass()
    var alertClass = AlertClass()
    var connectionClass = ConnectionClass()
    var commonmethodClass = CommonMethodClass()
    var emailArray = NSMutableArray()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.title = "Team Invite"
        
        connectionClass.delegate = self
        
        let sendButton : UIBarButtonItem = UIBarButtonItem(title: "Send", style: UIBarButtonItemStyle.plain, target: self, action: #selector(TeamInviteViewController.SendAction))
        self.navigationItem.rightBarButtonItem = sendButton
        
        tblEmailList.register(UITableViewCell.classForKeyedArchiver(), forCellReuseIdentifier: "idCellEmail")
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = false
        
        navigationController?.navigationBar.barTintColor = blueColor
    }
    
    func SendAction()
    {
        emailtxtField.resignFirstResponder()
        
        if(emailArray.count==0)
        {
            alertClass.showAlert(alerttitle: "Info", alertmsg: teamInviteReponse.value(forKey: "emailRequired") as! String)
        }
        else
        {
            print("emailArray =>\(emailArray)")
            print("emailArray =>\(emailArray.componentsJoined(by: ","))")
            
            connectionClass.InvitePeople(email: emailArray.componentsJoined(by: ","))
        }
    }
    
    @IBAction func Add(sender : AnyObject)
    {
        if(emailtxtField.text?.characters.count==0)
        {
            alertClass.showAlert(alerttitle: "Info", alertmsg: teamInviteReponse.value(forKey: "emailRequired") as! String)
        }
        else if !validationClass.isValidEmail(testStr: emailtxtField.text!)
        {
            alertClass.showAlert(alerttitle: "Info", alertmsg: teamInviteReponse.value(forKey: "invalidEmail") as! String)
        }
        else
        {
            emailArray.insert(emailtxtField.text!, at: 0)
            emailtxtField.text = ""
            emailtxtField.resignFirstResponder()
            self.tablereloadanimation()
        }
    }
    
    func tablereloadanimation()
    {
        let range = NSMakeRange(0, tblEmailList.numberOfSections)
        let indexSet = NSIndexSet(indexesIn: range)
        tblEmailList.reloadSections(indexSet as IndexSet, with: UITableViewRowAnimation.automatic)
    }
    
    // MARK: - Connection Delegate

    func GetFailureReponseMethod(errorreponse: String)
    {
        print("GetFailureReponseMethod")
    }
    
    func GetReponseMethod(reponse : NSDictionary)
    {
        print("reponse => \(reponse)")
        
        for aviewcontroller : UIViewController in navigation().viewControllers
        {
            if let teamlistView = aviewcontroller as? TeamListViewController
            {
                teamlistView.getTeamList()
                break
            }
        }
        
        navigation().popViewController(animated: true)
    }
    
    // MARK: - UITextField Delegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        
        return true
    }
    
    // MARK: UITableView Delegate and Datasource methods
    
    private func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return emailArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "idCellEmail", for: indexPath)
        
        cell.textLabel?.text = emailArray[indexPath.row] as? String
        cell.textLabel?.font = UIFont(name: LatoRegular, size: CGFloat(17.0))!
        
        let lineView = UIView()
        lineView.frame = CGRect(x: CGFloat(0.0), y: cell.frame.size.height-0.5, width: cell.frame.size.width, height: CGFloat(0.5))
        lineView.backgroundColor = lightgrayColor
        cell.contentView.addSubview(lineView)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]?
    {
        let deleteRowAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "Delete", handler:{action, indexpath in
            
            self.emailArray.removeObject(at: indexpath.row)
            self.tablereloadanimation()
            
        });
        deleteRowAction.backgroundColor = UIColor.red
        
        return [deleteRowAction]
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
