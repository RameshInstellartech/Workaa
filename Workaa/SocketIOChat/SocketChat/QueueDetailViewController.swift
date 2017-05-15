//
//  QueueDetailViewController.swift
//  Workaa
//
//  Created by IN1947 on 28/02/17.
//  Copyright © 2017 IN1947. All rights reserved.
//

import UIKit

class QueueDetailViewController: UIViewController, ConnectionProtocol, UITextViewDelegate
{
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var tasktitle: UITextView!
    @IBOutlet weak var tasktitleheight: NSLayoutConstraint!
    @IBOutlet weak var assignlbl: UILabel!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var memberscrollView: UIScrollView!
    @IBOutlet weak var datelbl: UILabel!
    @IBOutlet weak var taskdesc: UITextView!
    @IBOutlet weak var taskdescheight: NSLayoutConstraint!
    @IBOutlet weak var profileimage: AsyncImageView!
    @IBOutlet weak var groupNamelbl: UILabel!
    @IBOutlet weak var titleediticonbtn: UIButton!
    @IBOutlet weak var descediticonbtn: UIButton!

    var userArray = NSArray()
    var queueDictionary = NSDictionary()
    var morebtn: UIButton!
    var commonmethodClass = CommonMethodClass()
    var alertClass = AlertClass()
    var connectionClass = ConnectionClass()
    var emailArray = NSMutableArray()
    var bottomView : BottomView!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        connectionClass.delegate = self
        
        print("queueDictionary =>\(queueDictionary)")
        
        let filestring = String(format: "%@%@", kfilePath,(queueDictionary["groupLogo"] as? String)!)
        let fileUrl = NSURL(string: filestring)
        profileimage.imageURL = fileUrl as URL?
        
        groupNamelbl.text = String(format: "%@", queueDictionary.value(forKey: "groupName") as! CVarArg)
        
        tasktitle.text = String(format: "%@", queueDictionary.value(forKey: "task") as! CVarArg)
        tasktitleheight.constant = commonmethodClass.dynamicHeight(width: screenWidth-40, font: tasktitle.font!, string: tasktitle.text!)
        if(tasktitleheight.constant<30.0)
        {
            tasktitleheight.constant = 30.0
        }
        else
        {
            tasktitleheight.constant = tasktitleheight.constant + 20.0
        }
        
        assignlbl.text = String(format: "by %@ %@", queueDictionary.value(forKey: "firstName") as! CVarArg, queueDictionary.value(forKey: "lastName") as! CVarArg)
        
        let priority = String(format: "%@", queueDictionary.value(forKey: "priority") as! CVarArg)
        if priority == "1"
        {
            statusView.isHidden = false
        }
        else
        {
            statusView.isHidden = true
        }
        
        let time = String(format: "%@", queueDictionary.value(forKey: "time") as! CVarArg)
        datelbl.text = String(format: "%@", commonmethodClass.convertDateInCell(date: time))
        
        taskdesc.text = String(format: "%@", queueDictionary.value(forKey: "info") as! CVarArg)
        taskdescheight.constant = commonmethodClass.dynamicHeight(width: screenWidth-40, font: taskdesc.font!, string: taskdesc.text!)
        if(taskdescheight.constant<30.0)
        {
            taskdescheight.constant = 30.0
        }
        else
        {
            taskdescheight.constant = taskdescheight.constant + 20.0
        }
        
        commonmethodClass.delayWithSeconds(0.1, completion: {
            self.getUserList()
        })
        
        self.loadbottomView()
        
        titleediticonbtn.setTitle(editIcon, for: .normal)
        descediticonbtn.setTitle(editIcon, for: .normal)
        
        let assignString = String(format: "%@", queueDictionary.value(forKey: "assign") as! CVarArg)
        if assignString == "0"
        {
            titleediticonbtn.isHidden = true
            descediticonbtn.isHidden = true
        }
        else
        {
            titleediticonbtn.isHidden = false
            descediticonbtn.isHidden = false
        }
        
