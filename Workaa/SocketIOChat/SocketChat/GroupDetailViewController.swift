//
//  GroupDetailViewController.swift
//  Workaa
//
//  Created by IN1947 on 14/03/17.
//  Copyright © 2017 IN1947. All rights reserved.
//

import UIKit

class GroupDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ConnectionProtocol
{
    @IBOutlet weak var tbltasklist: UITableView!

    var currentTaskArray = NSArray()
    var pastTaskArray = NSArray()
    var groupName : String!
    var groupdictionary = NSDictionary()
    var segmentedControl = HMSegmentedControl()
    var connectionClass = ConnectionClass()
    var commonmethodClass = CommonMethodClass()
    var bottomView : BottomView!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        connectionClass.delegate = self
        
        let containView = UIView()
        containView.frame = CGRect(x: 0.0, y: 0.0, width: 35.0, height: 35.0)
        let groupimagestring = String(format: "%@%@",kfilePath, (groupdictionary["logo"] as? String)!)
        let groupImage = AsyncImageView()
        groupImage.frame = CGRect(x: CGFloat(0.0), y: CGFloat(0.0), width: CGFloat(containView.frame.size.width), height: CGFloat(containView.frame.size.height))
        groupImage.layer.cornerRadius = groupImage.frame.size.height / 2.0
        groupImage.layer.masksToBounds = true
        groupImage.backgroundColor = UIColor.clear
        groupImage.imageURL = URL(string: groupimagestring)
        groupImage.contentMode = .scaleAspectFill
        groupImage.clipsToBounds = true
        containView.addSubview(groupImage)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: containView)
        
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(GroupDetailViewController.loadGroupDetails))
        tapGesture.numberOfTapsRequired = 1
        containView.addGestureRecognizer(tapGesture)
        
        tbltasklist.register(UINib(nibName: "CurrentTaskTableViewCell", bundle: nil), forCellReuseIdentifier: "CurrentTaskCell")
        
        self.loadSegment()
        
        self.getCurrentTask()
        
        self.loadbottomView()
        
        print("groupdictionary =>\(groupdictionary)")
    }

    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = false
        
        navigationController?.navigationBar.barTintColor = blueColor
        
        let memberstring = String(format: "%@ members", groupdictionary.value(forKey: "members") as! CVarArg)
        self.navigationItem.titleView = setTitle(title: groupName, subtitle: memberstring)
        
        if(segmentedControl.selectedSegmentIndex==2)
        {
            segmentedControl.setSelectedSegmentIndex(1, animated: true)
            tbltasklist.reloadData()
        }
    }
    
    func setTitle(title:String, subtitle:String) -> UIView
    {
        let titleLabel = UILabel()
        titleLabel.frame = CGRect(x: 0.0, y: 0.0, width: 200.0, height: 22.0)
        titleLabel.backgroundColor = UIColor.clear
        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont(name: LatoRegular, size: 18.0)
        titleLabel.textAlignment = .center
        titleLabel.text = title
        
        let subtitleLabel = UILabel()
        subtitleLabel.frame = CGRect(x: 0.0, y: 22.0, width: 200.0, height: 22.0)
        subtitleLabel.backgroundColor = UIColor.clear
        subtitleLabel.textColor = UIColor.white
        subtitleLabel.font = UIFont(name: LatoRegular, size: 13.0)
        subtitleLabel.textAlignment = .center
        subtitleLabel.text = subtitle
        
        let titleView = UIView()
        titleView.frame = CGRect(x: 0.0, y: 0.0, width: 200.0, height: 44.0)
        titleView.addSubview(titleLabel)
        titleView.addSubview(subtitleLabel)
        titleView.backgroundColor = UIColor.clear
        
        return titleView
    }
    
    func loadGroupDetails()
    {
        self.title = ""
        
        let groupdetailsViewObj = self.storyboard?.instantiateViewController(withIdentifier: "GroupDetailsInfoViewID") as? GroupDetailsInfoViewController
        groupdetailsViewObj?.groupdictionary = groupdictionary
        self.navigationController?.pushViewController(groupdetailsViewObj!, animated: true)
    }
    
    func loadbottomView()
    {
        bottomView = Bundle.main.loadNibNamed("BottomView", owner: nil, options: nil)?[0] as! BottomView
        bottomView.frame = CGRect(x: 0.0, y: screenHeight-124.0, width: screenWidth, height: 60.0)
        bottomView.loadbottomView(tag: 0)
        self.view.addSubview(bottomView)
    }
    
    func getCurrentTask()
    {
        self.connectionClass.getCurrentTask(groupid: groupdictionary.value(forKey: "id") as! String)
    }
    
    func getPastTask()
    {
        self.connectionClass.getPastTask(groupid: groupdictionary.value(forKey: "id") as! String)
    }

    func loadSegment()
    {
        segmentedControl = HMSegmentedControl(sectionTitles: ["Past ", "Current", "Messages"])
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
        segmentedControl.setSelectedSegmentIndex(1, animated: true)
        self.view.addSubview(segmentedControl)
    }
    
    func segmentedControlChangedValue(_ segmentedControl: HMSegmentedControl)
    {
        if(segmentedControl.selectedSegmentIndex==0)
        {
            self.getPastTask()
        }
        else if(segmentedControl.selectedSegmentIndex==1)
        {
            self.getCurrentTask()
        }
        else if(segmentedControl.selectedSegmentIndex==2)
        {
            self.title = ""
            
            let groupViewObj = self.storyboard?.instantiateViewController(withIdentifier: "GroupViewID") as? GroupViewController
            groupViewObj?.groupdictionary = groupdictionary
            self.navigationController?.pushViewController(groupViewObj!, animated: true)
        }
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
            if let tasklist = getreponse.value(forKey: "taskList") as? NSArray
            {
                if(segmentedControl.selectedSegmentIndex==0)
                {
                    pastTaskArray = tasklist
                }
                else if(segmentedControl.selectedSegmentIndex==1)
                {
                    currentTaskArray = tasklist
                }
                tbltasklist.reloadData()
            }
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
            return pastTaskArray.count
        }
        else
        {
            return currentTaskArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CurrentTaskCell", for: indexPath) as! CurrentTaskTableViewCell
        
        var taskdictionary = NSDictionary()
        
        if(segmentedControl.selectedSegmentIndex==0)
        {
            taskdictionary = pastTaskArray[indexPath.row] as! NSDictionary
        }
        else
        {
            taskdictionary = currentTaskArray[indexPath.row] as! NSDictionary
        }
        
        cell.lbltasktitle.text = taskdictionary["task"] as? String
        
        cell.lbltaskdesc.text = taskdictionary["info"] as? String
        
//        cell.lblusername.text = String(format: "Assigned by %@ %@", taskdictionary.value(forKey: "assignFirstName") as! CVarArg, taskdictionary.value(forKey: "assignLastName") as! CVarArg)
        cell.lblusername.text = String(format: "Assigned by %@", taskdictionary.value(forKey: "assignFirstName") as! CVarArg)
        
        let priority = String(format: "%@", taskdictionary.value(forKey: "priority") as! CVarArg)
        if priority == "1"
        {
            cell.statusView.isHidden = false
        }
        else
        {
            cell.statusView.isHidden = true
        }
        
        let time = String(format: "%@", taskdictionary.value(forKey: "time") as! CVarArg)
        cell.lbldate.text = String(format: "%@", commonmethodClass.convertDateInCell(date: time))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 150.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        
        self.title = ""
        
        var taskdictionary = NSDictionary()
        
        if(segmentedControl.selectedSegmentIndex==0)
        {
            taskdictionary = pastTaskArray[indexPath.row] as! NSDictionary
        }
        else
        {
            taskdictionary = currentTaskArray[indexPath.row] as! NSDictionary
        }
        
        let grouptaskdetailObj = self.storyboard?.instantiateViewController(withIdentifier: "GroupTaskDetailViewID") as? GroupTaskDetailViewController
        grouptaskdetailObj?.taskDictionary = taskdictionary
        grouptaskdetailObj?.groupdictionary = groupdictionary
        self.navigationController?.pushViewController(grouptaskdetailObj!, animated: true)
    }
    
    // MARK: didReceiveMemoryWarning
    
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
