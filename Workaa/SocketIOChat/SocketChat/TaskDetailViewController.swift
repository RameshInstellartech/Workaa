//
//  TaskDetailViewController.swift
//  Workaa
//
//  Created by IN1947 on 24/02/17.
//  Copyright © 2017 IN1947. All rights reserved.
//

import UIKit

class TaskDetailViewController: UIViewController, ConnectionProtocol, UITextViewDelegate
{
    @IBOutlet weak var tasktopView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var memberscrollView: UIScrollView!
    @IBOutlet weak var taskdesc: UITextView!
    @IBOutlet weak var taskdescheight: NSLayoutConstraint!
    @IBOutlet weak var tasktopheight: NSLayoutConstraint!
    @IBOutlet weak var closebtn: UIButton!

    var tasktitle: UITextView!
    var morebtn: UIButton!
    var commonmethodClass = CommonMethodClass()
    var taskDictionary = NSDictionary()
    var userArray = NSArray()
    var emailArray = NSMutableArray()
    var connectionClass = ConnectionClass()
    var priority: String!
    var priorityView = UIView()
    var prioritybool = Bool()

    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        connectionClass.delegate = self
        prioritybool = false

        print("taskDictionary =>\(taskDictionary)")
        
        closebtn.setTitle(backarrowIcon, for: .normal)
        closebtn.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 10)
        
        commonmethodClass.delayWithSeconds(0.1, completion: {
            self.getUserList()
        })
        
        self.loadtaskdetailView()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func getUserList()
    {
        connectionClass.UserList(groupid: (taskDictionary["groupId"] as? String)!)
    }
    
    func loadtaskdetailView()
    {
        let nameView = UIView()
        nameView.backgroundColor = UIColor.clear
        nameView.frame = CGRect(x: CGFloat((screenWidth - 120.0) / 2.0), y: CGFloat(25.0), width: CGFloat(120.0), height: CGFloat(30.0))
        nameView.layer.borderColor = UIColor.white.cgColor
        nameView.layer.borderWidth = 1.0
        nameView.layer.cornerRadius = nameView.frame.size.height / 2.0
        nameView.layer.masksToBounds = true
        tasktopView.addSubview(nameView)
        
        let filestring = String(format: "%@%@", kfilePath,(taskDictionary["userPic"] as? String)!)
        let fileUrl = NSURL(string: filestring)
        
        let profileImage = AsyncImageView()
        profileImage.frame = CGRect(x: CGFloat(5.0), y: CGFloat(5.0), width: CGFloat(20.0), height: CGFloat(20.0))
        profileImage.layer.cornerRadius = profileImage.frame.size.height / 2.0
        profileImage.layer.masksToBounds = true
        profileImage.backgroundColor = UIColor.clear
        profileImage.imageURL = fileUrl as URL?
        profileImage.contentMode = .scaleAspectFill
        profileImage.clipsToBounds = true
        nameView.addSubview(profileImage)
        
        let namestring = String(format: "%@ %@", (taskDictionary["firstName"] as? String)!,(taskDictionary["lastName"] as? String)!)
        
        let namelbl = UILabel()
        namelbl.frame = CGRect(x: CGFloat(profileImage.frame.maxX + 8.0), y: CGFloat(0.0), width: CGFloat((nameView.frame.size.width - (profileImage.frame.maxX + 5.0)) - 5), height: CGFloat(nameView.frame.size.height))
        namelbl.font = UIFont(name: LatoRegular, size: CGFloat(13.0))
        namelbl.backgroundColor = UIColor.clear
        namelbl.textColor = UIColor.white
        namelbl.text = namestring
        nameView.addSubview(namelbl)
        
        /*----------------------------------------------------------*/
        
        priorityView.frame = CGRect(x: CGFloat((tasktopView.frame.size.width - 100.0) / 2.0), y: CGFloat(nameView.frame.maxY + 10.0), width: CGFloat(100.0), height: CGFloat(20.0))
        priorityView.layer.cornerRadius = priorityView.frame.size.height / 2.0
        priorityView.layer.masksToBounds = true
        tasktopView.addSubview(priorityView)
        
        let starImage = UIImageView()
        starImage.frame = CGRect(x: CGFloat(5.0), y: CGFloat(3.0), width: CGFloat(14.0), height: CGFloat(14.0))
        starImage.backgroundColor = UIColor.clear
        priorityView.addSubview(starImage)
        
        let prioritylbl = UILabel()
        prioritylbl.frame = CGRect(x: CGFloat(starImage.frame.maxX + 8.0), y: CGFloat(0.0), width: CGFloat((priorityView.frame.size.width - (starImage.frame.maxX + 5.0)) - 5), height: CGFloat(priorityView.frame.size.height))
        prioritylbl.font = UIFont(name: LatoItalic, size: CGFloat(12.0))
        prioritylbl.backgroundColor = UIColor.clear
        prioritylbl.textColor = UIColor.white
        priorityView.addSubview(prioritylbl)
        
        priority = String(format: "%@", taskDictionary.value(forKey: "priority") as! CVarArg)
        
        if priority == "0"
        {
            starImage.image = UIImage(named: "grey_star.png")
            priorityView.backgroundColor = UIColor.clear
            prioritylbl.text = "Normal"
            priorityView.layer.borderColor = UIColor.white.cgColor
            priorityView.layer.borderWidth = 1.0
        }
        else
        {
            starImage.image = UIImage(named: "yellowstar.png")
            priorityView.backgroundColor = redColor
            prioritylbl.text = "Priority"
        }
        
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(TaskDetailViewController.priorityaction))
        tapGesture.numberOfTapsRequired = 1
        priorityView.addGestureRecognizer(tapGesture)
        
        let priorityediticonbtn = UIButton()
        priorityediticonbtn.frame = CGRect(x: CGFloat(priorityView.frame.maxX), y: CGFloat(priorityView.frame.origin.y-10.0), width: CGFloat(40.0), height: CGFloat(40.0))
        priorityediticonbtn.titleLabel?.font = UIFont(name: Workaa_Font, size: CGFloat(14.0))
        priorityediticonbtn.backgroundColor = UIColor.clear
        priorityediticonbtn.setTitleColor(UIColor.white, for: .normal)
        priorityediticonbtn.setTitle(editIcon, for: .normal)
        priorityediticonbtn.addTarget(self, action: #selector(TaskDetailViewController.priorityeditaction), for: .touchUpInside)
        //tasktopView.addSubview(priorityediticonbtn)

        /*----------------------------------------------------------*/

        let groupnameView = UIView()
        groupnameView.backgroundColor = UIColor.clear
        groupnameView.frame = CGRect(x: CGFloat(0.0), y: CGFloat(tasktopView.frame.size.height - 40.0), width: CGFloat(tasktopView.frame.size.width), height: CGFloat(25.0))
        tasktopView.addSubview(groupnameView)
        
        let groupimagestring = String(format: "%@%@",kfilePath, (taskDictionary["groupLogo"] as? String)!)
        
        let groupImage = AsyncImageView()
        groupImage.frame = CGRect(x: CGFloat(0.0), y: CGFloat(0.0), width: CGFloat(groupnameView.frame.size.height), height: CGFloat(groupnameView.frame.size.height))
        groupImage.layer.cornerRadius = groupImage.frame.size.height / 2.0
        groupImage.layer.masksToBounds = true
        groupImage.backgroundColor = UIColor.clear
        groupImage.imageURL = URL(string: groupimagestring)
        groupImage.contentMode = .scaleAspectFill
        groupImage.clipsToBounds = true
        groupnameView.addSubview(groupImage)
        
        let groupstring = String(format: "%@", (taskDictionary["groupName"] as? String)!)
        
        let titlelbl = UILabel()
        titlelbl.frame = CGRect(x: CGFloat(groupImage.frame.maxX + 8.0), y: CGFloat(0.0), width: CGFloat((groupnameView.frame.size.width - (groupImage.frame.maxX + 5.0)) - 5), height: CGFloat(groupnameView.frame.size.height))
        titlelbl.font = UIFont(name: LatoBold, size: CGFloat(14.0))
        titlelbl.backgroundColor = UIColor.clear
        titlelbl.textColor = UIColor.white
        titlelbl.text = groupstring
        groupnameView.addSubview(titlelbl)
        
        let groupwidth: CGFloat = titlelbl.intrinsicContentSize.width + 40.0
        groupnameView.frame = CGRect(x: CGFloat((tasktopView.frame.size.width - groupwidth) / 2.0), y: CGFloat(tasktopView.frame.size.height - 40.0), width: groupwidth, height: CGFloat(25.0))
        
        /*----------------------------------------------------------*/
        
        let datestring = String(format: "%@", (taskDictionary["time"] as? String)!)
        
        let datelbl = UILabel()
        datelbl.frame = CGRect(x: CGFloat(tasktopView.frame.size.width-55.0), y: CGFloat(30.0), width: CGFloat(45.0), height: CGFloat(21.0))
        datelbl.font = UIFont(name: LatoRegular, size: CGFloat(12.0))
        datelbl.backgroundColor = UIColor.clear
        datelbl.textColor = UIColor.white
        datelbl.text = String(format: "%@", commonmethodClass.convertDateFormatter(date: datestring))
        datelbl.textAlignment = .right
        datelbl.adjustsFontSizeToFitWidth = true
        tasktopView.addSubview(datelbl)
        
        let dateiconlbl = UILabel()
        dateiconlbl.frame = CGRect(x: CGFloat(datelbl.frame.origin.x - 16.0), y: CGFloat(31.0), width: CGFloat(15.0), height: CGFloat(21.0))
        dateiconlbl.font = UIFont(name: Workaa_Font, size: CGFloat(14.0))
        dateiconlbl.backgroundColor = UIColor.clear
        dateiconlbl.textColor = UIColor.white
        dateiconlbl.text = clockIcon
        tasktopView.addSubview(dateiconlbl)
        
        /*----------------------------------------------------------*/
        
        let taskstring = String(format: "%@", (taskDictionary["task"] as? String)!)
        
        let titleheight: CGFloat = (groupnameView.frame.origin.y - CGFloat(priorityView.frame.maxY + 10.0)) - 10.0

        tasktitle = UITextView()
        tasktitle.font = UIFont(name: LatoBold, size: CGFloat(16.0))
        
//        var height = commonmethodClass.dynamicHeight(width: screenWidth-40, font: tasktitle.font!, string: taskstring)
//        if height < 95.0
//        {
//            height = 95.0
//        }
//        print("height =>\(height)")
//        let topviewheight = 240.0 + (height-95.0)
//        if topviewheight < 240.0
//        {
//            tasktopheight.constant = 240.0
//        }
//        print("tasktopheight.constant =>\(tasktopheight.constant)")
//        print("topviewheight =>\(topviewheight)")
        
        tasktitle.frame = CGRect(x: CGFloat(10.0), y: CGFloat(priorityView.frame.maxY + 10.0), width: screenWidth-20.0, height: CGFloat(titleheight))
        tasktitle.backgroundColor = UIColor.clear
        tasktitle.delegate = self
        tasktitle.textColor = UIColor.white
        tasktitle.text = taskstring
        tasktitle.textAlignment = .center
        tasktitle.isEditable = false
        tasktopView.addSubview(tasktitle)
        
        let titleediticonbtn = UIButton()
        titleediticonbtn.frame = CGRect(x: CGFloat(screenWidth-40.0), y: CGFloat(tasktitle.frame.origin.y-20.0), width: CGFloat(40.0), height: CGFloat(40.0))
        titleediticonbtn.titleLabel?.font = UIFont(name: Workaa_Font, size: CGFloat(14.0))
        titleediticonbtn.contentVerticalAlignment = .top
        titleediticonbtn.backgroundColor = UIColor.clear
        titleediticonbtn.setTitleColor(UIColor.white, for: .normal)
        titleediticonbtn.setTitle(editIcon, for: .normal)
        titleediticonbtn.addTarget(self, action: #selector(TaskDetailViewController.titleeditaction), for: .touchUpInside)
        tasktopView.addSubview(titleediticonbtn)
        
        /*----------------------------------------------------------*/
        
        taskdesc.text = String(format: "%@", taskDictionary.value(forKey: "info") as! CVarArg)
        taskdesc.isEditable = false
        taskdescheight.constant = commonmethodClass.dynamicHeight(width: screenWidth-40, font: taskdesc.font!, string: taskdesc.text!)
        if(taskdescheight.constant<30.0)
        {
            taskdescheight.constant = 30.0
        }
        else
        {
            taskdescheight.constant = taskdescheight.constant + 20.0
        }
        
        let descediticonbtn = UIButton()
        descediticonbtn.frame = CGRect(x: CGFloat(screenWidth-40.0), y: CGFloat(tasktopView.frame.size.height), width: CGFloat(40.0), height: CGFloat(40.0))
        descediticonbtn.titleLabel?.font = UIFont(name: Workaa_Font, size: CGFloat(14.0))
        descediticonbtn.backgroundColor = UIColor.clear
        descediticonbtn.setTitleColor(UIColor.darkGray, for: .normal)
        descediticonbtn.setTitle(editIcon, for: .normal)
        descediticonbtn.addTarget(self, action: #selector(TaskDetailViewController.desceditaction), for: .touchUpInside)
        scrollView.addSubview(descediticonbtn)
        
        /*----------------------------------------------------------*/

        let assignString = String(format: "%@", taskDictionary.value(forKey: "assign") as! CVarArg)
        if assignString == "0"
        {
            descediticonbtn.isHidden = true
            titleediticonbtn.isHidden = true
        }
        else
        {
            descediticonbtn.isHidden = false
            titleediticonbtn.isHidden = false
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
    
    func loadMemberView()
    {
        emailArray.removeAllObjects()
        
        memberscrollView.subviews.forEach { $0.removeFromSuperview() }
        
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
        
//        memberscrollView.isScrollEnabled = false
        
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
    
    func userSelectAction(_ sender: UITapGestureRecognizer)
    {
        let assignString = String(format: "%@", taskDictionary.value(forKey: "assign") as! CVarArg)
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
    
    func priorityaction(_ sender: UITapGestureRecognizer)
    {
        if(!prioritybool)
        {
            return
        }
        
        if priority == "0"
        {
            priority = "1"
            for view : UIView in priorityView.subviews
            {
                if let lbl = view as? UILabel
                {
                    lbl.text = "Priority"
                }
                if let image = view as? UIImageView
                {
                    image.image = UIImage(named: "yellowstar.png")
                }
            }
            priorityView.backgroundColor = redColor
            priorityView.layer.borderColor = UIColor.clear.cgColor
            priorityView.layer.borderWidth = 0.0
        }
        else
        {
            priority = "0"
            for view : UIView in priorityView.subviews
            {
                if let lbl = view as? UILabel
                {
                    lbl.text = "Normal"
                }
                if let image = view as? UIImageView
                {
                    image.image = UIImage(named: "grey_star.png")
                }
            }
            priorityView.backgroundColor = UIColor.clear
            priorityView.layer.borderColor = UIColor.white.cgColor
            priorityView.layer.borderWidth = 1.0
        }
    }
    
    func priorityeditaction()
    {
        prioritybool = true
    }
    
    func titleeditaction()
    {
        prioritybool = true
        tasktitle.isEditable = true
    }
    
    func desceditaction()
    {
        taskdesc.isEditable = true
    }
    
    @IBAction func closeaction(sender : AnyObject)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func lateraction(sender : AnyObject)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func assigntaskaction(sender : AnyObject)
    {
        if(tasktitle.text?.characters.count==0)
        {
            self.showAlert(alerttitle: "Info", alertmsg: queueToTaskReponse.value(forKey: "taskRequired") as! String)
        }
        else if((tasktitle.text?.characters.count)!>255)
        {
            self.showAlert(alerttitle: "Info", alertmsg: queueToTaskReponse.value(forKey: "taskLength") as! String)
        }
        else if(taskdesc.text.characters.count==0)
        {
            self.showAlert(alerttitle: "Info", alertmsg: queueToTaskReponse.value(forKey: "infoRequired") as! String)
        }
        else if(emailArray.count==0)
        {
            self.showAlert(alerttitle: "Info", alertmsg: queueToTaskReponse.value(forKey: "usersRequired") as! String)
        }
        else
        {
            connectionClass.queueToTask(taskid: taskDictionary.value(forKey: "id") as! String, taskname: tasktitle.text!, taskdescription: taskdesc.text, users: emailArray.componentsJoined(by: ","), priority: priority)
        }
    }
    
    func showAlert(alerttitle : String, alertmsg : String)
    {
        let alertController = UIAlertController(title: alerttitle, message: alertmsg, preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
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
                self.showAlert(alerttitle: "Info", alertmsg: queueToTaskReponse.value(forKey: "taskLength") as! String)
                return false
            }
        }
        
        return true
    }
    
    func textViewDidChange(_ textView: UITextView)
    {
        if(textView==tasktitle)
        {
//            var height = commonmethodClass.dynamicHeight(width: screenWidth-40, font: tasktitle.font!, string: tasktitle.text!)
//            if height < 95.0
//            {
//                height = 95.0
//            }
//            print("height =>\(height)")
//            
//            var frame = tasktitle.frame
//            frame.size.height = height
//            tasktitle.frame = frame
//            
//            let topviewheight = 240.0 + (height-95.0)
//            if topviewheight < 240.0
//            {
//                tasktopheight.constant = 240.0
//            }
//            print("tasktopheight.constant =>\(tasktopheight.constant)")
//            print("topviewheight =>\(topviewheight)")
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
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    // MARK: - didReceiveMemoryWarning

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
