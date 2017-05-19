//
//  UserListView.swift
//  Workaa
//
//  Created by IN1947 on 02/05/17.
//  Copyright © 2017 IN1947. All rights reserved.
//

import UIKit

class UserListView: UIView, ConnectionProtocol, UITableViewDelegate, UITableViewDataSource
{
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    @IBOutlet weak var tblUserList: UITableView!
    @IBOutlet weak var closebtn: UIButton!
    
    var commonmethodClass = CommonMethodClass()
    var connectionClass = ConnectionClass()
    var userArray = NSArray()
    var selecteduserArray = NSMutableArray()

    func loadUserListView(params : String, groupId : String)
    {
        connectionClass.delegate = self

        self.backgroundColor = UIColor(white: 1.0, alpha: 0.8)
        
        closebtn.setTitle(closeIcon, for: .normal)
        
        tblUserList.register(UINib(nibName: "UserCellTableViewCell", bundle: nil), forCellReuseIdentifier: "IdUserCell")

        commonmethodClass.delayWithSeconds(0.1, completion: {
            self.getUserList(params: params, groupId: groupId)
        })
        
        for view : UIView in self.subviews
        {
            view.layer.shadowOpacity = 0.5
            view.layer.shadowColor = UIColor.lightGray.cgColor
            view.layer.shadowOffset = CGSize(width: 0, height: 0)
            view.layer.shadowRadius = 5
        }
    }
    
    func getUserList(params : String, groupId : String)
    {
        if params == "Create Group"
        {
            self.connectionClass.getUserList()
        }
        if params == "Group Details"
        {
            self.connectionClass.getNonGroupUserList(groupId: groupId)
        }
    }
    
    func GetFailureReponseMethod(errorreponse: String)
    {
        print("GetFailureReponseMethod")
    }
    
    func GetReponseMethod(reponse : NSDictionary)
    {
        print("reponse => \(reponse)")
        
        if let getreponse = reponse.value(forKey: "data") as? NSDictionary
        {
            if let getuserlist = getreponse.value(forKey: "usersList") as? NSArray
            {
                userArray = getuserlist
                tblUserList.reloadData()
            }
        }
    }
    
    @IBAction func okayAction(sender: UIButton)
    {
        if(selecteduserArray.count>0)
        {
            if self.next?.next is CreateGroupViewController
            {
                (self.next?.next as? CreateGroupViewController)?.getselecteduser(array: selecteduserArray)
            }
            if self.next?.next is GroupDetailsInfoViewController
            {
                (self.next?.next as? GroupDetailsInfoViewController)?.getselecteduser(array: selecteduserArray)
            }
        }
        
        self.closeAction(sender: sender)
    }
    
    @IBAction func closeAction(sender: UIButton)
    {
        for v: UIView in self.subviews {
            v.removeFromSuperview()
        }
        self.removeFromSuperview()
    }
    
    func tickaction(sender : UIButton)
    {
        if(sender.layer.borderWidth==1.0)
        {
            sender.layer.cornerRadius = 0.0
            sender.layer.masksToBounds = false
            sender.layer.borderColor = UIColor.clear.cgColor
            sender.layer.borderWidth = 0.0
            sender.setTitle(roundtickIcon, for: .normal)
            
            selecteduserArray.add(userArray[sender.tag])
        }
        else
        {
            sender.setTitle("", for: .normal)
            sender.layer.cornerRadius = sender.frame.size.height / 2.0
            sender.layer.masksToBounds = true
            sender.layer.borderColor = UIColor.darkGray.cgColor
            sender.layer.borderWidth = 1.0
            
            selecteduserArray.remove(userArray[sender.tag])
        }
        print("selecteduserArray =>\(selecteduserArray)")
    }
    
    // MARK: UITableView Delegate and Datasource Methods
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return userArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IdUserCell", for: indexPath) as! UserCellTableViewCell
        
        let userdictionary = userArray[indexPath.row] as! NSDictionary
        
        let filestring = String(format: "%@%@", kfilePath,userdictionary.value(forKey: "pic") as! CVarArg)
        let fileUrl = NSURL(string: filestring)
        cell.profileimage.imageURL = fileUrl as URL?
                
        cell.lblusername.text = String(format: "%@ %@", userdictionary.value(forKey: "firstName") as! CVarArg, userdictionary.value(forKey: "lastName") as! CVarArg)
        
        cell.tickbtn.addTarget(self, action: #selector(self.tickaction(sender:)), for: .touchUpInside)
        cell.tickbtn.tag = indexPath.row
        
        if(selecteduserArray.count>0)
        {
            if(selecteduserArray.contains(userdictionary))
            {
                cell.tickbtn.layer.cornerRadius = 0.0
                cell.tickbtn.layer.masksToBounds = false
                cell.tickbtn.layer.borderColor = UIColor.clear.cgColor
                cell.tickbtn.layer.borderWidth = 0.0
                cell.tickbtn.setTitle(roundtickIcon, for: .normal)
            }
            else
            {
                cell.tickbtn.setTitle("", for: .normal)
                cell.tickbtn.layer.cornerRadius = cell.tickbtn.frame.size.height / 2.0
                cell.tickbtn.layer.masksToBounds = true
                cell.tickbtn.layer.borderColor = UIColor.darkGray.cgColor
                cell.tickbtn.layer.borderWidth = 1.0
            }
        }
        else
        {
            cell.tickbtn.setTitle("", for: .normal)
            cell.tickbtn.layer.cornerRadius = cell.tickbtn.frame.size.height / 2.0
            cell.tickbtn.layer.masksToBounds = true
            cell.tickbtn.layer.borderColor = UIColor.darkGray.cgColor
            cell.tickbtn.layer.borderWidth = 1.0
        }
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 50.0
    }
}
