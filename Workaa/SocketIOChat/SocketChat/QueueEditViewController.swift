//
//  QueueEditViewController.swift
//  Workaa
//
//  Created by IN1947 on 29/05/17.
//  Copyright © 2017 IN1947. All rights reserved.
//

import UIKit

@objc protocol QueueUpdate:class
{
    func refreshTaskDetails()
    func dismissView()
}

class QueueEditViewController: UIViewController, UITextViewDelegate, ConnectionProtocol
{
    @IBOutlet weak var taskField : PlaceholderTextView!
    @IBOutlet weak var descriptionView : PlaceholderTextView!
    @IBOutlet weak var goruplbl : UILabel!
    @IBOutlet weak var scrollview : UIScrollView!
    @IBOutlet weak var switchtype : TTFadeSwitch!
    @IBOutlet weak var grouplogo : AsyncImageView!
    @IBOutlet weak var submitbtn = UIButton()
    @IBOutlet weak var memberscrollView = UIScrollView()
    @IBOutlet weak var memberscrollheight = NSLayoutConstraint()

    var taskDictionary = NSMutableDictionary()
    var connectionClass = ConnectionClass()
    weak var delegate:QueueUpdate?
    var taskstring = String()
    var commonmethodClass = CommonMethodClass()
    var userArray = NSArray()
    var emailArray = NSMutableArray()

    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        connectionClass.delegate = self

        self.title = taskstring
        
        let rightcontainView = UIView()
        rightcontainView.frame = CGRect(x: 0.0, y: 0.0, width: 44.0, height: 44.0)
        let closeiconbtn = UIButton()
        closeiconbtn.frame = CGRect(x: CGFloat(0.0), y: CGFloat(0.0), width: CGFloat(44.0), height: CGFloat(44.0))
        closeiconbtn.titleLabel?.font = UIFont(name: Workaa_Font, size: CGFloat(25.0))
        closeiconbtn.backgroundColor = UIColor.clear
        closeiconbtn.setTitleColor(UIColor.white, for: .normal)
        closeiconbtn.setTitle(closeIcon, for: .normal)
        closeiconbtn.contentHorizontalAlignment = .right
        closeiconbtn.addTarget(self, action: #selector(self.closeaction), for: .touchUpInside)
        rightcontainView.addSubview(closeiconbtn)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightcontainView)
        
        switchtype.thumbImage = UIImage(named: "switchToggle")
        switchtype.thumbHighlightImage = UIImage(named: "switchToggleHigh")
        switchtype.trackMaskImage = UIImage(named: "switchMask")
        switchtype.viewstring = "addQueue"
        switchtype.onString = "NORMAL"
        switchtype.offString = "HIGH  "
        switchtype.onLabel.font = UIFont(name: LatoBlack, size: CGFloat(11.0))!
        switchtype.offLabel.font = UIFont(name: LatoBlack, size: CGFloat(11.0))!
        switchtype.onLabel.textColor = UIColor.white
        switchtype.offLabel.textColor = UIColor.white
        switchtype.labelsEdgeInsets = UIEdgeInsetsMake(0.0, 13.0, 0.0, 26.0)
        switchtype.thumbInsetX = -3.0
        switchtype.thumbOffsetY = 2.0
        switchtype.isOn = true
        
        let type = String(format: "%@", taskDictionary.value(forKey: "priority") as! CVarArg)
        if type == "0"
        {
            switchtype.isOn = true
        }
        else
        {
            switchtype.isOn = false
        }
        
        let filestring = String(format: "%@%@", kfilePath, taskDictionary.value(forKey: "groupLogo") as! CVarArg)
        let fileUrl = NSURL(string: filestring)
        grouplogo.imageURL = fileUrl as URL?
        
        goruplbl.text = String(format: "%@", taskDictionary.value(forKey: "groupName") as! CVarArg)
        
        taskField.text = String(format: "%@", taskDictionary.value(forKey: "task") as! CVarArg)
        
        descriptionView.text = String(format: "%@", taskDictionary.value(forKey: "info") as! CVarArg)

        print("taskDictionary =>\(taskDictionary)")
        
