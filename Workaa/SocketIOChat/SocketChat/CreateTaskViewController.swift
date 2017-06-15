//
//  CreateTaskViewController.swift
//  Workaa
//
//  Created by IN1947 on 31/12/16.
//  Copyright © 2016 IN1947. All rights reserved.
//

import UIKit

class CreateTaskViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, ConnectionProtocol, UIPickerViewDataSource, UIPickerViewDelegate
{
    @IBOutlet weak var taskField : PlaceholderTextView!
    @IBOutlet weak var descriptionView : PlaceholderTextView!
    @IBOutlet weak var goruplbl : UILabel!
    @IBOutlet weak var mytaskField : PlaceholderTextView!
    @IBOutlet weak var mydescriptionView : PlaceholderTextView!
    @IBOutlet weak var mygoruplbl : UILabel!
    @IBOutlet weak var pickerView : UIPickerView!
    @IBOutlet weak var pickView : UIView!
    @IBOutlet weak var scrollview : UIScrollView!
    @IBOutlet weak var memberscrollView: UIScrollView!
    @IBOutlet weak var myTaskscrollview : UIScrollView!
    @IBOutlet weak var switchtype : TTFadeSwitch!
    @IBOutlet weak var criticalswitchtype : TTFadeSwitch!
    @IBOutlet weak var hourField : UITextField!
    @IBOutlet weak var hourFieldheight : NSLayoutConstraint!
    @IBOutlet weak var nooftaskviewheight : NSLayoutConstraint!
    @IBOutlet weak var nooftaskview : UIView!
    @IBOutlet weak var downarrowbtn : UIButton!
    @IBOutlet weak var mytaskgrouplogo : AsyncImageView!
    @IBOutlet weak var mytaskgrouplogowidth : NSLayoutConstraint!
    @IBOutlet weak var taskbtnview : UIView!
    @IBOutlet weak var noofqueueviewheight : NSLayoutConstraint!
    @IBOutlet weak var noofqueueview : UIView!
    @IBOutlet weak var queuedownarrowbtn : UIButton!
    @IBOutlet weak var queuegrouplogo : AsyncImageView!
    @IBOutlet weak var queuegrouplogowidth : NSLayoutConstraint!
    @IBOutlet weak var queuebtnview : UIView!
    @IBOutlet weak var adduserlbl : UILabel!
    @IBOutlet weak var userscrollheight : NSLayoutConstraint!

    var morebtn: UIButton!
    var alertClass = AlertClass()
    var connectionClass = ConnectionClass()
    var commonmethodClass = CommonMethodClass()
    var segmentedControl = HMSegmentedControl()
    var groupArray = NSArray()
    var userArray : NSArray!
    var emailArray = NSMutableArray()
    var myTaskArray = NSMutableArray()
    var logourl = NSURL()
    var mytaskcounter = NSInteger()
    var myTaskGroupId = String()
    var queueArray = NSMutableArray()
    var queuegrouplogourl = NSURL()
    var queuecounter = NSInteger()
    var queueGroupId = String()

    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        mytaskcounter = 0
        queuecounter = 0
        
        let rightcontainView = UIView()
        rightcontainView.frame = CGRect(x: 0.0, y: 0.0, width: 44.0, height: 44.0)
        let closeiconbtn = UIButton()
        closeiconbtn.frame = CGRect(x: CGFloat(0.0), y: CGFloat(0.0), width: CGFloat(44.0), height: CGFloat(44.0))
        closeiconbtn.titleLabel?.font = UIFont(name: Workaa_Font, size: CGFloat(25.0))
        closeiconbtn.backgroundColor = UIColor.clear
        closeiconbtn.setTitleColor(UIColor.white, for: .normal)
        closeiconbtn.setTitle(closeIcon, for: .normal)
        closeiconbtn.contentHorizontalAlignment = .right
        closeiconbtn.addTarget(self, action: #selector(CreateTaskViewController.closeaction), for: .touchUpInside)
        rightcontainView.addSubview(closeiconbtn)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightcontainView)
        
