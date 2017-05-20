//
//  MessageViewController.swift
//  Workaa
//
//  Created by IN1947 on 27/03/17.
//  Copyright © 2017 IN1947. All rights reserved.
//

import UIKit

class MessageViewController: UIViewController, ConnectionProtocol, UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet weak var tblUserList: UITableView!

    var userArray = NSArray()
    var connectionClass = ConnectionClass()
    var commonmethodClass = CommonMethodClass()
    var bottomView : BottomView!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        connectionClass.delegate = self
        
        tblUserList.register(UINib(nibName: "UserTableViewCell", bundle: nil), forCellReuseIdentifier: "userCell")
        
        let revealViewController: SWRevealViewController? = self.revealViewController()
        if revealViewController != nil
        {
            let containView = UIView()
            containView.frame = CGRect(x: 0.0, y: 0.0, width: 44.0, height: 44.0)
            let menuiconbtn = UIButton()
            menuiconbtn.frame = CGRect(x: CGFloat(0.0), y: CGFloat(0.0), width: CGFloat(44.0), height: CGFloat(44.0))
            menuiconbtn.titleLabel?.font = UIFont(name: Workaa_Font, size: CGFloat(25.0))
            menuiconbtn.backgroundColor = UIColor.clear
            menuiconbtn.setTitleColor(UIColor.white, for: .normal)
            menuiconbtn.setTitle(menuIcon, for: .normal)
            menuiconbtn.contentHorizontalAlignment = .left
            menuiconbtn.addTarget(revealViewController, action: #selector(revealViewController?.revealToggle(_:)), for: .touchUpInside)
            containView.addSubview(menuiconbtn)
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: containView)
            
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        commonmethodClass.delayWithSeconds(0.1, completion: {
            self.getUserList()
        })
        
        self.loadbottomView()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = false
        
        navigationController?.navigationBar.barTintColor = greenColor
        
        self.title = "Messenger"
        
        navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: LatoRegular, size: CGFloat(18.0))!, NSForegroundColorAttributeName : UIColor.white];
    }
    
    func loadbottomView()
    {
        bottomView = Bundle.main.loadNibNamed("BottomView", owner: nil, options: nil)?[0] as! BottomView
        bottomView.frame = CGRect(x: 0.0, y: screenHeight-124.0, width: screenWidth, height: 60.0)
        bottomView.loadbottomView(tag: 4)
        self.view.addSubview(bottomView)
    }

    func getUserList()
    {
        self.connectionClass.getUserList()
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
    
    // MARK: UITableView Delegate and Datasource methods
    
    private func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return userArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as! UserTableViewCell
        
        let userdictionary = userArray[indexPath.row] as! NSDictionary
        cell.lblusername.text = String(format: "%@ %@", userdictionary.value(forKey: "firstName") as! CVarArg, userdictionary.value(forKey: "lastName") as! CVarArg)
        
        let filestring = String(format: "%@%@", kfilePath,(userdictionary["pic"] as? String)!)
        let fileUrl = NSURL(string: filestring)
        cell.profileimage.imageURL = fileUrl as URL?
        
        let countstring = String(format: "%@", userdictionary.value(forKey: "unread") as! CVarArg)
        if countstring == "0"
        {
            cell.countlbl.isHidden = true
        }
        else
        {
            cell.countlbl.isHidden = false
        }
        cell.countlbl.text = countstring
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 80.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        
        self.title = ""
        
        appDelegate.userdictionary = userArray[indexPath.row] as! NSDictionary
        
        let onetooneObj = self.storyboard?.instantiateViewController(withIdentifier: "OneToOneChatViewID") as? OneToOneChatViewController
        onetooneObj?.userdictionary = appDelegate.userdictionary
        self.navigationController?.pushViewController(onetooneObj!, animated: true)
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