        if taskstring == "Assign Task"
        {
            if(userArray.count>0)
            {
                self.loadMemberView()
            }
            memberscrollheight?.constant = 120.0
            submitbtn?.setTitle("Assign Task", for: .normal)
        }
        else
        {
            memberscrollheight?.constant = 0.0
            submitbtn?.setTitle("Update", for: .normal)
        }
    }
    
    func closeaction()
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func updateaction(sender : AnyObject)
    {
        if(taskField.text?.characters.count==0)
        {
            self.showAlert(alerttitle: "Info", alertmsg: queueToTaskReponse.value(forKey: "taskRequired") as! String)
        }
        else if((taskField.text?.characters.count)!>255)
        {
            self.showAlert(alerttitle: "Info", alertmsg: queueToTaskReponse.value(forKey: "taskLength") as! String)
        }
        else
        {
            var priority = "0"
            if(!switchtype.isOn)
            {
                priority = "1"
            }
            
            if taskstring == "Assign Task"
            {
                if(emailArray.count==0)
                {
                    self.showAlert(alerttitle: "Info", alertmsg: queueToTaskReponse.value(forKey: "usersRequired") as! String)
                }
                else
                {
                    connectionClass.queueToTask(taskid: taskDictionary.value(forKey: "id") as! String, taskname: taskField.text!, taskdescription: descriptionView.text, users: emailArray.componentsJoined(by: ","), priority: priority)
                }
            }
            else
            {
                connectionClass.queueEdit(groupId: taskDictionary.value(forKey: "groupId") as! String, taskid: taskDictionary.value(forKey: "id") as! String, taskname: taskField.text!, taskdescription: descriptionView.text, priority: priority)
            }
        }
    }
    
    func showAlert(alerttitle : String, alertmsg : String)
    {
        let alertController = UIAlertController(title: alerttitle, message: alertmsg, preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func loadMemberView()
    {
        emailArray.removeAllObjects()
        
        memberscrollView?.subviews.forEach { $0.removeFromSuperview() }
        
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
            memberscrollView?.addSubview(userImage)
            
            let titlelbl = UILabel()
            titlelbl.frame = CGRect(x: CGFloat(Xpos-2.5), y: CGFloat(userImage.frame.maxY + 5.0), width: CGFloat(45.0), height: CGFloat(20.0))
            titlelbl.font = UIFont(name: LatoRegular, size: CGFloat(12.0))
            titlelbl.backgroundColor = UIColor.clear
            titlelbl.textColor = UIColor.darkGray
            titlelbl.text = firstnamestring
            titlelbl.textAlignment = .center
            //            titlelbl.adjustsFontSizeToFitWidth = true
            memberscrollView?.addSubview(titlelbl)
            
            let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.userSelectAction))
            tapGesture.numberOfTapsRequired = 1
            userImage.addGestureRecognizer(tapGesture)
            
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
        
        commonmethodClass.delayWithSeconds(0.5, completion: {
            self.memberscrollView?.contentSize = CGSize(width: Xpos, height: (self.memberscrollView?.frame.size.height)!)
        })
    }
    
    func userSelectAction(_ sender: UITapGestureRecognizer)
    {
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
    
    // MARK: - Connection Delegate
    
    func GetFailureReponseMethod(errorreponse: String)
    {
        print("GetFailureReponseMethod =>\(errorreponse)")
        self.showAlert(alerttitle: "Info", alertmsg: errorreponse)
    }
    
    func GetReponseMethod(reponse : NSDictionary)
    {
        print("reponse => \(reponse)")
        
        if taskstring == "Assign Task"
        {
            self.closeaction()
            self.delegate?.dismissView()
        }
        else
        {
            var priority = "0"
            if(!switchtype.isOn)
            {
                priority = "1"
            }
            
            taskDictionary.setValue(taskField.text!, forKey: "task")
            taskDictionary.setValue(descriptionView.text, forKey: "info")
            taskDictionary.setValue(priority, forKey: "priority")
            
            self.delegate?.refreshTaskDetails()
            
            self.closeaction()
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
        
        return true
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
