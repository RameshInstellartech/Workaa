//
//  ProfileViewController.swift
//  Workaa
//
//  Created by IN1947 on 20/03/17.
//  Copyright © 2017 IN1947. All rights reserved.
//

import UIKit
import Photos

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, ConnectionProtocol, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UITextViewDelegate, ICTokenFieldDelegate
{
    @IBOutlet weak var scrollView : UIScrollView!
    @IBOutlet weak var tblprofile: UITableView!
    @IBOutlet weak var pickerView : UIPickerView!
    @IBOutlet weak var pickView : UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var datepickView : UIView!
    
    private let skillsfield = CustomizedTokenField()
    var addresstxtView = PlaceholderTextView()

    var generalInfoArray = NSArray()
    var workInfoArray = NSArray()
    var contactInfoArray = NSArray()
    var imageBool : Bool!
    var imagecount : NSInteger!
    var generalInfoBool : Bool!
    var generalInfocount : NSInteger!
    var workInfoBool : Bool!
    var workInfocount : NSInteger!
    var contactInfoBool : Bool!
    var contactInfocount : NSInteger!
    var alertClass = AlertClass()
    var imgData : NSData!
    var pickimage : UIImage!
    var profileDictionary = NSDictionary()
    var connectionClass = ConnectionClass()
    var commonmethodClass = CommonMethodClass()
    var profileString : String!
    var generalInfoDictionary = NSDictionary()
    var contactInfoDictionary = NSDictionary()
    var workInfoDictionary = NSDictionary()
    var generaleditBool : Bool!
    var workinfoeditBool : Bool!
    var contactInfoeditBool : Bool!
    var genderArray = NSArray()
    var gendertxtfield = UITextField()
    var brithdaytxtfield = UITextField()
    var firstnametxtfield = UITextField()
    var lastnametxtfield = UITextField()
    var locationtxtfield = UITextField()
    var phonetxtfield = UITextField()
    var designationtxtfield = UITextField()
    var scrollheight = CGFloat()

    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        connectionClass.delegate = self
        
        imagecount = 0
        imageBool = false
        generalInfocount = 0
        generalInfoBool = false
        workInfocount = 0
        workInfoBool = false
        contactInfocount = 0
        contactInfoBool = false
        profileString = ""
        generaleditBool = false
        workinfoeditBool = false
        contactInfoeditBool = false
        
        generalInfoArray = ["First name", "Last name", "Gender", "Birthday", "Location"] as NSArray
        workInfoArray = ["Designation", "Skills"] as NSArray
        contactInfoArray = ["Mobile", "e-Mail ID", "Address"] as NSArray

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
            self.getProfileInfo()
        })
        
        NotificationCenter.default.addObserver(self, selector: #selector(ProfileViewController.handleKeyboardWillShowNotification(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ProfileViewController.handleKeyboardWillHideNotification(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        tblprofile.register(UINib(nibName: "ProfileInfoTableViewCell", bundle: nil), forCellReuseIdentifier: "ProfileInfoCell")
        
        tblprofile.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = false
        
        navigationController?.navigationBar.barTintColor = blueColor
        
        self.title = "Profile"
        
        navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: LatoRegular, size: CGFloat(18.0))!, NSForegroundColorAttributeName : UIColor.white];
    }
    
    // MARK: - KeyboardNotification Methods
    
    func handleKeyboardWillShowNotification(notification: NSNotification)
    {
        if let userInfo = notification.userInfo
        {
            if let keyboardFrame = (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue
            {
                scrollView.contentSize = CGSize(width: screenWidth, height: scrollheight+keyboardFrame.size.height)
            }
        }
    }
    
    func handleKeyboardWillHideNotification(notification: NSNotification)
    {
        if let userInfo = notification.userInfo
        {
            if ((userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil
            {
                scrollView.contentSize = CGSize(width: screenWidth, height: scrollheight)
            }
        }
    }
    
    func loadProfile()
    {
        scrollView.subviews.forEach { $0.removeFromSuperview() }

        var yPos = CGFloat()
        yPos = 0.0
        for i in 0 ..< 4
        {
            let view = UIView()
            view.backgroundColor = UIColor.white
            view.tag = i
            scrollView.addSubview(view)
            
            if i == 0
            {
                let profileImage = AsyncImageView()
                profileImage.frame = CGRect(x: CGFloat((screenWidth-120.0)/2.0), y: CGFloat(20.0), width: CGFloat(120.0), height: CGFloat(120.0))
                profileImage.layer.cornerRadius = profileImage.frame.size.height / 2.0
                profileImage.layer.masksToBounds = true
                profileImage.backgroundColor = UIColor.clear
                profileImage.layer.borderWidth = 1.0
                profileImage.layer.borderColor = lightgrayColor.cgColor
                profileImage.contentMode = .scaleAspectFill
                profileImage.clipsToBounds = true
                profileImage.isUserInteractionEnabled = true
                view.addSubview(profileImage)
                
                if(pickimage != nil)
                {
                    profileImage.image = pickimage
                }
                else
                {
                    if profileString != ""
                    {
                        let imagestring = String(format: "%@%@", kfilePath,profileString)
                        let fileUrl = NSURL(string: imagestring)
                        profileImage.imageURL = fileUrl as URL?
                    }
                }
                
                let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.profileaction))
                tapGesture.numberOfTapsRequired = 1
                profileImage.addGestureRecognizer(tapGesture)
                
                let uploadlbl = UILabel()
                uploadlbl.frame = CGRect(x: CGFloat(0.0), y: CGFloat(150.0), width: CGFloat(screenWidth), height: CGFloat(25.0))
                uploadlbl.font = UIFont(name: LatoRegular, size: CGFloat(15.0))
                uploadlbl.backgroundColor = UIColor.clear
                uploadlbl.textColor = blueColor
                uploadlbl.text = "Upload Photo"
                uploadlbl.textAlignment = .center
                view.addSubview(uploadlbl)
                
                view.frame = CGRect(x: CGFloat(0.0), y: CGFloat(0.0), width: CGFloat(screenWidth), height: CGFloat(190.0))
            }
            else if i == 1
            {
                var generalyPos = CGFloat()
                generalyPos = 0.0
                for j in 0 ..< 6
                {
                    let generalview = UIView()
                    generalview.frame = CGRect(x: CGFloat(0.0), y: CGFloat(generalyPos), width: CGFloat(screenWidth), height: CGFloat(50.0))
                    generalview.tag = j
                    view.addSubview(generalview)
                    
                    if j == 0
                    {
                        generalview.backgroundColor = UIColor(red: 245.0/255.0, green: 245.0/255.0, blue: 245.0/255.0, alpha: 1.0)
                        
                        let infolbl = UILabel()
                        infolbl.frame = CGRect(x: CGFloat(15.0), y: CGFloat(0.0), width: CGFloat(screenWidth-95.0), height: CGFloat(50.0))
                        infolbl.font = UIFont(name: LatoBold, size: CGFloat(15.0))
                        infolbl.backgroundColor = UIColor.clear
                        infolbl.textColor = UIColor(red: 47.0/255.0, green: 47.0/255.0, blue: 47.0/255.0, alpha: 1.0)
                        infolbl.text = "GENERAL INFO"
                        generalview.addSubview(infolbl)
                        
                        let savebtn = UIButton()
                        savebtn.frame = CGRect(x: CGFloat(screenWidth-75.0), y: CGFloat(0.0), width: CGFloat(60.0), height: CGFloat(50.0))
                        savebtn.backgroundColor = UIColor.clear
                        savebtn.addTarget(self, action: #selector(self.saveaction(sender:)), for: .touchUpInside)
                        savebtn.tag = i
                        savebtn.setTitle("SAVE", for: .normal)
                        savebtn.setTitleColor(UIColor.lightGray, for: .normal)
                        savebtn.titleLabel?.font = UIFont(name: LatoBold, size: CGFloat(15.0))
                        savebtn.contentHorizontalAlignment = .right
                        generalview.addSubview(savebtn)
                        
                        let lineview = UIView()
                        lineview.backgroundColor = lightgrayColor
                        lineview.frame = CGRect(x: CGFloat(0.0), y: CGFloat(49.0), width: CGFloat(screenWidth), height: CGFloat(1.0))
                        generalview.addSubview(lineview)
                    }
                    else
                    {
                        generalview.backgroundColor = UIColor.white
                        
                        let generallbl = UILabel()
                        generallbl.frame = CGRect(x: CGFloat(15.0), y: CGFloat(0.0), width: CGFloat(screenWidth-190), height: CGFloat(49.0))
                        generallbl.font = UIFont(name: LatoRegular, size: CGFloat(15.0))
                        generallbl.backgroundColor = UIColor.clear
                        generallbl.textColor = UIColor(red: 23.0/255.0, green: 22.0/255.0, blue: 22.0/255.0, alpha: 1.0)
                        generallbl.text = String(format: "%@", generalInfoArray[j-1] as! CVarArg)
                        generalview.addSubview(generallbl)
                        
                        if j == 3 || j == 4
                        {
                            let lbl = UILabel()
                            lbl.frame = CGRect(x: CGFloat(generallbl.frame.maxX+5.0), y: CGFloat(0.0), width: CGFloat(screenWidth-generallbl.frame.maxX-20.0), height: CGFloat(50.0))
                            lbl.font = UIFont(name: LatoRegular, size: CGFloat(15.0))
                            lbl.backgroundColor = UIColor.clear
                            lbl.textColor = UIColor(red: 0.78, green: 0.78, blue: 0.80, alpha: 0.9)
                            lbl.text = String(format: "%@", generalInfoArray[j-1] as! CVarArg)
                            lbl.tag = j
                            lbl.isUserInteractionEnabled = true
                            generalview.addSubview(lbl)
                            
                            let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.pickerAction))
                            tapGesture.numberOfTapsRequired = 1
                            lbl.addGestureRecognizer(tapGesture)
                            
                            if j == 3
                            {
                                let gender = String(format: "%@", generalInfoDictionary.value(forKey: "gender") as! CVarArg)
                                if gender == ""
                                {
                                    lbl.text = gender
                                }
                                else
                                {
                                    for item in genderArray
                                    {
                                        let obj = item as! NSDictionary
                                        let idstring = String(format: "%@", obj.value(forKey: "id") as! CVarArg)
                                        if idstring==gender
                                        {
                                            let name = String(format: "%@", obj.value(forKey: "name") as! CVarArg)
                                            lbl.text = name
                                        }
                                    }
                                }
                            }
                            else if j == 4
                            {
                                let brithday = String(format: "%@", generalInfoDictionary.value(forKey: "dob") as! CVarArg)
                                lbl.text = String(format: "%@", commonmethodClass.convertDate(date: brithday))
                            }
                            
                            if (lbl.text?.characters.count)! > 0
                            {
                                lbl.textColor = UIColor(red: 123.0/255.0, green: 123.0/255.0, blue: 123.0/255.0, alpha: 1.0)
                            }
                        }
                        else
                        {
                            let generaltxtfield = UITextField()
                            generaltxtfield.frame = CGRect(x: CGFloat(generallbl.frame.maxX+5.0), y: CGFloat(0.0), width: CGFloat(screenWidth-generallbl.frame.maxX-20.0), height: CGFloat(50.0))
                            generaltxtfield.font = UIFont(name: LatoRegular, size: CGFloat(15.0))
                            generaltxtfield.delegate = self
                            generaltxtfield.backgroundColor = UIColor.clear
                            generaltxtfield.textColor = UIColor(red: 123.0/255.0, green: 123.0/255.0, blue: 123.0/255.0, alpha: 1.0)
                            generaltxtfield.placeholder = String(format: "%@", generalInfoArray[j-1] as! CVarArg)
                            generaltxtfield.tag = j
                            generalview.addSubview(generaltxtfield)
                            
                            if j == 1
                            {
                                generaltxtfield.text = String(format: "%@", generalInfoDictionary.value(forKey: "firstName") as! CVarArg)
                            }
                            else if j == 2
                            {
                                generaltxtfield.text = String(format: "%@", generalInfoDictionary.value(forKey: "lastName") as! CVarArg)
                            }
                            else if j == 5
                            {
                                generaltxtfield.text = String(format: "%@", generalInfoDictionary.value(forKey: "location") as! CVarArg)
                            }
                        }
                        
                        if j != 5
                        {
                            let lineview = UIView()
                            lineview.backgroundColor = lightgrayColor
                            lineview.frame = CGRect(x: CGFloat(15.0), y: CGFloat(49.0), width: CGFloat(screenWidth-30.0), height: CGFloat(1.0))
                            generalview.addSubview(lineview)
                        }
                    }
                    
                    generalyPos = generalyPos + 50.0
                }
                
                view.frame = CGRect(x: CGFloat(0.0), y: CGFloat(190.0), width: CGFloat(screenWidth), height: CGFloat(300.0))
            }
            else if i == 2
            {
                var workyPos = CGFloat()
                workyPos = 0.0
                for j in 0 ..< 3
                {
                    let workview = UIView()
                    workview.frame = CGRect(x: CGFloat(0.0), y: CGFloat(workyPos), width: CGFloat(screenWidth), height: CGFloat(50.0))
                    workview.tag = j
                    view.addSubview(workview)
                    
                    if j == 0
                    {
                        workview.backgroundColor = UIColor(red: 245.0/255.0, green: 245.0/255.0, blue: 245.0/255.0, alpha: 1.0)
                        
                        let infolbl = UILabel()
                        infolbl.frame = CGRect(x: CGFloat(15.0), y: CGFloat(0.0), width: CGFloat(screenWidth-95.0), height: CGFloat(50.0))
                        infolbl.font = UIFont(name: LatoBold, size: CGFloat(15.0))
                        infolbl.backgroundColor = UIColor.clear
                        infolbl.textColor = UIColor(red: 47.0/255.0, green: 47.0/255.0, blue: 47.0/255.0, alpha: 1.0)
                        infolbl.text = "WORK INFO"
                        workview.addSubview(infolbl)
                        
                        let savebtn = UIButton()
                        savebtn.frame = CGRect(x: CGFloat(screenWidth-75.0), y: CGFloat(0.0), width: CGFloat(60.0), height: CGFloat(50.0))
                        savebtn.backgroundColor = UIColor.clear
                        savebtn.addTarget(self, action: #selector(self.saveaction(sender:)), for: .touchUpInside)
                        savebtn.tag = i
                        savebtn.setTitle("SAVE", for: .normal)
                        savebtn.setTitleColor(UIColor.lightGray, for: .normal)
                        savebtn.titleLabel?.font = UIFont(name: LatoBold, size: CGFloat(15.0))
                        savebtn.contentHorizontalAlignment = .right
                        workview.addSubview(savebtn)
                        
                        let lineview = UIView()
                        lineview.backgroundColor = lightgrayColor
                        lineview.frame = CGRect(x: CGFloat(0.0), y: CGFloat(49.0), width: CGFloat(screenWidth), height: CGFloat(1.0))
                        workview.addSubview(lineview)
                    }
                    else
                    {
                        workview.backgroundColor = UIColor.white
                        
                        let worklbl = UILabel()
                        worklbl.frame = CGRect(x: CGFloat(15.0), y: CGFloat(0.0), width: CGFloat(screenWidth-190), height: CGFloat(49.0))
                        worklbl.font = UIFont(name: LatoRegular, size: CGFloat(15.0))
                        worklbl.backgroundColor = UIColor.clear
                        worklbl.textColor = UIColor(red: 23.0/255.0, green: 22.0/255.0, blue: 22.0/255.0, alpha: 1.0)
                        worklbl.text = String(format: "%@", workInfoArray[j-1] as! CVarArg)
                        workview.addSubview(worklbl)
                        
                        if j == 1
                        {
                            let worktxtfield = UITextField()
                            worktxtfield.frame = CGRect(x: CGFloat(worklbl.frame.maxX+5.0), y: CGFloat(0.0), width: CGFloat(screenWidth-worklbl.frame.maxX-20.0), height: CGFloat(50.0))
                            worktxtfield.font = UIFont(name: LatoRegular, size: CGFloat(15.0))
                            worktxtfield.delegate = self
                            worktxtfield.backgroundColor = UIColor.clear
                            worktxtfield.textColor = UIColor(red: 123.0/255.0, green: 123.0/255.0, blue: 123.0/255.0, alpha: 1.0)
                            worktxtfield.placeholder = String(format: "%@", workInfoArray[j-1] as! CVarArg)
                            worktxtfield.tag = j
                            worktxtfield.text = String(format: "%@", workInfoDictionary.value(forKey: "occupation") as! CVarArg)
                            workview.addSubview(worktxtfield)
                        }
                        else
                        {
                            var text = String(format: "%@", workInfoDictionary.value(forKey: "skills") as! CVarArg)
                            text = String(text.characters.filter { !" \n\t\r()".characters.contains($0) })
                            let array = (text.components(separatedBy: ",")) as NSArray
                            //                        print("array =>\(array)")
                            
                            skillsfield.frame = CGRect(x: CGFloat(worklbl.frame.maxX-5.0), y: CGFloat(0.0), width: CGFloat(screenWidth-worklbl.frame.maxX-10.0), height: CGFloat(50.0))
                            skillsfield.delegate = self
                            if text == ""
                            {
                                skillsfield.placeholder = String(format: "%@", workInfoArray[j-1] as! CVarArg)
                            }
                            else
                            {
                                skillsfield.placeholder = ""
                            }
                            skillsfield.backgroundColor = UIColor.clear
                            workview.addSubview(skillsfield)
                            
                            for item in array
                            {
                                let obj = item as! String
                                skillsfield.textField.text = obj
                                skillsfield.completeCurrentInputText()
                            }
                        }
                        
                        if j != 2
                        {
                            let lineview = UIView()
                            lineview.backgroundColor = lightgrayColor
                            lineview.frame = CGRect(x: CGFloat(15.0), y: CGFloat(49.0), width: CGFloat(screenWidth-30.0), height: CGFloat(1.0))
                            workview.addSubview(lineview)
                        }
                    }
                    
                    workyPos = workyPos + 50.0
                }
                
                view.frame = CGRect(x: CGFloat(0.0), y: CGFloat(490.0), width: CGFloat(screenWidth), height: CGFloat(150.0))
            }
            else if i == 3
            {
                var contactyPos = CGFloat()
                var addressheight = CGFloat()
                contactyPos = 0.0
                addressheight = 0.0
                for j in 0 ..< 4
                {
                    let contactview = UIView()
                    contactview.tag = j
                    view.addSubview(contactview)
                    
                    if j == 0
                    {
                        contactview.backgroundColor = UIColor(red: 245.0/255.0, green: 245.0/255.0, blue: 245.0/255.0, alpha: 1.0)
                        
                        let infolbl = UILabel()
                        infolbl.frame = CGRect(x: CGFloat(15.0), y: CGFloat(0.0), width: CGFloat(screenWidth-95.0), height: CGFloat(50.0))
                        infolbl.font = UIFont(name: LatoBold, size: CGFloat(15.0))
                        infolbl.backgroundColor = UIColor.clear
                        infolbl.textColor = UIColor(red: 47.0/255.0, green: 47.0/255.0, blue: 47.0/255.0, alpha: 1.0)
                        infolbl.text = "CONTACT INFO"
                        contactview.addSubview(infolbl)
                        
                        let savebtn = UIButton()
                        savebtn.frame = CGRect(x: CGFloat(screenWidth-75.0), y: CGFloat(0.0), width: CGFloat(60.0), height: CGFloat(50.0))
                        savebtn.backgroundColor = UIColor.clear
                        savebtn.addTarget(self, action: #selector(self.saveaction(sender:)), for: .touchUpInside)
                        savebtn.tag = i
                        savebtn.setTitle("SAVE", for: .normal)
                        savebtn.setTitleColor(UIColor.lightGray, for: .normal)
                        savebtn.titleLabel?.font = UIFont(name: LatoBold, size: CGFloat(15.0))
                        savebtn.contentHorizontalAlignment = .right
                        contactview.addSubview(savebtn)
                        
                        let lineview = UIView()
                        lineview.backgroundColor = lightgrayColor
                        lineview.frame = CGRect(x: CGFloat(0.0), y: CGFloat(49.0), width: CGFloat(screenWidth), height: CGFloat(1.0))
                        contactview.addSubview(lineview)
                    }
                    else
                    {
                        contactview.backgroundColor = UIColor.white
                        
                        let contactlbl = UILabel()
                        contactlbl.frame = CGRect(x: CGFloat(15.0), y: CGFloat(0.0), width: CGFloat(screenWidth-190), height: CGFloat(49.0))
                        contactlbl.font = UIFont(name: LatoRegular, size: CGFloat(15.0))
                        contactlbl.backgroundColor = UIColor.clear
                        contactlbl.textColor = UIColor(red: 23.0/255.0, green: 22.0/255.0, blue: 22.0/255.0, alpha: 1.0)
                        contactlbl.text = String(format: "%@", contactInfoArray[j-1] as! CVarArg)
                        contactview.addSubview(contactlbl)
                        
                        if j == 1
                        {
                            let contactfield = UITextField()
                            contactfield.frame = CGRect(x: CGFloat(contactlbl.frame.maxX+5.0), y: CGFloat(0.0), width: CGFloat(screenWidth-contactlbl.frame.maxX-20.0), height: CGFloat(50.0))
                            contactfield.font = UIFont(name: LatoRegular, size: CGFloat(15.0))
                            contactfield.delegate = self
                            contactfield.backgroundColor = UIColor.clear
                            contactfield.textColor = UIColor(red: 123.0/255.0, green: 123.0/255.0, blue: 123.0/255.0, alpha: 1.0)
                            contactfield.placeholder = String(format: "%@", contactInfoArray[j-1] as! CVarArg)
                            contactfield.tag = j
                            contactfield.text = String(format: "%@", contactInfoDictionary.value(forKey: "phone") as! CVarArg)
                            contactview.addSubview(contactfield)
                        }
                        else if j == 2
                        {
                            let emaillbl = UILabel()
                            emaillbl.frame = CGRect(x: CGFloat(contactlbl.frame.maxX+5.0), y: CGFloat(0.0), width: CGFloat(screenWidth-contactlbl.frame.maxX-20.0), height: CGFloat(50.0))
                            emaillbl.font = UIFont(name: LatoRegular, size: CGFloat(15.0))
                            emaillbl.backgroundColor = UIColor.clear
                            emaillbl.textColor = UIColor(red: 123.0/255.0, green: 123.0/255.0, blue: 123.0/255.0, alpha: 1.0)
                            emaillbl.text = String(format: "%@", commonmethodClass.retrieveemail())
                            contactview.addSubview(emaillbl)
                        }
                        else if j == 3
                        {
                            addresstxtView = PlaceholderTextView()
                            addresstxtView.text = String(format: "%@", contactInfoDictionary.value(forKey: "address") as! CVarArg)
                            addresstxtView.font = UIFont(name: LatoRegular, size: CGFloat(15.0))
                            var txtheight = commonmethodClass.dynamicHeight(width: screenWidth-160, font: addresstxtView.font!, string: addresstxtView.text)
                            txtheight = txtheight + 10.0
                            txtheight = ceil(txtheight)
                            if(txtheight<42.0)
                            {
                                txtheight = 42.0
                            }
                            addressheight = txtheight - 42.0
                            
                            addresstxtView.frame = CGRect(x: CGFloat(contactlbl.frame.maxX-2.0), y: CGFloat(8.0), width: CGFloat(screenWidth-contactlbl.frame.maxX-20.0), height: CGFloat(txtheight))
                            addresstxtView.backgroundColor = UIColor.clear
                            addresstxtView.textColor = UIColor(red: 123.0/255.0, green: 123.0/255.0, blue: 123.0/255.0, alpha: 1.0)
                            addresstxtView.delegate = self
                            addresstxtView.placeholder = String(format: "%@", contactInfoArray[j-1] as! CVarArg)
                            addresstxtView.placeholderColor = UIColor(red: 0.78, green: 0.78, blue: 0.80, alpha: 0.9)
                            contactview.addSubview(addresstxtView)
                        }
                        
                        if j != 3
                        {
                            let lineview = UIView()
                            lineview.backgroundColor = lightgrayColor
                            lineview.frame = CGRect(x: CGFloat(15.0), y: CGFloat(49.0), width: CGFloat(screenWidth-30.0), height: CGFloat(1.0))
                            contactview.addSubview(lineview)
                        }
                    }
                    
                    contactview.frame = CGRect(x: CGFloat(0.0), y: CGFloat(contactyPos), width: CGFloat(screenWidth), height: CGFloat(50.0+addressheight))
                    
                    contactyPos = contactyPos + 50.0
                }
                
                view.frame = CGRect(x: CGFloat(0.0), y: CGFloat(640.0), width: CGFloat(screenWidth), height: CGFloat(200.0+addressheight))
            }
            
            yPos = view.frame.maxY
        }
        scrollView.contentSize = CGSize(width: CGFloat(screenWidth), height: yPos+20.0)
        
        scrollheight = scrollView.contentSize.height
    }

    func getProfileInfo()
    {
        self.connectionClass.getUserInfo()
    }
    
    func saveaction(sender: UIButton!)
    {
        print("sender =>\(sender.tag)")
        if sender.currentTitleColor == greenColor
        {
            if(sender.tag==0)
            {
                self.connectionClass.getUploadProfilePic(imageData: self.imgData as Data)
            }
            else if(sender.tag==1)
            {
                print("date =>\(datePicker.date)")
                
                var firstname = String()
                var lastname = String()
                var gender = String()
                var location = String()

                for view : UIView in scrollView.subviews
                {
                    if view.tag == 1
                    {
                        for view1 : UIView in view.subviews
                        {
                            if view1.tag > 0
                            {
                                for view2 : UIView in view1.subviews
                                {
                                    if let lbl = view2 as? UILabel
                                    {
                                        if lbl.tag == 3
                                        {
                                            gender = String(format: "%@", lbl.text!)
                                        }
                                    }
                                    if let txtfield = view2 as? UITextField
                                    {
                                        if txtfield.tag == 1
                                        {
                                            firstname = String(format: "%@", txtfield.text!)
                                        }
                                        if txtfield.tag == 2
                                        {
                                            lastname = String(format: "%@", txtfield.text!)
                                        }
                                        if txtfield.tag == 5
                                        {
                                            location = String(format: "%@", txtfield.text!)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                let dateString = dateFormatter.string(from: datePicker.date)
                
                let predicate = NSPredicate(format: "name like %@",gender);
                let filteredArray = genderArray.filter { predicate.evaluate(with: $0) };
                if filteredArray.count > 0
                {
                    let genderdictionary = filteredArray[0] as! NSDictionary
                    let idstring = String(format: "%@", genderdictionary.value(forKey: "id") as! CVarArg)
                    
                    self.connectionClass.UpdateGeneralInfo(firstname: firstname, lastname: lastname, gender: idstring, dob: dateString, location: location, myself: "test")
                }
            }
            else if(sender.tag==2)
            {
                var occupation = String()
                
                for view : UIView in scrollView.subviews
                {
                    if view.tag == 2
                    {
                        for view1 : UIView in view.subviews
                        {
                            if view1.tag > 0
                            {
                                for view2 : UIView in view1.subviews
                                {
                                    if let txtfield = view2 as? UITextField
                                    {
                                        if txtfield.tag == 1
                                        {
                                            occupation = String(format: "%@", txtfield.text!)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }

                let skillsstring = String(format: "%@", skillsfield.texts as CVarArg)
                self.connectionClass.UpdateWorkInfo(occupation: occupation, skills: skillsstring)
            }
            else if(sender.tag==3)
            {
                var phone = String()
                
                for view : UIView in scrollView.subviews
                {
                    if view.tag == 3
                    {
                        for view1 : UIView in view.subviews
                        {
                            if view1.tag > 0
                            {
                                for view2 : UIView in view1.subviews
                                {
                                    if let txtfield = view2 as? UITextField
                                    {
                                        if txtfield.tag == 1
                                        {
                                            phone = String(format: "%@", txtfield.text!)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                self.connectionClass.UpdateContactInfo(phone: phone, address: addresstxtView.text!)
            }
        }
    }
    
    func expandaction(sender: UIButton!)
    {
        if sender.currentTitle == "IMAGE INFO"
        {
            if(!imageBool)
            {
//                if profileString == ""
//                {
//                    imageBool = false
//                    imagecount = 0
//                }
//                else
//                {
                    imageBool = true
                    imagecount = 1
                //}
            }
            else
            {
                imageBool = false
                imagecount = 0
            }
        }
        else if sender.currentTitle == "GENERAL INFO"
        {
            if(!generalInfoBool)
            {
                if generalInfoDictionary.count == 0
                {
                    generalInfoBool = false
                    generalInfocount = 0
                }
                else
                {
                    generalInfoBool = true
                    generalInfocount = 5
                }
            }
            else
            {
                generalInfoBool = false
                generalInfocount = 0
            }
        }
        else if sender.currentTitle == "WORK INFO"
        {
            if(!workInfoBool)
            {
                if workInfoDictionary.count == 0
                {
                    workInfoBool = false
                    workInfocount = 0
                }
                else
                {
                    workInfoBool = true
                    workInfocount = 2
                }
            }
            else
            {
                workInfoBool = false
                workInfocount = 0
            }
        }
        else if sender.currentTitle == "CONTACT INFO"
        {
            if(!contactInfoBool)
            {
                if contactInfoDictionary.count == 0
                {
                    contactInfoBool = false
                    contactInfocount = 0
                }
                else
                {
                    contactInfoBool = true
                    contactInfocount = 3
                }
            }
            else
            {
                contactInfoBool = false
                contactInfocount = 0
            }
        }
        
        UIView.transition(with: tblprofile, duration: 0.3, options: .transitionCrossDissolve, animations: {self.tblprofile.reloadData()}, completion: nil)
    }
    
    func pickerAction(_ sender: UITapGestureRecognizer)
    {
        self.view.endEditing(true)
        
        let tappedView = sender.view as! UILabel
        print("tappedView =>\(tappedView.tag)")
        if tappedView.tag == 3
        {
            if genderArray.count>0
            {
                pickView.isHidden = false
                datepickView.isHidden = true
                pickerView.reloadAllComponents()
            }
        }
        if tappedView.tag == 4
        {
            pickView.isHidden = true
            datepickView.isHidden = false
        }
    }
    
    func profileaction()
    {
        alertClass.profileAttachment()
    }
    
    func camera()
    {
        if UIImagePickerController.isSourceTypeAvailable(
            UIImagePickerControllerSourceType.camera)
        {
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .camera
            imagePicker.delegate = self
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func library()
    {
        if UIImagePickerController.isSourceTypeAvailable(
            UIImagePickerControllerSourceType.savedPhotosAlbum)
        {
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .photoLibrary
            imagePicker.delegate = self
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    @IBAction func datePickerValueChanged(sender: UIDatePicker)
    {
        print("date =>\(sender.date)")
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString = dateFormatter.string(from: sender.date)
        generaleditBool = true
        for view : UIView in scrollView.subviews
        {
            if view.tag == 1
            {
                for view1 : UIView in view.subviews
                {
                    if view1.tag == 4
                    {
                        for view2 : UIView in view1.subviews
                        {
                            if let lbl = view2 as? UILabel
                            {
                                if lbl.tag == 4
                                {
                                    lbl.text = String(format: "%@", commonmethodClass.convertDateFormatterOnly(date: dateString))
                                }
                            }
                        }
                    }
                }
            }
        }
        self.updatebtncolor(index: 1)
    }
    
    @IBAction func doneAction(sender : AnyObject)
    {
        pickView.isHidden = true
    }
    
    @IBAction func datepickerdoneAction(sender : AnyObject)
    {
        datepickView.isHidden = true
    }
    
    func updatebtncolor(index : NSInteger)
    {
        for view : UIView in scrollView.subviews
        {
            if view.tag == index
            {
                for view1 : UIView in view.subviews
                {
                    if view1.tag == 0
                    {
                        for view2 : UIView in view1.subviews
                        {
                            if let btn = view2 as? UIButton
                            {
                                btn.setTitleColor(greenColor, for: .normal)
                            }
                        }
                    }
                }
            }
        }
    }
    
    func resetbtncolor(index : NSInteger)
    {
        for view : UIView in scrollView.subviews
        {
            if view.tag == index
            {
                for view1 : UIView in view.subviews
                {
                    if view1.tag == 0
                    {
                        for view2 : UIView in view1.subviews
                        {
                            if let btn = view2 as? UIButton
                            {
                                btn.setTitleColor(UIColor.lightGray, for: .normal)
                            }
                        }
                    }
                }
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
            if let InfoDict = getreponse.value(forKey: "info") as? NSDictionary
            {
                if let profilestring = InfoDict.value(forKey: "pic") as? String
                {
                    pickimage = nil
                    imgData = nil
                    profileString = profilestring
                    commonmethodClass.saveprofileimg(profileImg: profilestring as NSString)
                    
                    for view : UIView in scrollView.subviews
                    {
                        if view.tag == 0
                        {
                            for view1 : UIView in view.subviews
                            {
                                if let imageView = view1 as? AsyncImageView
                                {
                                    if(pickimage != nil)
                                    {
                                        imageView.image = pickimage
                                    }
                                    else
                                    {
                                        if profileString != ""
                                        {
                                            let imagestring = String(format: "%@%@", kfilePath,profileString)
                                            let fileUrl = NSURL(string: imagestring)
                                            imageView.imageURL = fileUrl as URL?
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                else
                {
                    if((InfoDict.value(forKey: "address")) != nil)
                    {
                        contactInfoDictionary = InfoDict
                        contactInfoeditBool = false
                        self.resetbtncolor(index: 3)
                    }
                    else if((InfoDict.value(forKey: "occupation")) != nil)
                    {
                        workInfoDictionary = InfoDict
                        workinfoeditBool = false
                        self.resetbtncolor(index: 2)
                    }
                    else
                    {
                        generalInfoDictionary = InfoDict
                        generaleditBool = false
                        self.resetbtncolor(index: 1)
                    }
                }
            }
            else
            {
                profileDictionary = getreponse
                print("profileDictionary => \(profileDictionary)")
                
                if let profilereponse = profileDictionary.value(forKey: "profilePic") as? NSDictionary
                {
                    if let profilestring = profilereponse.value(forKey: "pic") as? String
                    {
                        profileString = profilestring
                    }
                }
                if let generalreponse = profileDictionary.value(forKey: "generalInfo") as? NSDictionary
                {
                    generalInfoDictionary = generalreponse
                }
                if let contactreponse = profileDictionary.value(forKey: "contactInfo") as? NSDictionary
                {
                    contactInfoDictionary = contactreponse
                }
                if let workreponse = profileDictionary.value(forKey: "workInfo") as? NSDictionary
                {
                    workInfoDictionary = workreponse
                }
                if let genderreponse = profileDictionary.value(forKey: "genderInfo") as? NSArray
                {
                    genderArray = genderreponse
                }
                
                self.loadProfile()
            }
        }
    }
    
    // MARK: - UITextView Delegate

    func textViewDidBeginEditing(_ textView: UITextView)
    {
        pickView.isHidden = true
        datepickView.isHidden = true
    }
    
    func textViewDidChange(_ textView: UITextView)
    {
        self.updatebtncolor(index: 3)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool
    {
        if (text == "\n")
        {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    // MARK: - UITextField Delegate
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        pickView.isHidden = true
        datepickView.isHidden = true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        self.updatebtncolor(index: (textField.superview?.superview?.tag)!)
        return true
    }
    
    // MARK: - UIImagePickerControllerDelegate Methods
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        dismiss(animated: true, completion: nil)
        
        if let pickImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
            print("pickImage => \(pickImage)")
            
            pickimage = pickImage
            
            let assetUrl = info[UIImagePickerControllerReferenceURL] as? NSURL
            print("assetUrl => \(String(describing: assetUrl))")
            if (assetUrl != nil)
            {
                let fetchResult = PHAsset.fetchAssets(withALAssetURLs: [assetUrl! as URL], options: nil)
                if let phAsset = fetchResult.firstObject! as? PHAsset
                {
                    PHImageManager.default().requestImageData(for: phAsset, options: nil) {
                        (imageData, dataURI, orientation, info) -> Void in
                        
                        print("imageData => \(String(describing: imageData?.count))")
                        
                        self.imgData = imageData as NSData!
                        
                        self.connectionClass.getUploadProfilePic(imageData: self.imgData as Data)
                    }
                }
            }
            else
            {
                let imageData = UIImageJPEGRepresentation(pickImage, 1.0)
                print("imageData => \(String(describing: imageData?.count))")
                
                self.imgData = imageData as NSData!
                
                self.connectionClass.getUploadProfilePic(imageData: self.imgData as Data)
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: UITableView Delegate and Datasource methods
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if(section==0)
        {
            return imagecount
        }
        else if(section==1)
        {
            return generalInfocount
        }
        else if(section==2)
        {
            return workInfocount
        }
        else if(section==3)
        {
            return contactInfocount
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if(indexPath.section==0)
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "profileCell", for: indexPath)
            
            let profileImg = cell.contentView.viewWithTag(1) as? AsyncImageView
            profileImg?.layer.borderWidth = 1.0
            profileImg?.layer.borderColor = lightgrayColor.cgColor
            
            let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ProfileViewController.profileaction))
            tapGesture.numberOfTapsRequired = 1
            profileImg?.addGestureRecognizer(tapGesture)
            
            if(pickimage != nil)
            {
                profileImg?.image = pickimage
            }
            else
            {
                if profileString != ""
                {
                    let imagestring = String(format: "%@%@", kfilePath,profileString)
                    let fileUrl = NSURL(string: imagestring)
                    profileImg?.imageURL = fileUrl as URL?
                }
            }
            
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileInfoCell", for: indexPath) as! ProfileInfoTableViewCell
            
            let titlelbl = cell.titlelbl
            let txtfield = cell.txtfield
            let addtxtfield = cell.textfield
            addtxtfield?.isHidden = true
            txtfield?.isHidden = false

            addtxtfield?.delegate = self
            txtfield?.delegate = self
            txtfield?.tag = indexPath.section

            if(indexPath.section==1)
            {
                txtfield?.isUserInteractionEnabled = true

                titlelbl?.text = generalInfoArray[indexPath.row] as? String
                
                txtfield?.placeholder = generalInfoArray[indexPath.row] as? String
                
                if(indexPath.row==0)
                {
                    if firstnametxtfield.text?.characters.count == 0
                    {
                        txtfield?.text = String(format: "%@", generalInfoDictionary.value(forKey: "firstName") as! CVarArg)
                    }
                    else
                    {
                        txtfield?.text = String(format: "%@", firstnametxtfield.text!)
                    }
                    
                    firstnametxtfield = txtfield!
                }
                else if(indexPath.row==1)
                {
                    if lastnametxtfield.text?.characters.count == 0
                    {
                        txtfield?.text = String(format: "%@", generalInfoDictionary.value(forKey: "lastName") as! CVarArg)
                    }
                    else
                    {
                        txtfield?.text = String(format: "%@", lastnametxtfield.text!)
                    }
                    
                    lastnametxtfield = txtfield!
                }
                else if(indexPath.row==2)
                {
                    if gendertxtfield.text?.characters.count == 0
                    {
                        let gender = String(format: "%@", generalInfoDictionary.value(forKey: "gender") as! CVarArg)
                        if gender == ""
                        {
                            txtfield?.text = gender
                        }
                        else
                        {
                            for item in genderArray
                            {
                                let obj = item as! NSDictionary
                                let idstring = String(format: "%@", obj.value(forKey: "id") as! CVarArg)
                                if idstring==gender
                                {
                                    let name = String(format: "%@", obj.value(forKey: "name") as! CVarArg)
                                    txtfield?.text = name
                                }
                            }
                        }
                    }
                    else
                    {
                        txtfield?.text = String(format: "%@", gendertxtfield.text!)
                    }
                    
                    gendertxtfield = txtfield!
                }
                else if(indexPath.row==3)
                {
                    if brithdaytxtfield.text?.characters.count == 0
                    {
                        let brithday = String(format: "%@", generalInfoDictionary.value(forKey: "dob") as! CVarArg)
                        txtfield?.text = String(format: "%@", commonmethodClass.convertDate(date: brithday))
                    }
                    else
                    {
                        txtfield?.text = String(format: "%@", brithdaytxtfield.text!)
                    }
                    
                    brithdaytxtfield = txtfield!
                }
                else if(indexPath.row==4)
                {
                    if locationtxtfield.text?.characters.count == 0
                    {
                        txtfield?.text = String(format: "%@", generalInfoDictionary.value(forKey: "location") as! CVarArg)
                    }
                    else
                    {
                        txtfield?.text = String(format: "%@", locationtxtfield.text!)
                    }
                    
                    locationtxtfield = txtfield!
                }
            }
            else if(indexPath.section==2)
            {
                txtfield?.isUserInteractionEnabled = true

                titlelbl?.text = workInfoArray[indexPath.row] as? String
                
                txtfield?.placeholder = workInfoArray[indexPath.row] as? String
                
                if(indexPath.row==0)
                {
                    if designationtxtfield.text?.characters.count == 0
                    {
                        txtfield?.text = String(format: "%@", workInfoDictionary.value(forKey: "occupation") as! CVarArg)
                    }
                    else
                    {
                        txtfield?.text = String(format: "%@", designationtxtfield.text!)
                    }
                    
                    designationtxtfield = txtfield!
                }
                else if(indexPath.row==1)
                {
                    txtfield?.isHidden = true
                    
//                    print("TEXT*** =>\(skillsfield.texts)")
                    
                    if skillsfield.texts.count == 0
                    {
                        var text = String(format: "%@", workInfoDictionary.value(forKey: "skills") as! CVarArg)
                        text = String(text.characters.filter { !" \n\t\r()".characters.contains($0) })
                        let array = (text.components(separatedBy: ",")) as NSArray
//                        print("array =>\(array)")
                        
                        skillsfield.frame = CGRect(x: (txtfield?.frame.origin.x)!-10.0, y: (txtfield?.frame.origin.y)!, width: (txtfield?.frame.size.width)!+10.0, height: (txtfield?.frame.size.height)!)
                        skillsfield.delegate = self
                        if text == ""
                        {
                            skillsfield.placeholder = txtfield?.placeholder
                        }
                        else
                        {
                            skillsfield.placeholder = ""
                        }
                        skillsfield.backgroundColor = UIColor.clear
                        cell.contentView.addSubview(skillsfield)
                        
                        for item in array
                        {
                            let obj = item as! String
                            skillsfield.textField.text = obj
                            skillsfield.completeCurrentInputText()
                        }
                    }
                }
            }
            else if(indexPath.section==3)
            {
                titlelbl?.text = contactInfoArray[indexPath.row] as? String
                
                txtfield?.placeholder = contactInfoArray[indexPath.row] as? String
                
                if(indexPath.row==0)
                {
                    if phonetxtfield.text?.characters.count == 0
                    {
                        txtfield?.text = String(format: "%@", contactInfoDictionary.value(forKey: "phone") as! CVarArg)
                    }
                    else
                    {
                        txtfield?.text = String(format: "%@", phonetxtfield.text!)
                    }
                    
                    txtfield?.isUserInteractionEnabled = true
                    phonetxtfield = txtfield!
                }
                else if(indexPath.row==1)
                {
                    txtfield?.text = String(format: "%@", commonmethodClass.retrieveemail())
                    txtfield?.isUserInteractionEnabled = false
                }
                else if(indexPath.row==2)
                {
//                    addtxtfield?.placeholder = (contactInfoArray[indexPath.row] as? String)!
//                    if addresstxtfield.text?.characters.count == 0
//                    {
//                        addtxtfield?.text = String(format: "%@", contactInfoDictionary.value(forKey: "address") as! CVarArg)
//                    }
//                    else
//                    {
//                        addtxtfield?.text = String(format: "%@", addresstxtfield.text!)
//                    }
//                    addresstxtfield = addtxtfield!
//                    txtfield?.isHidden = true
//                    addtxtfield?.isHidden = false
                }
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if(indexPath.section==0)
        {
            return 190.0
        }
        else
        {
            if(indexPath.section==3)
            {
                if(indexPath.row==2)
                {
                    var txtheight = commonmethodClass.dynamicHeight(width: screenWidth-160, font: UIFont (name: LatoRegular, size: 15)!, string: String(format: "%@", contactInfoDictionary.value(forKey: "address") as! CVarArg))
                    txtheight = txtheight + 10.0
                    txtheight = ceil(txtheight)
                    if(txtheight<50.0)
                    {
                        return 50.0
                    }
                    else
                    {
                        return txtheight
                    }
                }
                else
                {
                    return 50.0
                }
            }
            else
            {
                return 50.0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        if(section==0)
        {
            return 0.0
        }
        else
        {
            return 50.0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let  headerCell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell")
        let titlelbl = headerCell?.contentView.viewWithTag(1) as? UILabel
        let savebtn = headerCell?.contentView.viewWithTag(2) as? UIButton
        let btn = headerCell?.contentView.viewWithTag(3) as? UIButton
        btn?.addTarget(self, action: #selector(self.expandaction(sender:)), for: .touchUpInside)
        savebtn?.addTarget(self, action: #selector(self.saveaction(sender:)), for: .touchUpInside)
        savebtn?.tag = section
        
        switch (section)
        {
            case 0:
                titlelbl?.text = "IMAGE INFO";
//                if(pickimage != nil)
//                {
//                    savebtn?.setTitleColor(greenColor, for: .normal)
//                }
//                else
//                {
//                    savebtn?.setTitleColor(UIColor.lightGray, for: .normal)
//                }
                break
            case 1:
                titlelbl?.text = "GENERAL INFO";
                if(generaleditBool==true)
                {
                    savebtn?.setTitleColor(greenColor, for: .normal)
                }
                else
                {
                    savebtn?.setTitleColor(UIColor.lightGray, for: .normal)
                }
                break
            case 2:
                titlelbl?.text = "WORK INFO";
                if(workinfoeditBool==true)
                {
                    savebtn?.setTitleColor(greenColor, for: .normal)
                }
                else
                {
                    savebtn?.setTitleColor(UIColor.lightGray, for: .normal)
                }
                break
            case 3:
                titlelbl?.text = "CONTACT INFO";
                if(contactInfoeditBool==true)
                {
                    savebtn?.setTitleColor(greenColor, for: .normal)
                }
                else
                {
                    savebtn?.setTitleColor(UIColor.lightGray, for: .normal)
                }
                break
            default:
            break
        }
        
        btn?.setTitle(titlelbl?.text, for: .normal)
        
        return headerCell
    }
    
    // MARK: - PickerView Delegate
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return genderArray.count;
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        let genderdictionary = genderArray[row] as! NSDictionary
        return genderdictionary["name"] as? String
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        let genderdictionary = genderArray[row] as! NSDictionary
        print("genderdictionary =>\(genderdictionary)")
        generaleditBool = true
        for view : UIView in scrollView.subviews
        {
            if view.tag == 1
            {
                for view1 : UIView in view.subviews
                {
                    if view1.tag == 3
                    {
                        for view2 : UIView in view1.subviews
                        {
                            if let lbl = view2 as? UILabel
                            {
                                if lbl.tag == 3
                                {
                                    lbl.text = String(format: "%@", genderdictionary.value(forKey: "name") as! CVarArg)
                                }
                            }
                        }
                    }
                }
            }
        }
        self.updatebtncolor(index: 1)
    }
    
    // MARK: - ICTokenFieldDelegate
    
    func tokenFieldDidBeginEditing(_ tokenField: ICTokenField) {
        print(#function)
    }
    
    func tokenFieldDidEndEditing(_ tokenField: ICTokenField) {
        print(#function)
    }
    
    func tokenFieldWillReturn(_ tokenField: ICTokenField) {
        print(#function)
        self.updatebtncolor(index: 2)
    }
    
    func tokenField(_ tokenField: ICTokenField, didChangeInputText text: String) {
        print("Typing \"\(text)\"")
    }
    
    func tokenField(_ tokenField: ICTokenField, shouldCompleteText text: String) -> Bool {
        print("Should add \"\(text)\"?")
        return text != "42"
    }
    
    func tokenField(_ tokenField: ICTokenField, didCompleteText text: String) {
        print("Added \"\(text)\"")
    }
    
    func tokenField(_ tokenField: ICTokenField, didDeleteText text: String, atIndex index: Int) {
        print("Deleted \"\(text)\"")
    }
    
    func tokenField(_ tokenField: ICTokenField, subsequentDelimiterForCompletedText text: String) -> String {
        return " "
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
