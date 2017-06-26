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
    var groupArray = NSArray()
    var nongroupuserArray = NSArray()
    var alertClass = AlertClass()
    var validationClass = ValidationClass()
    var connectionClass = ConnectionClass()
    var commonmethodClass = CommonMethodClass()
    var bottomView : BottomView!
    var refreshControl = UIRefreshControl()
    var segmentedControl = HMSegmentedControl()
    var myActivityIndicator = UIActivityIndicatorView()

    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        connectionClass.delegate = self
        
        tblUserList.register(UINib(nibName: "UserTableViewCell", bundle: nil), forCellReuseIdentifier: "userCell")
        tblUserList.register(UINib(nibName: "GroupTableViewCell", bundle: nil), forCellReuseIdentifier: "GroupCell")

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
        
        self.loadbottomView()
        
        self.setRefreshControl()
        
        self.loadSegment()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = false
        
        navigationController?.navigationBar.barTintColor = greenColor
        
        self.title = "Messenger"
        
        navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: LatoRegular, size: CGFloat(18.0))!, NSForegroundColorAttributeName : UIColor.white];
        
        if(self.segmentedControl.selectedSegmentIndex==0)
        {
            self.getUserList()
        }
        else
        {
            self.getGroupList()
        }
    }
    
    func startanimating()
    {
        self.stopanimating()
        
        myActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        myActivityIndicator.center = CGPoint(x:view.center.x, y:view.center.y-64.0)
        myActivityIndicator.hidesWhenStopped = true
        self.view.addSubview(myActivityIndicator)
        myActivityIndicator.startAnimating()
    }
    
    func stopanimating()
    {
        myActivityIndicator.stopAnimating()
    }
    
    func loadSegment()
    {
        segmentedControl = HMSegmentedControl(sectionTitles: ["Members", "Groups"])
        segmentedControl.autoresizingMask = [.flexibleRightMargin, .flexibleWidth]
        segmentedControl.backgroundColor = UIColor.white
        segmentedControl.frame = CGRect(x: CGFloat(0.0), y: CGFloat(0.0), width: CGFloat(screenWidth), height: CGFloat(45.0))
        segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe
        segmentedControl.borderWidth = 3.0
        segmentedControl.borderType = HMSegmentedControlBorderType.bottom
        segmentedControl.borderColor = UIColor(red: CGFloat(233.0 / 255.0), green: CGFloat(233.0 / 255.0), blue: CGFloat(233.0 / 255.0), alpha: CGFloat(1.0))
        segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown
        segmentedControl.isVerticalDividerEnabled = false
        segmentedControl.titleTextAttributes = [NSFontAttributeName: UIFont(name: LatoRegular, size: CGFloat(15.0))!, NSForegroundColorAttributeName: UIColor.lightGray]
        segmentedControl.selectedTitleTextAttributes = [NSFontAttributeName: UIFont(name: LatoRegular, size: CGFloat(15.0))!, NSForegroundColorAttributeName: UIColor.darkGray]
        segmentedControl.selectionIndicatorColor = greenColor
        segmentedControl.addTarget(self, action: #selector(self.segmentedControlChangedValue), for: .valueChanged)
        self.view.addSubview(segmentedControl)
    }
    
    func segmentedControlChangedValue(_ segmentedControl: HMSegmentedControl)
    {
        if(segmentedControl.selectedSegmentIndex==0)
        {
            self.getUserList()
        }
        else
        {
            self.getGroupList()
        }
    }
    
    func setRefreshControl()
    {
        let attributes = [ NSForegroundColorAttributeName : UIColor.darkGray ] as [String: Any]
        
        refreshControl.tintColor = UIColor.darkGray
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to Refresh...", attributes: attributes)
        refreshControl.addTarget(self, action: #selector(MessageViewController.refreshData(sender:)), for: .valueChanged)
        
        // Add to Table View
        if #available(iOS 10.0, *) {
            self.tblUserList.refreshControl = refreshControl
        } else {
            self.tblUserList.addSubview(refreshControl)
        }
    }
    
    func refreshData(sender: UIRefreshControl)
    {
        commonmethodClass.delayWithSeconds(1.0, completion: {
            if(self.segmentedControl.selectedSegmentIndex==0)
            {
                self.getUserList()
            }
            else
            {
                self.getGroupList()
            }
            self.refreshControl.endRefreshing()
        })
    }
    
    func loadbottomView()
    {
        bottomView = Bundle.main.loadNibNamed("BottomView", owner: nil, options: nil)?[0] as! BottomView
        bottomView.frame = CGRect(x: 0.0, y: screenHeight-124.0, width: screenWidth, height: 60.0)
        bottomView.loadbottomView(tag: 4)
        self.view.addSubview(bottomView)
    }
    
    func getGroupList()
    {
        self.startanimating()
        commonmethodClass.delayWithSeconds(0.0, completion: {
            self.connectionClass.getGroupList()
        })
    }

    func getUserList()
    {
        self.startanimating()
        commonmethodClass.delayWithSeconds(0.0, completion: {
            self.connectionClass.getUserList()
        })
    }
    
    func GetFailureReponseMethod(errorreponse: String)
    {
        print("GetFailureReponseMethod")
        self.stopanimating()
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
            if let getgrouplist = getreponse.value(forKey: "groupList") as? NSArray
            {
                groupArray = getgrouplist
                tblUserList.reloadData()
            }
            if let getnongroupuserlist = getreponse.value(forKey: "usersList") as? NSArray
            {
                nongroupuserArray = getnongroupuserlist
            }
        }
        self.stopanimating()
    }
    
    // MARK: UITableView Delegate and Datasource methods
    
    private func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if(self.segmentedControl.selectedSegmentIndex==0)
        {
            return userArray.count
        }
        else
        {
            return groupArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if(self.segmentedControl.selectedSegmentIndex==0)
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
        else
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
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if(self.segmentedControl.selectedSegmentIndex==0)
        {
            return 80.0
        }
        else
        {
            return 65.0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        
        self.title = ""
        
        if(self.segmentedControl.selectedSegmentIndex==0)
        {
            appDelegate.userdictionary = userArray[indexPath.row] as! NSDictionary
            
            let onetooneObj = self.storyboard?.instantiateViewController(withIdentifier: "OneToOneChatViewID") as? OneToOneChatViewController
            onetooneObj?.userdictionary = appDelegate.userdictionary
            self.navigationController?.pushViewController(onetooneObj!, animated: true)
        }
        else
        {
            let groupdictionary = groupArray[indexPath.row] as! NSDictionary
            let groupname = String(format: "%@", groupdictionary.value(forKey: "name") as! CVarArg)
            
            let groupdetailObj = self.storyboard?.instantiateViewController(withIdentifier: "GroupDetailViewID") as? GroupDetailViewController
            groupdetailObj?.groupName = groupname
            groupdetailObj?.groupdictionary = groupdictionary
            self.navigationController?.pushViewController(groupdetailObj!, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        if(self.segmentedControl.selectedSegmentIndex==0)
        {
            return false
        }
        else
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
