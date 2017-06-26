//
//  TaskListViewController.swift
//  Workaa
//
//  Created by IN1947 on 27/02/17.
//  Copyright © 2017 IN1947. All rights reserved.
//

import UIKit

class TaskListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ConnectionProtocol
{
    @IBOutlet weak var tbltasklist: UITableView!

    var myBucketArray = NSArray()
    var queueArray = NSArray()
    var groupArray = NSArray()
    var commonmethodClass = CommonMethodClass()
    var segmentedControl = HMSegmentedControl()
    var connectionClass = ConnectionClass()
    var alertClass = AlertClass()
    var bottomView : BottomView!
    var refreshControl = UIRefreshControl()
    var myActivityIndicator = UIActivityIndicatorView()

    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        connectionClass.delegate = self
        
        tbltasklist.register(UINib(nibName: "QueueTableViewCell", bundle: nil), forCellReuseIdentifier: "QueueCell")
        tbltasklist.register(UINib(nibName: "BucketTableViewCell", bundle: nil), forCellReuseIdentifier: "BucketCell")
        tbltasklist.register(UINib(nibName: "GroupTableViewCell", bundle: nil), forCellReuseIdentifier: "GroupCell")
        
        self.loadSegment()
        
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
        
        self.getQueueList()
        
        self.loadbottomView()
        
        self.setRefreshControl()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = false
        
        navigationController?.navigationBar.barTintColor = blueColor
        
        self.title = String(format: "Welcome, %@", commonmethodClass.retrieveusername())
        
        navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: LatoRegular, size: CGFloat(18.0))!, NSForegroundColorAttributeName : UIColor.white];
    }
    
    func setRefreshControl()
    {
        let attributes = [ NSForegroundColorAttributeName : UIColor.darkGray ] as [String: Any]
        
        refreshControl.tintColor = UIColor.darkGray
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to Refresh...", attributes: attributes)
        refreshControl.addTarget(self, action: #selector(TaskListViewController.refreshData(sender:)), for: .valueChanged)
        
        // Add to Table View
        if #available(iOS 10.0, *) {
            self.tbltasklist.refreshControl = refreshControl
        } else {
            self.tbltasklist.addSubview(refreshControl)
        }
    }
    
    func refreshData(sender: UIRefreshControl)
    {
        commonmethodClass.delayWithSeconds(1.0, completion: {
            if(self.segmentedControl.selectedSegmentIndex==0)
            {
                self.getQueueList()
            }
            else if(self.segmentedControl.selectedSegmentIndex==1)
            {
                self.getMyBucketList()
            }
            else if(self.segmentedControl.selectedSegmentIndex==2)
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
        bottomView.loadbottomView(tag: 2)
        self.view.addSubview(bottomView)
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
    
    func getMyBucketList()
    {
        self.startanimating()
        commonmethodClass.delayWithSeconds(0.0, completion: {
            self.connectionClass.getMyBucketList()
        })
    }
    
    func getQueueList()
    {
        self.startanimating()
        commonmethodClass.delayWithSeconds(0.0, completion: {
            self.connectionClass.getQueueList()
        })
    }
    
    func getGroupList()
    {
        self.startanimating()
        commonmethodClass.delayWithSeconds(0.0, completion: {
            self.connectionClass.getGroupList()
        })
    }
    
    func loadSegment()
    {
        segmentedControl = HMSegmentedControl(sectionTitles: ["Queue", "My Tasks", "Groups"])
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
        segmentedControl.selectionIndicatorColor = blueColor
        segmentedControl.addTarget(self, action: #selector(self.segmentedControlChangedValue), for: .valueChanged)
        self.view.addSubview(segmentedControl)
    }
    
    func segmentedControlChangedValue(_ segmentedControl: HMSegmentedControl)
    {
        if(self.segmentedControl.selectedSegmentIndex==0)
        {
            self.getQueueList()
        }
        else if(self.segmentedControl.selectedSegmentIndex==1)
        {
            self.getMyBucketList()
        }
        else if(self.segmentedControl.selectedSegmentIndex==2)
        {
            self.getGroupList()
        }
    }
    
    // MARK: Connection Delegate

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
            if let getmybucketlist = getreponse.value(forKey: "taskList") as? NSArray
            {
                myBucketArray = getmybucketlist
            }
            if let getqueuelist = getreponse.value(forKey: "queueList") as? NSArray
            {
                queueArray = getqueuelist
            }
            if let getgrouplist = getreponse.value(forKey: "groupList") as? NSArray
            {
                groupArray = getgrouplist
            }
            tbltasklist.reloadData()
        }
        self.stopanimating()
    }
    
    // MARK: UITableView Delegate and Datasource Methods
    
    private func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if(segmentedControl.selectedSegmentIndex==0)
        {
            return queueArray.count
        }
        else if(segmentedControl.selectedSegmentIndex==1)
        {
            return myBucketArray.count
        }
        else
        {
            return groupArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if(segmentedControl.selectedSegmentIndex==0)
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "QueueCell", for: indexPath) as! QueueTableViewCell
            
            let queuedictionary = queueArray[indexPath.row] as! NSDictionary
            
            let taskname = String(format: "%@", queuedictionary.value(forKey: "task") as! CVarArg)
            cell.lbltaskdesc.text = taskname
            
//            cell.lblusername.text = String(format: "by %@ %@", queuedictionary.value(forKey: "firstName") as! CVarArg, queuedictionary.value(forKey: "lastName") as! CVarArg)
            cell.lblusername.text = String(format: "by %@", queuedictionary.value(forKey: "firstName") as! CVarArg)
            
            let priority = String(format: "%@", queuedictionary.value(forKey: "priority") as! CVarArg)
            if priority == "1"
            {
                cell.statusView.isHidden = false
            }
            else
            {
                cell.statusView.isHidden = true
            }
            
            let time = String(format: "%@", queuedictionary.value(forKey: "time") as! CVarArg)
            cell.lbldate.text = String(format: "%@", commonmethodClass.convertDateInCell(date: time))
            
            cell.lblarrow.text = rightarrowIcon
            
            var height = commonmethodClass.dynamicHeight(width: screenWidth-50, font: UIFont (name: LatoRegular, size: 14)!, string: taskname as String)
            height = ceil(height)
            if height > 35.0
            {
                height = 35.0
            }
            
            cell.arrowheight?.constant = height
            cell.textheight?.constant = height
            
            return cell
        }
        else if(segmentedControl.selectedSegmentIndex==1)
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "BucketCell", for: indexPath) as! BucketTableViewCell
            
            let bucketdictionary = myBucketArray[indexPath.row] as! NSDictionary
            let taskname = String(format: "%@", bucketdictionary.value(forKey: "task") as! CVarArg)
            cell.lbltaskdesc.text = taskname
            
            let filestring = String(format: "%@%@", kfilePath,(bucketdictionary["groupLogo"] as? String)!)
            let fileUrl = NSURL(string: filestring)
            cell.profileimage.imageURL = fileUrl as URL?
            
            cell.lblarrow.text = rightarrowIcon
            
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
        if(segmentedControl.selectedSegmentIndex==0)
        {
            let queuedictionary = queueArray[indexPath.row] as! NSDictionary
            let taskname = String(format: "%@", queuedictionary.value(forKey: "task") as! CVarArg)
            
            var height = commonmethodClass.dynamicHeight(width: screenWidth-50, font: UIFont (name: LatoRegular, size: 14)!, string: taskname as String)
            height = ceil(height)
            if height > 35.0
            {
                height = 35.0
            }
            
            return height+50.0
        }
        else if(segmentedControl.selectedSegmentIndex==1)
        {
            return 55.0
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

        if(segmentedControl.selectedSegmentIndex==0)
        {
            let queuedetailObj = self.storyboard?.instantiateViewController(withIdentifier: "QueueDetailViewID") as? QueueDetailViewController
            queuedetailObj?.queueDictionary = NSMutableDictionary(dictionary: queueArray[indexPath.row] as! NSDictionary)
            self.navigationController?.pushViewController(queuedetailObj!, animated: true)
        }
        else if(segmentedControl.selectedSegmentIndex==1)
        {
            let bucketdetailObj = self.storyboard?.instantiateViewController(withIdentifier: "BucketDetailViewID") as? BucketDetailViewController
            bucketdetailObj?.myBucketDictionary = myBucketArray[indexPath.row] as! NSDictionary
            self.navigationController?.pushViewController(bucketdetailObj!, animated: true)
        }
        else if(segmentedControl.selectedSegmentIndex==2)
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
        if(segmentedControl.selectedSegmentIndex==0 || segmentedControl.selectedSegmentIndex==2)
        {
            return false
        }
        else
        {
            return true
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]?
    {
        if(segmentedControl.selectedSegmentIndex==0 || segmentedControl.selectedSegmentIndex==2)
        {
            return nil
        }
        else
        {
            let notDoneRowAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "Not Done", handler:{action, indexpath in
                
                let bucketdictionary = self.myBucketArray[indexPath.row] as! NSDictionary
                let taskid = String(format: "%@", bucketdictionary.value(forKey: "id") as! CVarArg)
                self.alertClass.notdonetaskAlert(taskid: taskid)
                
            });
            notDoneRowAction.backgroundColor = redColor
            
            let doneRowAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "Done", handler:{action, indexpath in
                
                let bucketdictionary = self.myBucketArray[indexPath.row] as! NSDictionary
                let hour = String(format: "%@", bucketdictionary.value(forKey: "hours") as! CVarArg)
                let taskid = String(format: "%@", bucketdictionary.value(forKey: "id") as! CVarArg)
                if hour == "1"
                {
                    self.alertClass.donetaskAlert(taskid: taskid)
                }
                else
                {
                    self.alertClass.doneSaveAction(taskid: taskid, hours: "")
                }
                
            });
            doneRowAction.backgroundColor = greenColor
            
            return [doneRowAction, notDoneRowAction]
        }
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