        let leftcontainView = UIView()
        leftcontainView.frame = CGRect(x: 0.0, y: 0.0, width: 44.0, height: 44.0)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftcontainView)
        
        hourField.attributedPlaceholder = NSAttributedString(string: hourField.placeholder!, attributes: [NSForegroundColorAttributeName:UIColor.darkGray])

        connectionClass.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(CreateTaskViewController.handleKeyboardWillShowNotification(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(CreateTaskViewController.handleKeyboardWillHideNotification(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        commonmethodClass.delayWithSeconds(0.5, completion: {
            self.scrollview.contentSize = CGSize(width: screenWidth, height: screenHeight+self.noofqueueviewheight.constant)
            self.myTaskscrollview.contentSize = CGSize(width: screenWidth, height: screenHeight-64.0)
        })
        
        self.loadSegment()
        
        commonmethodClass.delayWithSeconds(0.1, completion: {
            self.getGroupList()
        })
        
        switchtype.thumbImage = UIImage(named: "switchToggle")
        switchtype.thumbHighlightImage = UIImage(named: "switchToggleHigh")
        switchtype.trackMaskImage = UIImage(named: "switchMask")
        switchtype.viewstring = "myTask"
        switchtype.onString = "   DONE"
        switchtype.offString = "ONGOING"
        switchtype.onLabel.font = UIFont(name: LatoBlack, size: CGFloat(11.0))!
        switchtype.offLabel.font = UIFont(name: LatoBlack, size: CGFloat(11.0))!
        switchtype.onLabel.textColor = UIColor.white
        switchtype.offLabel.textColor = UIColor.white
        switchtype.labelsEdgeInsets = UIEdgeInsetsMake(0.0, 15.0, 0.0, 10.0)
        switchtype.thumbInsetX = -3.0
        switchtype.thumbOffsetY = 2.0
        switchtype.isOn = false
        switchtype.addTarget(self, action: #selector(self.setState), for: .valueChanged)
        
        criticalswitchtype.thumbImage = UIImage(named: "switchToggle")
        criticalswitchtype.thumbHighlightImage = UIImage(named: "switchToggleHigh")
        criticalswitchtype.trackMaskImage = UIImage(named: "switchMask")
        criticalswitchtype.viewstring = "addQueue"
        criticalswitchtype.onString = "NORMAL"
        criticalswitchtype.offString = "HIGH  "
        criticalswitchtype.onLabel.font = UIFont(name: LatoBlack, size: CGFloat(11.0))!
        criticalswitchtype.offLabel.font = UIFont(name: LatoBlack, size: CGFloat(11.0))!
        criticalswitchtype.onLabel.textColor = UIColor.white
        criticalswitchtype.offLabel.textColor = UIColor.white
        criticalswitchtype.labelsEdgeInsets = UIEdgeInsetsMake(0.0, 13.0, 0.0, 26.0)
        criticalswitchtype.thumbInsetX = -3.0
        criticalswitchtype.thumbOffsetY = 2.0
        criticalswitchtype.isOn = true

        hourFieldheight.constant = 60.0
        hourField.isHidden = true
        
        for view : UIView in scrollview.subviews
        {
            if let lbl = view as? UILabel
            {
                lbl.isHidden = true
            }
        }
        
        for view : UIView in nooftaskview.subviews
        {
            if let btn = view as? UIButton
            {
                btn.isHidden = true
                
                if(btn.tag==1)
                {
                    btn.setTitle(backarrowIcon, for: .normal)
                }
                if(btn.tag==2)
                {
                    btn.setTitle(solidrightarrowIcon, for: .normal)
                }
            }
        }
        
        for view : UIView in noofqueueview.subviews
        {
            if let btn = view as? UIButton
            {
                btn.isHidden = true
                
                if(btn.tag==1)
                {
                    btn.setTitle(backarrowIcon, for: .normal)
                }
                if(btn.tag==2)
                {
                    btn.setTitle(solidrightarrowIcon, for: .normal)
                }
            }
        }
        
        downarrowbtn.setTitle(soliddownarrowIcon, for: .normal)
        queuedownarrowbtn.setTitle(soliddownarrowIcon, for: .normal)

        nooftaskview.isHidden = true
        nooftaskviewheight.constant = 0.0
        noofqueueview.isHidden = true
        noofqueueviewheight.constant = 0.0
        
        mytaskgrouplogo.isHidden = true
        mytaskgrouplogowidth.constant = 0.0
        queuegrouplogo.isHidden = true
        queuegrouplogowidth.constant = 0.0
        
        adduserlbl.text = adduserIcon
        
        for view : UIView in taskbtnview.subviews
        {
            if(view.tag==1)
            {
                view.layer.borderColor = blueColor.cgColor
                view.layer.borderWidth = 1.0
                
                for view1 : UIView in view.subviews
                {
                    if let lbl = view1 as? UILabel
                    {
                        if(lbl.frame.size.width==30.0)
                        {
                            lbl.text = plusIcon
                        }
                    }
                }
            }
            if(view.tag==2)
            {
                for view1 : UIView in view.subviews
                {
                    if let lbl = view1 as? UILabel
                    {
                        if(lbl.frame.size.width==40.0)
                        {
                            lbl.text = sendIcon
                        }
                    }
                }
            }
        }
        
        for view : UIView in queuebtnview.subviews
        {
            if(view.tag==1)
            {
                view.layer.borderColor = blueColor.cgColor
                view.layer.borderWidth = 1.0
                
                for view1 : UIView in view.subviews
                {
                    if let lbl = view1 as? UILabel
                    {
                        if(lbl.frame.size.width==30.0)
                        {
                            lbl.text = plusIcon
                        }
                    }
                }
            }
            if(view.tag==2)
            {
                for view1 : UIView in view.subviews
                {
                    if let lbl = view1 as? UILabel
                    {
                        if(lbl.frame.size.width==40.0)
                        {
                            lbl.text = sendIcon
                        }
                    }
                }
            }
        }
        
        userscrollheight.constant = 55.0
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = false
        
        navigationController?.navigationBar.barTintColor = blueColor
        
        self.title = "Add Task"
    }
    
    func setState(_ sender: Any)
    {
        let state: Bool = (sender as AnyObject).isOn
        if(state)
        {
            let predicate = NSPredicate(format: "name like %@",mygoruplbl.text!);
            let filteredArray = groupArray.filter { predicate.evaluate(with: $0) };
            if filteredArray.count > 0
            {
                let groupdictionary = filteredArray[0] as! NSDictionary
                let hourstatus = String(format: "%@", groupdictionary.value(forKey: "hours") as! CVarArg)
                if hourstatus == "1"
                {
                    hourFieldheight.constant = 100.0
                    hourField.isHidden = false
                }
                else
                {
                    hourFieldheight.constant = 60.0
                    hourField.isHidden = true
                }
            }
            else
            {
                hourFieldheight.constant = 60.0
                hourField.isHidden = true
            }
        }
        else
        {
            hourFieldheight.constant = 60.0
            hourField.isHidden = true
        }
    }
    
    func getGroupList()
    {
        self.connectionClass.getGroupList()
    }
    
    func loadSegment()
    {
        segmentedControl = HMSegmentedControl(sectionTitles: ["Add to Queue", "My Task"])
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
        if(segmentedControl.selectedSegmentIndex==0)
        {
            scrollview.isHidden = false
            myTaskscrollview.isHidden = true
        }
        else if(segmentedControl.selectedSegmentIndex==1)
        {
            myTaskscrollview.isHidden = false
            scrollview.isHidden = true
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
            titlelbl.frame = CGRect(x: CGFloat(Xpos-2.5), y: CGFloat(userImage.frame.maxY + 5.0), width: CGFloat(45.0), height: CGFloat(20.0))
            titlelbl.font = UIFont(name: LatoRegular, size: CGFloat(12.0))
            titlelbl.backgroundColor = UIColor.clear
            titlelbl.textColor = UIColor.black
            titlelbl.text = firstnamestring
            titlelbl.textAlignment = .center
//            titlelbl.adjustsFontSizeToFitWidth = true
            memberscrollView.addSubview(titlelbl)
            
            let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CreateTaskViewController.userSelectAction))
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
        
        //memberscrollView.isScrollEnabled = false
        
        userscrollheight.constant = 135.0
        memberscrollView.isHidden = false
        
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
    
    // MARK: - Action Methods

    func closeaction()
    {
        navigation().popViewController(animated: true)
    }
    
    // MARK: - KeyboardNotification Methods
    
    func handleKeyboardWillShowNotification(notification: NSNotification)
    {
        if let userInfo = notification.userInfo
        {
            if let keyboardFrame = (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue
            {
                pickView.isHidden = true
                self.scrollview.contentSize = CGSize(width: screenWidth, height: screenHeight+keyboardFrame.size.height+self.noofqueueviewheight.constant)
                self.myTaskscrollview.contentSize = CGSize(width: screenWidth, height: screenHeight+keyboardFrame.size.height-50.0)
            }
        }
    }
    
    func handleKeyboardWillHideNotification(notification: NSNotification)
    {
        self.scrollview.contentSize = CGSize(width: screenWidth, height: screenHeight+self.noofqueueviewheight.constant)
        self.myTaskscrollview.contentSize = CGSize(width: screenWidth, height: screenHeight-64.0)
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
            if let getgrouplist = getreponse.value(forKey: "groupList") as? NSArray
            {
                groupArray = getgrouplist
                
                if groupArray.count == 1
                {
                    let groupdictionary = groupArray[0] as! NSDictionary
                    
                    /*------------------------------------------------------*/
                    
                    goruplbl.text = groupdictionary["name"] as? String
                    queuegrouplogowidth.constant = 30.0
                    queuegrouplogo.isHidden = false
                    
                    var filestring = String(format: "%@%@", kfilePath,groupdictionary.value(forKey: "logo") as! CVarArg)
                    queuegrouplogourl = NSURL(string: filestring)!
                    queuegrouplogo.imageURL = queuegrouplogourl as URL?
                    
                    queueGroupId = String(format: "%@",groupdictionary.value(forKey: "id") as! CVarArg)
                    
                    /*------------------------------------------------------*/
                    
                    mygoruplbl.text = groupdictionary["name"] as? String
                    mytaskgrouplogowidth.constant = 30.0
                    mytaskgrouplogo.isHidden = false
                    
                    filestring = String(format: "%@%@", kfilePath,groupdictionary.value(forKey: "logo") as! CVarArg)
                    logourl = NSURL(string: filestring)!
                    mytaskgrouplogo.imageURL = logourl as URL?
                    
                    myTaskGroupId = String(format: "%@",groupdictionary.value(forKey: "id") as! CVarArg)
                    
                    /*------------------------------------------------------*/
                    
                    if goruplbl.text != "Select a Group"
                    {
                        let predicate = NSPredicate(format: "name like %@",goruplbl.text!);
                        let filteredArray = groupArray.filter { predicate.evaluate(with: $0) };
                        if filteredArray.count > 0
                        {
                            let groupdictionary = filteredArray[0] as! NSDictionary
                            let adminString = String(format: "%@", groupdictionary.value(forKey: "admin") as! CVarArg)
                            if(commonmethodClass.retrieveteamadmin()=="1" || adminString=="1")
                            {
                                connectionClass.UserList(groupid: (groupdictionary["id"] as? String)!)
                            }
                            else
                            {
                                emailArray.removeAllObjects()
                                memberscrollView.subviews.forEach { $0.removeFromSuperview() }
                                userscrollheight.constant = 55.0
                                memberscrollView.isHidden = true
                            }
                        }
                    }
                    
                    /*------------------------------------------------------*/

                    if mygoruplbl.text != "Select a Group"
                    {
                        if(switchtype.isOn)
                        {
                            let predicate = NSPredicate(format: "name like %@",mygoruplbl.text!);
                            let filteredArray = groupArray.filter { predicate.evaluate(with: $0) };
                            if filteredArray.count > 0
                            {
                                let groupdictionary = filteredArray[0] as! NSDictionary
                                let hourstatus = String(format: "%@", groupdictionary.value(forKey: "hours") as! CVarArg)
                                if hourstatus == "1"
                                {
                                    hourFieldheight.constant = 100.0
                                    hourField.isHidden = false
                                }
                                else
                                {
                                    hourFieldheight.constant = 60.0
                                    hourField.isHidden = true
                                }
                            }
                            else
                            {
                                hourFieldheight.constant = 60.0
                                hourField.isHidden = true
                            }
                        }
                    }
                }
            }
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
    }
    
    @IBAction func selectGroup(sender : AnyObject)
    {
        pickView.isHidden = false
        pickerView.reloadAllComponents()
        
        taskField.resignFirstResponder()
        descriptionView.resignFirstResponder()
        mytaskField.resignFirstResponder()
        mydescriptionView.resignFirstResponder()
        hourField.resignFirstResponder()
    }
    
    @IBAction func doneAction(sender : AnyObject)
    {
        pickView.isHidden = true
        taskField.resignFirstResponder()
        descriptionView.resignFirstResponder()
        mytaskField.resignFirstResponder()
        mydescriptionView.resignFirstResponder()
        hourField.resignFirstResponder()

        if(IS_IPHONE_5)
        {
            self.scrollview.setContentOffset(CGPoint(x: 0.0, y: 0.0), animated: true)
            self.myTaskscrollview.setContentOffset(CGPoint(x: 0.0, y: 0.0), animated: false)
        }
        
        if(segmentedControl.selectedSegmentIndex==0)
        {
            if goruplbl.text != "Select a Group"
            {
                let predicate = NSPredicate(format: "name like %@",goruplbl.text!);
                let filteredArray = groupArray.filter { predicate.evaluate(with: $0) };
                if filteredArray.count > 0
                {
                    let groupdictionary = filteredArray[0] as! NSDictionary
                    let adminString = String(format: "%@", groupdictionary.value(forKey: "admin") as! CVarArg)
                    if(commonmethodClass.retrieveteamadmin()=="1" || adminString=="1")
                    {
                        connectionClass.UserList(groupid: (groupdictionary["id"] as? String)!)
                    }
                    else
                    {
                        emailArray.removeAllObjects()
                        memberscrollView.subviews.forEach { $0.removeFromSuperview() }
                        userscrollheight.constant = 55.0
                        memberscrollView.isHidden = true
                    }
                }
            }
        }
        else if(segmentedControl.selectedSegmentIndex==1)
        {
            if mygoruplbl.text != "Select a Group"
            {
                if(switchtype.isOn)
                {
                    let predicate = NSPredicate(format: "name like %@",mygoruplbl.text!);
                    let filteredArray = groupArray.filter { predicate.evaluate(with: $0) };
                    if filteredArray.count > 0
                    {
                        let groupdictionary = filteredArray[0] as! NSDictionary
                        let hourstatus = String(format: "%@", groupdictionary.value(forKey: "hours") as! CVarArg)
                        if hourstatus == "1"
                        {
                            hourFieldheight.constant = 100.0
                            hourField.isHidden = false
                        }
                        else
                        {
                            hourFieldheight.constant = 60.0
                            hourField.isHidden = true
                        }
                    }
                    else
                    {
                        hourFieldheight.constant = 60.0
                        hourField.isHidden = true
                    }
                }
            }
        }
    }
    
    @IBAction func SumbitAction(sender : AnyObject)
    {
        pickView.isHidden = true
        taskField.resignFirstResponder()
        descriptionView.resignFirstResponder()
        
        if taskField.text?.characters.count == 0
        {
            alertClass.showAlert(alerttitle: "Info", alertmsg: taskAddReponse.value(forKey: "taskRequired") as! String)
        }
        else if goruplbl.text == "Select a Group"
        {
            alertClass.showAlert(alerttitle: "Info", alertmsg: taskAddReponse.value(forKey: "groupRequired") as! String)
        }
        else if (taskField.text?.characters.count)! > 255
        {
            alertClass.showAlert(alerttitle: "Info", alertmsg: taskAddReponse.value(forKey: "taskLength") as! String)
        }
        else
        {
            let predicate = NSPredicate(format: "name like %@",goruplbl.text!);
            let filteredArray = groupArray.filter { predicate.evaluate(with: $0) };
            if filteredArray.count > 0
            {
                var priority = "0"
                if(!criticalswitchtype.isOn)
                {
                    priority = "1"
                }
                
                let groupdictionary = filteredArray[0] as! NSDictionary
                if(sender.tag==1)
                {
                    let seleArray = NSMutableArray();
                    for email in emailArray
                    {
                        seleArray.add(email)
                    }
                    
                    let dictionary = NSMutableDictionary()
                    dictionary.setValue(queueGroupId, forKey: "group_id")
                    dictionary.setValue(queuegrouplogourl, forKey: "group_logo")
                    dictionary.setValue(goruplbl.text, forKey: "group_name")
                    dictionary.setValue(taskField.text, forKey: "task_title")
                    dictionary.setValue(descriptionView.text, forKey: "task_desc")
                    dictionary.setValue(priority, forKey: "task_priority")
                    dictionary.setValue(userArray, forKey: "total_users")
                    dictionary.setValue(seleArray, forKey: "selected_users")
                    queueArray.add(dictionary)
                    
                    queueGroupId = ""
                    taskField.text = ""
                    descriptionView.text = ""
                    queuegrouplogourl = NSURL(string: "")!
                    criticalswitchtype.isOn = true
                    userscrollheight.constant = 55.0
                    memberscrollView.isHidden = true
                    goruplbl.text = "Select a Group"
                    queuegrouplogo.isHidden = true
                    queuegrouplogowidth.constant = 0.0
                    emailArray.removeAllObjects()
                    
                    print("queueArray =>\(queueArray)")
                    
                    if(queueArray.count>0)
                    {
                        noofqueueview.isHidden = false
                        noofqueueviewheight.constant = 50.0
                    }
                    
                    for view : UIView in noofqueueview.subviews
                    {
                        if let btn = view as? UIButton
                        {
//                            if(queueArray.count==1)
//                            {
//                                btn.isHidden = true
//                            }
//                            else
//                            {
                                if(btn.tag==1)
                                {
                                    btn.isHidden = false
                                }
                                if(btn.tag==2)
                                {
                                    btn.isHidden = true
                                }
                            //}
                        }
                        if let lbl = view as? UILabel
                        {
                            queuecounter = queueArray.count
                            lbl.text = String(format: "%d of %d Tasks", queuecounter,queueArray.count)
                        }
                    }
                }
                else
                {
                    if(queueArray.count>0)
                    {
                        for item in queueArray
                        {
                            let obj = item as! NSDictionary
                            let groupId = String(format: "%@",obj.value(forKey: "group_id") as! CVarArg)
                            let taskname = String(format: "%@",obj.value(forKey: "task_title") as! CVarArg)
                            let taskdescription = String(format: "%@",obj.value(forKey: "task_desc") as! CVarArg)
                            let priority = String(format: "%@",obj.value(forKey: "task_priority") as! CVarArg)
                            let selemailArray = obj.value(forKey: "selected_users") as! NSMutableArray

                            if selemailArray.count == 0
                            {
                                connectionClass.AddQueue(groupid: groupId, taskname: taskname, taskdescription: taskdescription, priority: priority)
                            }
                            else
                            {
                                connectionClass.CreateTask(groupid: groupId, taskname: taskname, taskdescription: taskdescription, users: selemailArray.componentsJoined(by: ","), priority: priority)
                            }
                        }
                    }
                    else
                    {
                        if emailArray.count == 0
                        {
                            connectionClass.AddQueue(groupid: (groupdictionary["id"] as? String)!, taskname: taskField.text!, taskdescription: descriptionView.text, priority: priority)
                        }
                        else
                        {
                            connectionClass.CreateTask(groupid: (groupdictionary["id"] as? String)!, taskname: taskField.text!, taskdescription: descriptionView.text, users: emailArray.componentsJoined(by: ","), priority: priority)
                        }
                    }
                    
                    navigation().popViewController(animated: true)
                }
            }
        }
    }
    
    @IBAction func myTaskSubmitAction(sender : AnyObject)
    {
        pickView.isHidden = true
        mytaskField.resignFirstResponder()
        mydescriptionView.resignFirstResponder()
        hourField.resignFirstResponder()

        if mytaskField.text?.characters.count == 0
        {
            alertClass.showAlert(alerttitle: "Info", alertmsg: taskAddReponse.value(forKey: "taskRequired") as! String)
        }
        else if mygoruplbl.text == "Select a Group"
        {
            alertClass.showAlert(alerttitle: "Info", alertmsg: taskAddReponse.value(forKey: "groupRequired") as! String)
        }
        else if (taskField.text?.characters.count)! > 255
        {
            alertClass.showAlert(alerttitle: "Info", alertmsg: taskAddReponse.value(forKey: "taskLength") as! String)
        }
        else
        {
            if(hourFieldheight.constant == 100.0)
            {
                if hourField.text?.characters.count == 0
                {
                    alertClass.showAlert(alerttitle: "Info", alertmsg: taskAddReponse.value(forKey: "hoursRequired") as! String)
                    return
                }
            }
            
            let predicate = NSPredicate(format: "name like %@",mygoruplbl.text!);
            let filteredArray = groupArray.filter { predicate.evaluate(with: $0) };
            if filteredArray.count > 0
            {
                var status = "0"
                if(switchtype.isOn)
                {
                    status = "1"
                }
                
                let groupdictionary = filteredArray[0] as! NSDictionary
                if(sender.tag==1)
                {
                    let dictionary = NSMutableDictionary()
                    dictionary.setValue(myTaskGroupId, forKey: "group_id")
                    dictionary.setValue(logourl, forKey: "group_logo")
                    dictionary.setValue(mygoruplbl.text, forKey: "group_name")
                    dictionary.setValue(mytaskField.text, forKey: "task_title")
                    dictionary.setValue(mydescriptionView.text, forKey: "task_desc")
                    dictionary.setValue(status, forKey: "task_status")
                    dictionary.setValue(hourField.text, forKey: "task_hour")
                    myTaskArray.add(dictionary)

                    myTaskGroupId = ""
                    mytaskField.text = ""
                    mydescriptionView.text = ""
                    hourField.text = ""
                    logourl = NSURL(string: "")!
                    switchtype.isOn = false
                    hourFieldheight.constant = 60.0
                    hourField.isHidden = true
                    mygoruplbl.text = "Select a Group"
                    mytaskgrouplogo.isHidden = true
                    mytaskgrouplogowidth.constant = 0.0
                    
                    print("myTaskArray =>\(myTaskArray)")
                    if(myTaskArray.count>0)
                    {
                        nooftaskview.isHidden = false
                        nooftaskviewheight.constant = 50.0
                    }
                    
                    for view : UIView in nooftaskview.subviews
                    {
                        if let btn = view as? UIButton
                        {
//                            if(myTaskArray.count==1)
//                            {
//                                btn.isHidden = true
//                            }
//                            else
//                            {
                                if(btn.tag==1)
                                {
                                    btn.isHidden = false
                                }
                                if(btn.tag==2)
                                {
                                    btn.isHidden = true
                                }
                            //}
                        }
                        if let lbl = view as? UILabel
                        {
                            mytaskcounter = myTaskArray.count
                            lbl.text = String(format: "%d of %d Tasks", mytaskcounter,myTaskArray.count)
                        }
                    }
                    
                    self.myTaskscrollview.setContentOffset(CGPoint(x: 0.0, y: 0.0), animated: true)
                }
                else
                {
                    if(myTaskArray.count>0)
                    {
                        for item in myTaskArray
                        {
                            let obj = item as! NSDictionary
                            let groupId = String(format: "%@",obj.value(forKey: "group_id") as! CVarArg)
                            let taskname = String(format: "%@",obj.value(forKey: "task_title") as! CVarArg)
                            let taskdescription = String(format: "%@",obj.value(forKey: "task_desc") as! CVarArg)
                            let status = String(format: "%@",obj.value(forKey: "task_status") as! CVarArg)
                            let hours = String(format: "%@",obj.value(forKey: "task_hour") as! CVarArg)

                            connectionClass.CreateMyTask(groupid: groupId, taskname: taskname, taskdescription: taskdescription, status: status, hours: hours)
                        }
                    }
                    else
                    {
                        connectionClass.CreateMyTask(groupid: (groupdictionary["id"] as? String)!, taskname: mytaskField.text!, taskdescription: mydescriptionView.text, status: status, hours: hourField.text!)
                    }
                    
                    navigation().popViewController(animated: true)
                }
            }
        }
    }
    
    @IBAction func myTaskNextAction(sender : AnyObject)
    {
        mytaskcounter += 1
        
        if(mytaskcounter>(myTaskArray.count-1))
        {
            mytaskcounter = myTaskArray.count - 1
        }
        
        print("mytaskcounter =>\(mytaskcounter)")
        
        for view : UIView in nooftaskview.subviews
        {
            if let btn = view as? UIButton
            {
                if(mytaskcounter==(myTaskArray.count-1))
                {
                    if(btn.tag==1)
                    {
                        btn.isHidden = false
                    }
                    if(btn.tag==2)
                    {
                        btn.isHidden = true
                    }
                }
                else
                {
                    if(btn.tag==1)
                    {
                        btn.isHidden = false
                    }
                }
            }
            if let lbl = view as? UILabel
            {
                lbl.text = String(format: "%d of %d Tasks", mytaskcounter+1,myTaskArray.count)
            }
        }
        
        self.myTaskUpdate()
    }
    
    @IBAction func myTaskPreviousAction(sender : AnyObject)
    {
        mytaskcounter -= 1
        
        if(mytaskcounter<0)
        {
            mytaskcounter = 0
        }
        
        print("mytaskcounter =>\(mytaskcounter)")
        
        for view : UIView in nooftaskview.subviews
        {
            if let btn = view as? UIButton
            {
                if(mytaskcounter==0)
                {
                    if(btn.tag==1)
                    {
                        btn.isHidden = true
                    }
                    if(btn.tag==2)
                    {
                        btn.isHidden = false
                    }
                }
                else
                {
                    if(mytaskcounter != (myTaskArray.count-1))
                    {
                        if(btn.tag==2)
                        {
                            btn.isHidden = false
                        }
                    }
                }
            }
            if let lbl = view as? UILabel
            {
                lbl.text = String(format: "%d of %d Tasks", mytaskcounter+1,myTaskArray.count)
            }
        }
        
        self.myTaskUpdate()
    }
    
    func myTaskUpdate()
    {
        let taskdictionary = myTaskArray[mytaskcounter] as! NSDictionary
        print("taskdictionary =>\(taskdictionary)")
        
        mytaskgrouplogowidth.constant = 30.0
        mytaskgrouplogo.isHidden = false
        
        mygoruplbl.text = String(format: "%@",taskdictionary.value(forKey: "group_name") as! CVarArg)
        
        let filestring = String(format: "%@",taskdictionary.value(forKey: "group_logo") as! CVarArg)
        let logurl = NSURL(string: filestring)!
        mytaskgrouplogo.imageURL = logurl as URL?
        
        mytaskField.text = String(format: "%@",taskdictionary.value(forKey: "task_title") as! CVarArg)
        mydescriptionView.text = String(format: "%@",taskdictionary.value(forKey: "task_desc") as! CVarArg)
        hourField.text = String(format: "%@",taskdictionary.value(forKey: "task_hour") as! CVarArg)
        
        if (hourField.text?.characters.count)! == 0
        {
            hourFieldheight.constant = 60.0
            hourField.isHidden = true
        }
        else
        {
            hourFieldheight.constant = 100.0
            hourField.isHidden = false
        }
        
        let statusstring = String(format: "%@",taskdictionary.value(forKey: "task_status") as! CVarArg)
        if statusstring == "1"
        {
            switchtype.isOn = true
        }
        else
        {
            switchtype.isOn = false
        }
    }
    
    @IBAction func queueNextAction(sender : AnyObject)
    {
        queuecounter += 1
        
        if(queuecounter>(queueArray.count-1))
        {
            queuecounter = queueArray.count - 1
        }
        
        print("queuecounter =>\(queuecounter)")
        
        for view : UIView in noofqueueview.subviews
        {
            if let btn = view as? UIButton
            {
                if(queuecounter==(queueArray.count-1))
                {
                    if(btn.tag==1)
                    {
                        btn.isHidden = false
                    }
                    if(btn.tag==2)
                    {
                        btn.isHidden = true
                    }
                }
                else
                {
                    if(btn.tag==1)
                    {
                        btn.isHidden = false
                    }
                }
            }
            if let lbl = view as? UILabel
            {
                lbl.text = String(format: "%d of %d Tasks", queuecounter+1,queueArray.count)
            }
        }
        
        self.queueUpdate()
    }
    
    @IBAction func queuePreviousAction(sender : AnyObject)
    {
        queuecounter -= 1
        
        if(queuecounter<0)
        {
            queuecounter = 0
        }
        
        print("queuecounter =>\(queuecounter)")
        
        for view : UIView in noofqueueview.subviews
        {
            if let btn = view as? UIButton
            {
                if(queuecounter==0)
                {
                    if(btn.tag==1)
                    {
                        btn.isHidden = true
                    }
                    if(btn.tag==2)
                    {
                        btn.isHidden = false
                    }
                }
                else
                {
                    if(queuecounter != (queueArray.count-1))
                    {
                        if(btn.tag==2)
                        {
                            btn.isHidden = false
                        }
                    }
                }
            }
            if let lbl = view as? UILabel
            {
                lbl.text = String(format: "%d of %d Tasks", queuecounter+1,queueArray.count)
            }
        }
        
        self.queueUpdate()
    }
    
    func queueUpdate()
    {
        let queuedictionary = queueArray[queuecounter] as! NSDictionary
        print("queuedictionary =>\(queuedictionary)")
        
        queuegrouplogowidth.constant = 30.0
        queuegrouplogo.isHidden = false
        
        goruplbl.text = String(format: "%@",queuedictionary.value(forKey: "group_name") as! CVarArg)
        
        let filestring = String(format: "%@",queuedictionary.value(forKey: "group_logo") as! CVarArg)
        let logurl = NSURL(string: filestring)!
        queuegrouplogo.imageURL = logurl as URL?
        
        taskField.text = String(format: "%@",queuedictionary.value(forKey: "task_title") as! CVarArg)
        descriptionView.text = String(format: "%@",queuedictionary.value(forKey: "task_desc") as! CVarArg)
        
        let proritystring = String(format: "%@",queuedictionary.value(forKey: "task_priority") as! CVarArg)
        if proritystring == "0"
        {
            criticalswitchtype.isOn = true
        }
        else
        {
            criticalswitchtype.isOn = false
        }
        
        userArray = queuedictionary.value(forKey: "total_users") as! NSArray
        emailArray = queuedictionary.value(forKey: "selected_users") as! NSMutableArray
        
        if(userArray.count>0)
        {
            userscrollheight.constant = 135.0
            memberscrollView.isHidden = false
        }
        
        memberscrollView.subviews.forEach { $0.removeFromSuperview() }
        
        var Xpos : CGFloat!
        Xpos = 0.0
        for i in 0 ..< userArray.count
        {
            let userdictionary = userArray[i] as! NSDictionary
            
            let emailstring = String(format: "%@", userdictionary.value(forKey: "email") as! CVarArg)
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
            titlelbl.frame = CGRect(x: CGFloat(Xpos-2.5), y: CGFloat(userImage.frame.maxY + 5.0), width: CGFloat(45.0), height: CGFloat(20.0))
            titlelbl.font = UIFont(name: LatoRegular, size: CGFloat(12.0))
            titlelbl.backgroundColor = UIColor.clear
            titlelbl.textColor = UIColor.black
            titlelbl.text = firstnamestring
            titlelbl.textAlignment = .center
            memberscrollView.addSubview(titlelbl)
            
            let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CreateTaskViewController.userSelectAction))
            tapGesture.numberOfTapsRequired = 1
            userImage.addGestureRecognizer(tapGesture)
            
            if(emailArray.contains(emailstring))
            {
                let titlelbl = UILabel()
                titlelbl.frame = CGRect(x: CGFloat(0.0), y: CGFloat(0.0), width: CGFloat(userImage.frame.size.width), height: CGFloat(userImage.frame.size.height))
                titlelbl.font = UIFont(name: Workaa_Font, size: CGFloat(30.0))
                titlelbl.backgroundColor = UIColor.clear
                titlelbl.textColor = UIColor.white
                titlelbl.text = tickIcon
                titlelbl.textAlignment = .center
                titlelbl.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
                userImage.addSubview(titlelbl)
            }
            
            Xpos = Xpos + 62.0
        }
        
        self.memberscrollView.contentSize = CGSize(width: Xpos, height: self.memberscrollView.frame.size.height)
    }
    
    // MARK: - didReceiveMemoryWarning

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - PickerView Delegate
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return groupArray.count;
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        let groupdictionary = groupArray[row] as! NSDictionary
        if(segmentedControl.selectedSegmentIndex==0)
        {
            goruplbl.text = groupdictionary["name"] as? String
            queuegrouplogowidth.constant = 30.0
            queuegrouplogo.isHidden = false
            
            let filestring = String(format: "%@%@", kfilePath,groupdictionary.value(forKey: "logo") as! CVarArg)
            queuegrouplogourl = NSURL(string: filestring)!
            queuegrouplogo.imageURL = queuegrouplogourl as URL?
            
            queueGroupId = String(format: "%@",groupdictionary.value(forKey: "id") as! CVarArg)
        }
        else if(segmentedControl.selectedSegmentIndex==1)
        {
            mygoruplbl.text = groupdictionary["name"] as? String
            mytaskgrouplogowidth.constant = 30.0
            mytaskgrouplogo.isHidden = false
            
            let filestring = String(format: "%@%@", kfilePath,groupdictionary.value(forKey: "logo") as! CVarArg)
            logourl = NSURL(string: filestring)!
            mytaskgrouplogo.imageURL = logourl as URL?
            
            myTaskGroupId = String(format: "%@",groupdictionary.value(forKey: "id") as! CVarArg)
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat
    {
        return 50
    }

    @objc func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView
    {
        let myView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: pickerView.bounds.width - 30.0, height: 50.0))
        
        let groupdictionary = groupArray[row] as! NSDictionary
        
        let filestring = String(format: "%@%@", kfilePath,groupdictionary.value(forKey: "logo") as! CVarArg)
        let fileUrl = NSURL(string: filestring)
        
        let logoImage = AsyncImageView()
        logoImage.frame = CGRect(x: CGFloat(10.0), y: CGFloat(10.0), width: CGFloat(30.0), height: CGFloat(30.0))
        logoImage.layer.cornerRadius = logoImage.frame.size.height / 2.0
        logoImage.layer.masksToBounds = true
        logoImage.backgroundColor = UIColor.clear
        logoImage.imageURL = fileUrl as URL?
        logoImage.contentMode = .scaleAspectFill
        logoImage.clipsToBounds = true
        myView.addSubview(logoImage)
        
        let namestring = String(format: "%@", groupdictionary.value(forKey: "name") as! CVarArg)
        
        let namelbl = UILabel()
        namelbl.frame = CGRect(x: CGFloat(logoImage.frame.maxX + 10.0), y: CGFloat(0.0), width: CGFloat((myView.frame.size.width - (logoImage.frame.maxX + 10.0))), height: CGFloat(myView.frame.size.height))
        namelbl.font = UIFont(name: LatoRegular, size: CGFloat(18.0))
        namelbl.backgroundColor = UIColor.clear
        namelbl.textColor = UIColor.black
        namelbl.text = namestring
        myView.addSubview(namelbl)
        
        return myView
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
