//
//  GroupTaskDetailViewController.swift
//  Workaa
//
//  Created by IN1947 on 23/03/17.
//  Copyright © 2017 IN1947. All rights reserved.
//

import UIKit

class GroupTaskDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var tasktitle: UITextView!
    @IBOutlet weak var tasktitleheight: NSLayoutConstraint!
    @IBOutlet weak var assignlbl: UILabel!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var datelbl: UILabel!
    @IBOutlet weak var taskdesc: UITextView!
    @IBOutlet weak var taskdescheight: NSLayoutConstraint!
    @IBOutlet weak var profileimage: AsyncImageView!
    @IBOutlet weak var groupNamelbl: UILabel!
    @IBOutlet weak var memberscrollView: UIScrollView!
    @IBOutlet weak var viewheight : NSLayoutConstraint!
    @IBOutlet weak var tbllist: UITableView!
    @IBOutlet weak var tblheight: NSLayoutConstraint!

    var morebtn: UIButton!
    var taskDictionary = NSDictionary()
    var groupdictionary = NSDictionary()
    var commonmethodClass = CommonMethodClass()
    var alertClass = AlertClass()
    var bottomView : BottomView!
    var userArray = NSArray()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        print("taskDictionary =>\(taskDictionary)")
        print("groupdictionary =>\(groupdictionary)")
        
        let filestring = String(format: "%@%@", kfilePath,(groupdictionary["logo"] as? String)!)
        let fileUrl = NSURL(string: filestring)
        profileimage.imageURL = fileUrl as URL?
        
        groupNamelbl.text = String(format: "%@", groupdictionary.value(forKey: "name") as! CVarArg)
        
        tasktitle.text = String(format: "%@", taskDictionary.value(forKey: "task") as! CVarArg)
        tasktitleheight.constant = commonmethodClass.dynamicHeight(width: screenWidth-40, font: tasktitle.font!, string: tasktitle.text!)
        if(tasktitleheight.constant<30.0)
        {
            tasktitleheight.constant = 30.0
        }
        else
        {
            tasktitleheight.constant = tasktitleheight.constant + 20.0
        }
        
