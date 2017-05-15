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
        
        commonmethodClass.delayWithSeconds(0.1, completion: {
            self.getQueueList()
            self.getMyBucketList()
            self.getGroupList()
        })
        
        self.loadbottomView()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = false
        
        navigationController?.navigationBar.barTintColor = blueColor
        
        self.title = String(format: "Welcome, %@", commonmethodClass.retrieveusername())
        
        navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: LatoRegular, size: CGFloat(18.0))!, NSForegroundColorAttributeName : UIColor.white];
    }
    
    func loadbottomView()
    {
        bottomView = Bundle.main.loadNibNamed("BottomView", owner: nil, options: nil)?[0] as! BottomView
        bottomView.frame = CGRect(x: 0.0, y: screenHeight-124.0, width: screenWidth, height: 60.0)
        bottomView.loadbottomView(tag: 2)
        self.view.addSubview(bottomView)
    }
    
    func getMyBucketList()
    {
        self.connectionClass.getMyBucketList()
    }
    
    func getQueueList()
    {
        self.connectionClass.getQueueList()
    }
    
    func getGroupList()
    {
        self.connectionClass.getGroupList()
    }
    
    func loadSegment()
    {
        segmentedControl = HMSegmentedControl(sectionTitles: ["Queue", "Tasks", "Groups"])
        segmentedControl.autoresizingMask = [.flexibleRightMargin, .flexibleWidth]
        segmentedControl.backgroundColor = UIColor.white
        segmentedControl.frame = CGRect(x: CGFloat(0.0), y: CGFloat(0.0), width: CGFloat(screenWidth), height: CGFloat(45.0))
        segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe
        segmentedControl.borderWidth = 3.0
        segmentedControl.borderType = HMSegmentedControlBorderType.bottom
        segmentedControl.borderColor = UIColor(red: CGFloat(233.0 / 255.0), green: CGFloat(233.0 / 255.0), blue: CGFloat(233.0 / 255.0), alpha: CGFloat(1.0))
        segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown
        segmentedControl.isVerticalDividerEnabled = false
        segmentedControl.titleTextAttributes = [NSFontAttributeName: UIFont(name: LatoRegular, size: CGFloat(17.0))!, NSForegroundColorAttributeName: UIColor.lightGray]
        segmentedControl.selectedTitleTextAttributes = [NSFontAttributeName: UIFont(name: LatoRegular, size: CGFloat(17.0))!, NSForegroundColorAttributeName: UIColor.darkGray]
        segmentedControl.selectionIndicatorColor = blueColor
        segmentedControl.addTarget(self, action: #selector(self.segmentedControlChangedValue), for: .valueChanged)
        self.view.addSubview(segmentedControl)
    }
    
    func segmentedControlChangedValue(_ segmentedControl: HMSegmentedControl)
    {
        tbltasklist.reloadData()
    }
    
    // MARK: Connection Delegate

    func GetFailureReponseMethod(errorreponse: String)
    {
        print("GetFailureReponseMethod")
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
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if(segmentedControl.selectedSegmentIndex==0)
        {
            return 110.0
        }
        else
        {
            return 80.0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        
        self.title = ""

        if(segmentedControl.selectedSegmentIndex==0)
        {
            let queuedetailObj = self.storyboard?.instantiateViewController(withIdentifier: "QueueDetailViewID") as? QueueDetailViewController
            queuedetailObj?.queueDictionary = queueArray[indexPath.row] as! NSDictionary
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
