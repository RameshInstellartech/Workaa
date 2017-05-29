//
//  GroupListController.swift
//  Workaa
//
//  Created by IN1947 on 09/11/16.
//  Copyright © 2016 IN1947. All rights reserved.
//

import UIKit

class GroupListController: UIViewController, ConnectionProtocol, UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet weak var tblGroupUserList: UITableView!

    var teamdictionary = NSDictionary()
    var groupArray = NSArray()
    var nongroupuserArray = NSArray()
    var alertClass = AlertClass()
    var validationClass = ValidationClass()
    var connectionClass = ConnectionClass()
    var commonmethodClass = CommonMethodClass()
    var bottomView : BottomView!
    var refreshControl = UIRefreshControl()

    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        connectionClass.delegate = self
        
        if(commonmethodClass.retrieveteamadmin()=="1")
        {
            let groupButton : UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(GroupListController.CreateGroupAction))
            self.navigationItem.rightBarButtonItems = [groupButton]
        }
        
        print("teamdictionary =>\(teamdictionary)")
        print("groupArray =>\(groupArray)")
        
        tblGroupUserList.register(UINib(nibName: "GroupTableViewCell", bundle: nil), forCellReuseIdentifier: "GroupCell")
        
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
            self.getGroupList()
        })
        
        self.loadbottomView()
        
        self.setRefreshControl()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = false
        
        navigationController?.navigationBar.barTintColor = blueColor
        
        self.title = "Groups"
        
        navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: LatoRegular, size: CGFloat(18.0))!, NSForegroundColorAttributeName : UIColor.white];
    }
    
    func setRefreshControl()
    {
        let attributes = [ NSForegroundColorAttributeName : UIColor.darkGray ] as [String: Any]
        
        refreshControl.tintColor = UIColor.darkGray
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to Refresh...", attributes: attributes)
        refreshControl.addTarget(self, action: #selector(GroupListController.refreshData(sender:)), for: .valueChanged)
        
        // Add to Table View
        if #available(iOS 10.0, *) {
            self.tblGroupUserList.refreshControl = refreshControl
        } else {
            self.tblGroupUserList.addSubview(refreshControl)
        }
    }
    
    func refreshData(sender: UIRefreshControl)
    {
        commonmethodClass.delayWithSeconds(1.0, completion: {
            self.getGroupList()
            self.refreshControl.endRefreshing()
        })
    }
    
    func loadbottomView()
    {
        bottomView = Bundle.main.loadNibNamed("BottomView", owner: nil, options: nil)?[0] as! BottomView
        bottomView.frame = CGRect(x: 0.0, y: screenHeight-124.0, width: screenWidth, height: 60.0)
        bottomView.loadbottomView(tag: 0)
        self.view.addSubview(bottomView)
    }
    
    func getGroupList()
    {
        self.connectionClass.getGroupList()
    }
    
    func CreateGroupAction()
    {
        self.title = "Back"
        
        let creategroupObj = self.storyboard?.instantiateViewController(withIdentifier: "CreateGroupViewID") as? CreateGroupViewController
        self.navigationController?.pushViewController(creategroupObj!, animated: true)
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
            if let getgrouplist = getreponse.value(forKey: "groupList") as? NSArray
            {
                groupArray = getgrouplist
                tblGroupUserList.reloadData()
            }
            if let getnongroupuserlist = getreponse.value(forKey: "usersList") as? NSArray
            {
                nongroupuserArray = getnongroupuserlist
            }
        }
    }
    
    @IBAction func addTask(sender: AnyObject)
    {
        let createtask = self.storyboard?.instantiateViewController(withIdentifier: "CreateTaskID") as? CreateTaskViewController
        createtask?.groupArray = groupArray
        self.navigationController?.pushViewController(createtask!, animated: true)
    }
    
    @IBAction func checkIn(sender: AnyObject)
    {
        print("checkIn")
    }
    
    @IBAction func taskList(sender: AnyObject)
    {
        print("taskList")
    }
    
    @IBAction func checkInStatus(sender: AnyObject)
    {
        print("checkInStatus")
    }
    
    // MARK: UITableView Delegate and Datasource methods
    
    private func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return groupArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupCell", for: indexPath) as! GroupTableViewCell
        
        let groupdictionary = groupArray[indexPath.row] as! NSDictionary
        cell.lblgroupname.text = groupdictionary["name"] as? String
        
        let filestring = String(format: "%@%@", kfilePath,(groupdictionary["logo"] as? String)!)
        let fileUrl = NSURL(string: filestring)
        cell.profileimage.imageURL = fileUrl as URL?
        
        cell.lbltask.text = String(format: "%@ Ongoing tasks", groupdictionary.value(forKey: "ongoingTask") as! CVarArg)
        
        let status = String(format: "%@", groupdictionary.value(forKey: "criticalTask") as! CVarArg)
        cell.lblstatus.text = String(format: "%@ Priority", status)
        if status == "0"
        {
            cell.lblstatus.isHidden = true
            cell.circleView.isHidden = true
        }
        else
        {
            cell.lblstatus.isHidden = false
            cell.circleView.isHidden = false
        }
        
        let countstring = String(format: "%@", groupdictionary.value(forKey: "unread") as! CVarArg)
        if countstring == "0"
        {
            cell.countlbl.isHidden = true
        }
        else
        {
            cell.countlbl.isHidden = false
        }
        cell.countlbl.text = countstring
        
        cell.lblarrow.text = rightarrowIcon

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 65.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        
        self.title = ""
        
        let groupdictionary = groupArray[indexPath.row] as! NSDictionary
        let groupname = String(format: "%@", groupdictionary.value(forKey: "name") as! CVarArg)

        let groupdetailObj = self.storyboard?.instantiateViewController(withIdentifier: "GroupDetailViewID") as? GroupDetailViewController
        groupdetailObj?.groupName = groupname
        groupdetailObj?.groupdictionary = groupdictionary
        self.navigationController?.pushViewController(groupdetailObj!, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        let groupdictionary = self.groupArray[indexPath.row] as! NSDictionary
        let adminstring = String(format: "%@", groupdictionary.value(forKey: "admin") as! CVarArg)
        if(commonmethodClass.retrieveteamadmin()=="1" || adminstring=="1")
        {
            return true
        }
        else
        {
            return false
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]?
    {
        let inviteRowAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "Invite", handler:{action, indexpath in
            
            let groupdictionary = self.groupArray[indexPath.row] as! NSDictionary
            let groupId = String(format: "%@", groupdictionary.value(forKey: "id") as! CVarArg)

            self.connectionClass.getNonGroupUserList(groupId: (groupdictionary["id"] as? String)!)
            
            let nongroupObj = self.storyboard?.instantiateViewController(withIdentifier: "NonGroupUserListViewID") as? NonGroupUserListViewController
            nongroupObj?.nongroupuserArray = self.nongroupuserArray
            nongroupObj?.groupId = groupId
            nongroupObj?.view.frame = CGRect(x: 0.0, y: 0.0, width: screenWidth-20.0, height: screenHeight-100.0)
            self.presentPopUp(nongroupObj)
            
        });
        inviteRowAction.backgroundColor = UIColor.red
        
        return [inviteRowAction]
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