//        assignlbl.text = String(format: "by %@ %@", taskDictionary.value(forKey: "assignFirstName") as! CVarArg, taskDictionary.value(forKey: "assignLastName") as! CVarArg)
        assignlbl.text = String(format: "by %@", taskDictionary.value(forKey: "assignFirstName") as! CVarArg)
        
        let priority = String(format: "%@", taskDictionary.value(forKey: "priority") as! CVarArg)
        if priority == "1"
        {
            statusView.isHidden = false
        }
        else
        {
            statusView.isHidden = true
        }
        
        let time = String(format: "%@", taskDictionary.value(forKey: "time") as! CVarArg)
        datelbl.text = String(format: "%@", commonmethodClass.convertDateInCell(date: time))
        
        taskdesc.text = String(format: "%@", taskDictionary.value(forKey: "info") as! CVarArg)
        taskdescheight.constant = commonmethodClass.dynamicHeight(width: screenWidth-40, font: taskdesc.font!, string: taskdesc.text!)
        if(taskdescheight.constant<30.0)
        {
            taskdescheight.constant = 30.0
        }
        else
        {
            taskdescheight.constant = taskdescheight.constant + 20.0
        }
        
        if let own = taskDictionary.value(forKey: "own") as? NSInteger
        {
            let taskown = taskDictionary.value(forKey: "taskOwnDone") as! NSInteger
            if own == 1 && taskown == 0
            {
                viewheight.constant = 60.0
            }
            else
            {
                viewheight.constant = 0.0
            }
            
            memberscrollView.isHidden = false
            tbllist.isHidden = true
            
            self.loadMemberView(userArray: taskDictionary.value(forKey: "users") as! NSArray)
            
            commonmethodClass.delayWithSeconds(0.5, completion: {
                self.scrollView.contentSize = CGSize(width: screenWidth, height: self.taskdescheight.constant+self.tasktitleheight.constant+280.0)
            })
        }
        else
        {
            viewheight.constant = 0.0
            memberscrollView.isHidden = true
            tbllist.isHidden = false
            
            userArray = taskDictionary.value(forKey: "users") as! NSArray
            
            if(userArray.count>0)
            {
                tblheight.constant = CGFloat(userArray.count * 70) + 45
                tbllist.reloadData()
            }
            
            commonmethodClass.delayWithSeconds(0.5, completion: {
                self.scrollView.contentSize = CGSize(width: screenWidth, height: self.tblheight.constant+self.taskdescheight.constant+self.tasktitleheight.constant+160.0)
            })
        }
        
        tbllist.register(UITableViewCell.classForKeyedArchiver(), forCellReuseIdentifier: "idUserCell")

        self.loadbottomView()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = false
        
        navigationController?.navigationBar.barTintColor = blueColor
        
        self.title = groupdictionary.value(forKey: "name") as! String?
    }
    
    func loadbottomView()
    {
        bottomView = Bundle.main.loadNibNamed("BottomView", owner: nil, options: nil)?[0] as! BottomView
        bottomView.frame = CGRect(x: 0.0, y: screenHeight-124.0, width: screenWidth, height: 60.0)
        bottomView.loadbottomView(tag: 0)
        self.view.addSubview(bottomView)
    }
    
    func loadMemberView(userArray : NSArray)
    {
        var Xpos : CGFloat!
        Xpos = 0.0
        for i in 0 ..< userArray.count
        {
            let userdictionary = userArray[i] as! NSDictionary
            
            let processString = String(format: "%@", userdictionary.value(forKey: "process") as! CVarArg)
            
            let filestring = String(format: "%@%@", kfilePath,userdictionary.value(forKey: "profilePic") as! CVarArg)
            let fileUrl = NSURL(string: filestring)
            
            let firstnamestring = String(format: "%@",userdictionary.value(forKey: "firstName") as! CVarArg)
            
            let userImage = AsyncImageView()
            userImage.frame = CGRect(x: CGFloat(Xpos), y: CGFloat(0.0), width: CGFloat(40.0), height: CGFloat(40.0))
            userImage.layer.cornerRadius = userImage.frame.size.height / 2.0
            userImage.layer.masksToBounds = true
            userImage.backgroundColor = UIColor.clear
            userImage.imageURL = fileUrl as URL?
            userImage.tag = i
            userImage.contentMode = .scaleAspectFill
            userImage.clipsToBounds = true
            userImage.isUserInteractionEnabled = true
            memberscrollView.addSubview(userImage)
            
            let titlelbl = UILabel()
            titlelbl.frame = CGRect(x: CGFloat(Xpos-2.5), y: CGFloat(userImage.frame.maxY + 5.0), width: CGFloat(45.0), height: CGFloat(20.0))
            titlelbl.font = UIFont(name: LatoRegular, size: CGFloat(12.0))
            titlelbl.backgroundColor = UIColor.clear
            titlelbl.textColor = UIColor.black
            titlelbl.text = firstnamestring
            titlelbl.textAlignment = .center
//            titlelbl.adjustsFontSizeToFitWidth = true
            memberscrollView.addSubview(titlelbl)

            let button = UIButton()
            button.frame = CGRect(x: CGFloat(0.0), y: CGFloat(0.0), width: CGFloat(40.0), height: CGFloat(40.0))
            button.tag = i
            button.layer.cornerRadius = button.frame.size.height/2.0
            button.layer.masksToBounds = true
            button.titleLabel?.font = UIFont(name: LatoBold, size: 20.0)
            userImage.addSubview(button)
            
            if processString == "2"
            {
                button.setTitle("!", for: .normal)
                button.setTitleColor(UIColor.white, for: .normal)
                button.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
            }
            else if processString == "1"
            {
                button.setTitle("D", for: .normal)
                button.setTitleColor(UIColor.white, for: .normal)
                button.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
            }
            else
            {
                button.backgroundColor = UIColor.clear
            }
            
            Xpos = Xpos + 62.0
            
//            if(IS_IPHONE_6)
//            {
//                Xpos = Xpos + 50.0
//            }
//            else if(IS_IPHONE_6P)
//            {
//                Xpos = Xpos + 48.4
//            }
//            else
//            {
//                Xpos = Xpos + 49.0
//            }
        }
        
        //memberscrollView.isScrollEnabled = false
        
        morebtn = UIButton()
        morebtn.addTarget(self, action: #selector(self.moreaction(sender:)), for: .touchUpInside)
        morebtn.frame = CGRect(x: CGFloat(screenWidth-75.0), y: CGFloat(0.0), width: CGFloat(35.0), height: CGFloat(35.0))
        morebtn.backgroundColor = redColor
        morebtn.layer.cornerRadius = morebtn.frame.size.height/2.0
        morebtn.layer.masksToBounds = true
        morebtn.setTitle("+16", for: .normal)
        morebtn.setTitleColor(UIColor.white, for: .normal)
        morebtn.titleLabel?.font = UIFont(name: LatoRegular, size: CGFloat(14.0))
        //memberscrollView.addSubview(morebtn)
        
        commonmethodClass.delayWithSeconds(0.5, completion: {
            self.memberscrollView.contentSize = CGSize(width: Xpos, height: self.memberscrollView.frame.size.height)
        })
    }
    
    func moreaction(sender: UIButton!)
    {
        memberscrollView.isScrollEnabled = true
        morebtn.isHidden = true
    }
    
    @IBAction func doneaction(sender : AnyObject)
    {
        let hour = String(format: "%@", taskDictionary.value(forKey: "hours") as! CVarArg)
        let taskid = String(format: "%@", taskDictionary.value(forKey: "id") as! CVarArg)
        if hour == "1"
        {
            self.alertClass.donetaskAlert(taskid: taskid)
        }
        else
        {
            self.alertClass.doneSaveAction(taskid: taskid, hours: "")
        }
    }
    
    @IBAction func notdoneaction(sender : AnyObject)
    {
        let taskid = String(format: "%@", taskDictionary.value(forKey: "id") as! CVarArg)
        self.alertClass.notdonetaskAlert(taskid: taskid)
    }
    
    func close()
    {
        navigation().popViewController(animated: true)
        
        for aviewcontroller : UIViewController in navigation().viewControllers
        {
            if let groupdetailView = aviewcontroller as? GroupDetailViewController
            {
                groupdetailView.getCurrentTask()
                break
            }
        }
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
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "idUserCell") as UITableViewCell!
        
        cell.selectionStyle = .none
        
        let userdictionary = userArray[indexPath.row] as! NSDictionary
        
        let filestring = String(format: "%@%@", kfilePath,userdictionary.value(forKey: "profilePic") as! CVarArg)

        let imageView = AsyncImageView()
        imageView.frame = CGRect(x: CGFloat(15.0), y: CGFloat(10.0), width: CGFloat(40.0), height: CGFloat(40.0))
        imageView.layer.cornerRadius = imageView.frame.size.height / 2.0
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = UIColor.clear
        imageView.imageURL = URL(string: filestring)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        cell.contentView.addSubview(imageView)
        
        /*----------------------------------------------------------------*/
        
        let processString = String(format: "%@", userdictionary.value(forKey: "process") as! CVarArg)

        let button = UIButton()
        button.frame = CGRect(x: CGFloat(0.0), y: CGFloat(0.0), width: CGFloat(imageView.frame.size.width), height: CGFloat(imageView.frame.size.height))
        button.layer.cornerRadius = button.frame.size.height/2.0
        button.layer.masksToBounds = true
        button.titleLabel?.font = UIFont(name: LatoBold, size: 20.0)
        imageView.addSubview(button)
        
        if processString == "2"
        {
            button.setTitle("!", for: .normal)
            button.setTitleColor(UIColor.white, for: .normal)
            button.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
        }
        else if processString == "1"
        {
            button.setTitle("D", for: .normal)
            button.setTitleColor(UIColor.white, for: .normal)
            button.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
        }
        else
        {
            button.backgroundColor = UIColor.clear
        }
        
        /*----------------------------------------------------------------*/

        let firstnamestring = String(format: "%@",userdictionary.value(forKey: "firstName") as! CVarArg)

        let userlbl = UILabel()
        userlbl.frame = CGRect(x: CGFloat(imageView.frame.maxX+10.0), y: CGFloat(5.0), width: CGFloat(screenWidth-70.0), height: CGFloat(20.0))
        userlbl.font = UIFont(name: LatoBold, size: CGFloat(14.0))
        userlbl.backgroundColor = UIColor.clear
        userlbl.textColor = UIColor.darkGray
        userlbl.text = firstnamestring
        cell.contentView.addSubview(userlbl)
        
        /*----------------------------------------------------------------*/
        
        let addressstring = String(format: "%@",userdictionary.value(forKey: "address") as! CVarArg)
        
        let addresslbl = UILabel()
        addresslbl.frame = CGRect(x: CGFloat(imageView.frame.maxX+10.0), y: CGFloat(userlbl.frame.maxY+2.0), width: CGFloat(screenWidth-70.0), height: CGFloat(35.0))
        addresslbl.font = UIFont(name: LatoRegular, size: CGFloat(13.0))
        addresslbl.backgroundColor = UIColor.clear
        addresslbl.textColor = UIColor(red: 119.0/255.0, green: 119.0/255.0, blue: 119.0/255.0, alpha: 1.0)
        addresslbl.text = addressstring
        addresslbl.numberOfLines = 5
        addresslbl.adjustsFontSizeToFitWidth = true
        cell.contentView.addSubview(addresslbl)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 70.0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 45.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let headerheight = self.tableView(tableView, heightForHeaderInSection: section)
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: headerheight))
        headerView.backgroundColor = UIColor(red: 249/255, green: 249/255, blue: 249/255, alpha: 1)
        
        let memberslbl = UILabel()
        memberslbl.frame = CGRect(x: CGFloat(15.0), y: CGFloat(0.0), width: CGFloat(110.0), height: CGFloat(headerheight))
        memberslbl.font = UIFont(name: LatoRegular, size: CGFloat(15.0))
        memberslbl.backgroundColor = UIColor.clear
        memberslbl.textColor = UIColor.darkGray
        memberslbl.text = "Member(s)"
        headerView.addSubview(memberslbl)
        
        return headerView
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