        for view : UIView in self.view.subviews
        {
            for view1 : UIView in view.subviews
            {
                if view1.frame.size.height==40
                {
                    if assignString == "0"
                    {
                        view1.isHidden = true
                    }
                    else
                    {
                        view1.isHidden = false
                    }
                }
            }
        }
    }

    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = false
        
        navigationController?.navigationBar.barTintColor = blueColor
        
        self.title = String(format: "Welcome, %@", commonmethodClass.retrieveusername())
    }
    
    func loadbottomView()
    {
        bottomView = Bundle.main.loadNibNamed("BottomView", owner: nil, options: nil)?[0] as! BottomView
        bottomView.frame = CGRect(x: 0.0, y: screenHeight-124.0, width: screenWidth, height: 60.0)
        bottomView.loadbottomView(tag: 0)
        self.view.addSubview(bottomView)
    }
    
    func getUserList()
    {
        connectionClass.UserList(groupid: (queueDictionary["groupId"] as? String)!)
    }

    func loadMemberView()
    {
        var Xpos : CGFloat!
        Xpos = 0.0
        for i in 0 ..< userArray.count
        {
            let userdictionary = userArray[i] as! NSDictionary

            let filestring = String(format: "%@%@", kfilePath,userdictionary.value(forKey: "pic") as! CVarArg)
            let fileUrl = NSURL(string: filestring)
            
            let firstnamestring = String(format: "%@",userdictionary.value(forKey: "firstName") as! CVarArg)
            
            let userImage = AsyncImageView()
            userImage.frame = CGRect(x: CGFloat(Xpos), y: CGFloat(0.0), width: CGFloat(40.0), height: CGFloat(40.0))
            userImage.layer.cornerRadius = userImage.frame.size.height / 2.0
            userImage.layer.masksToBounds = true
            userImage.backgroundColor = UIColor.clear
            userImage.imageURL = fileUrl as URL?
            userImage.tag = i
            userImage.isUserInteractionEnabled = true
            userImage.contentMode = .scaleAspectFill
            userImage.clipsToBounds = true
            memberscrollView.addSubview(userImage)
            
            let titlelbl = UILabel()
            titlelbl.frame = CGRect(x: CGFloat(Xpos), y: CGFloat(userImage.frame.maxY + 5.0), width: CGFloat(40.0), height: CGFloat(20.0))
            titlelbl.font = UIFont(name: LatoRegular, size: CGFloat(12.0))
            titlelbl.backgroundColor = UIColor.clear
            titlelbl.textColor = UIColor.black
            titlelbl.text = firstnamestring
            titlelbl.textAlignment = .center
//            titlelbl.adjustsFontSizeToFitWidth = true
            memberscrollView.addSubview(titlelbl)
            
            let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(TaskDetailViewController.userSelectAction))
            tapGesture.numberOfTapsRequired = 1
            userImage.addGestureRecognizer(tapGesture)
            
            Xpos = Xpos + 60.0
            
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
        
        self.memberscrollView.contentSize = CGSize(width: Xpos, height: self.memberscrollView.frame.size.height)
    }
    
    func moreaction(sender: UIButton!)
    {
        memberscrollView.isScrollEnabled = true
        morebtn.isHidden = true
    }
    
    func userSelectAction(_ sender: UITapGestureRecognizer)
    {
        let assignString = String(format: "%@", queueDictionary.value(forKey: "assign") as! CVarArg)
        if assignString == "0"
        {
            return
        }
        
        let tappedView = sender.view as! AsyncImageView
        let userdictionary = userArray[tappedView.tag] as! NSDictionary
        let emailstring = String(format: "%@", userdictionary.value(forKey: "email") as! CVarArg)
        
        if tappedView.subviews.count==0
        {
            let titlelbl = UILabel()
            titlelbl.frame = CGRect(x: CGFloat(0.0), y: CGFloat(0.0), width: CGFloat(tappedView.frame.size.width), height: CGFloat(tappedView.frame.size.height))
            titlelbl.font = UIFont(name: Workaa_Font, size: CGFloat(30.0))
            titlelbl.backgroundColor = UIColor.clear
            titlelbl.textColor = UIColor.white
            titlelbl.text = tickIcon
            titlelbl.textAlignment = .center
            titlelbl.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
            tappedView.addSubview(titlelbl)
            
            emailArray.add(emailstring)
        }
        else
        {
            for v: UIView in tappedView.subviews {
                v.removeFromSuperview()
            }
            
            emailArray.remove(emailstring)
        }
        
        print("emailArray =>\(emailArray)")
    }
    
    @IBAction func titleeditaction(sender : AnyObject)
    {
        tasktitle.isEditable = true
    }
    
    @IBAction func desceditaction(sender : AnyObject)
    {
        taskdesc.isEditable = true
    }

    @IBAction func lateraction(sender : AnyObject)
    {
        navigation().popViewController(animated: true)
    }
    
    @IBAction func assigntaskaction(sender : AnyObject)
    {
        if(tasktitle.text.characters.count==0)
        {
            alertClass.showAlert(alerttitle: "Info", alertmsg: queueToTaskReponse.value(forKey: "taskRequired") as! String)
        }
        else if(tasktitle.text.characters.count>255)
        {
            alertClass.showAlert(alerttitle: "Info", alertmsg: queueToTaskReponse.value(forKey: "taskLength") as! String)
        }
        else if(taskdesc.text.characters.count==0)
        {
            alertClass.showAlert(alerttitle: "Info", alertmsg: queueToTaskReponse.value(forKey: "infoRequired") as! String)
        }
        else if(emailArray.count==0)
        {
            alertClass.showAlert(alerttitle: "Info", alertmsg: queueToTaskReponse.value(forKey: "usersRequired") as! String)
        }
        else
        {
            connectionClass.queueToTask(taskid: queueDictionary.value(forKey: "id") as! String, taskname: tasktitle.text, taskdescription: taskdesc.text, users: emailArray.componentsJoined(by: ","), priority: String(format: "%@", queueDictionary.value(forKey: "priority") as! CVarArg))
        }
    }
    
    // MARK: - UITextView Delegate
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool
    {
        if (text == "\n")
        {
            textView.resignFirstResponder()
            return false
        }
        
        if(textView==tasktitle)
        {
            let string = String(format: "%@%@", textView.text,text)
            if(string.characters.count>255)
            {
                alertClass.showAlert(alerttitle: "Info", alertmsg: queueToTaskReponse.value(forKey: "taskLength") as! String)
                return false
            }
        }

        return true
    }
    
    func textViewDidChange(_ textView: UITextView)
    {
        if(textView==tasktitle)
        {
            self.tasktitleheight.constant = self.commonmethodClass.dynamicHeight(width: screenWidth-40, font: self.tasktitle.font!, string: self.tasktitle.text!)
            if(self.tasktitleheight.constant<30.0)
            {
                self.tasktitleheight.constant = 30.0
            }
            else
            {
                self.tasktitleheight.constant = self.tasktitleheight.constant + 20.0
            }
        }
        if(textView==taskdesc)
        {
            taskdescheight.constant = commonmethodClass.dynamicHeight(width: screenWidth-40, font: taskdesc.font!, string: taskdesc.text!)
            if(taskdescheight.constant<30.0)
            {
                taskdescheight.constant = 30.0
            }
            else
            {
                taskdescheight.constant = taskdescheight.constant + 20.0
            }
        }
    }
    
    // MARK: - Connection Delegate
    
    func GetFailureReponseMethod(errorreponse: String)
    {
        print("GetFailureReponseMethod")
    }
    
    func GetReponseMethod(reponse : NSDictionary)
    {
        print("reponse => \(reponse)")
        
        if let getreponse = reponse.value(forKey: "data") as? NSDictionary
        {
            if let users = getreponse.value(forKey: "usersList") as? NSArray
            {
                userArray = users
                print("userArray => \(userArray)")
                if(userArray.count>0)
                {
                    self.loadMemberView()
                }
            }
        }
        else
        {
            for aviewcontroller : UIViewController in navigation().viewControllers
            {
                if let tasklistView = aviewcontroller as? TaskListViewController
                {
                    tasklistView.getQueueList()
                    break
                }
            }
            navigation().popViewController(animated: true)
        }
    }

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
