//
//  NonGroupUserListViewController.swift
//  Workaa
//
//  Created by IN1947 on 13/03/17.
//  Copyright © 2017 IN1947. All rights reserved.
//

import UIKit

class NonGroupUserListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ConnectionProtocol
{
    @IBOutlet weak var tblUserList: UITableView!
    
    var validationClass = ValidationClass()
    var alertClass = AlertClass()
    var connectionClass = ConnectionClass()
    var commonmethodClass = CommonMethodClass()
    var emailArray = NSMutableArray()
    var nongroupuserArray = NSArray()
    var groupId : String!

    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        connectionClass.delegate = self
        
        print("nongroupuserArray =>\(nongroupuserArray)")
        
        tblUserList.register(UITableViewCell.classForKeyedArchiver(), forCellReuseIdentifier: "idCellEmail")
    }
    
    // MARK: - Connection Delegate
    
    func GetFailureReponseMethod(errorreponse: String)
    {
        print("GetFailureReponseMethod")
    }
    
    func GetReponseMethod(reponse : NSDictionary)
    {
        print("reponse => \(reponse)")
        self.dismissPopUpWithcompletion(nil)
    }
    
    // MARK: Actions

    @IBAction func Back(sender : AnyObject)
    {
        self.dismissPopUpWithcompletion(nil)
    }
    
    @IBAction func Send(sender : AnyObject)
    {
        if(emailArray.count==0)
        {
            alertClass.showAlert(alerttitle: "Info", alertmsg: groupInviteReponse.value(forKey: "emailRequired") as! String)
        }
        else
        {
            print("emailArray =>\(emailArray)")
            print("emailArray =>\(emailArray.componentsJoined(by: ","))")
            
            connectionClass.GroupInvitePeople(email: emailArray.componentsJoined(by: ","), groupid: groupId)
        }
    }
    
    // MARK: UITableView Delegate and Datasource methods
    
    private func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return nongroupuserArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "idCellEmail", for: indexPath)
        
        let groupdictionary = nongroupuserArray[indexPath.row] as! NSDictionary
        cell.textLabel?.text = String(format: "%@ %@", groupdictionary.value(forKey: "firstName") as! CVarArg, groupdictionary.value(forKey: "lastName") as! CVarArg)
        cell.textLabel?.font = UIFont(name: LatoRegular, size: CGFloat(17.0))!
        
        let lineView = UIView()
        lineView.frame = CGRect(x: CGFloat(0.0), y: cell.frame.size.height-0.5, width: cell.frame.size.width, height: CGFloat(0.5))
        lineView.backgroundColor = lightgrayColor
        cell.contentView.addSubview(lineView)
        
        let emailstring = String(format: "%@", groupdictionary.value(forKey: "email") as! CVarArg)
        if emailArray.contains(emailstring)
        {
            cell.accessoryType = .checkmark
        }
        else
        {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let groupdictionary = nongroupuserArray[indexPath.row] as! NSDictionary
        let emailstring = String(format: "%@", groupdictionary.value(forKey: "email") as! CVarArg)
        if emailArray.contains(emailstring)
        {
            emailArray.remove(emailstring)
        }
        else
        {
            emailArray.add(emailstring)
        }
        print("emailArray =>\(emailArray)");
        tableView.reloadData()
    }
    
    // MARK: - didReceiveMemoryWarning

    override func didReceiveMemoryWarning() {
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
