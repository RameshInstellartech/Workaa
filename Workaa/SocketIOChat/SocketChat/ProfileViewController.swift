//
//  ProfileViewController.swift
//  Workaa
//
//  Created by IN1947 on 20/03/17.
//  Copyright © 2017 IN1947. All rights reserved.
//

import UIKit
import Photos

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, ConnectionProtocol, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UITextViewDelegate, TITokenFieldDelegate
{
    @IBOutlet weak var scrollView : UIScrollView!
    @IBOutlet weak var pickerView : UIPickerView!
    @IBOutlet weak var pickView : UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var datepickView : UIView!
    
    var addresstxtView = PlaceholderTextView()
    var tokenFieldView = TITokenFieldView()
    
    var generalInfoArray = NSArray()
    var workInfoArray = NSArray()
    var contactInfoArray = NSArray()
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
    var genderArray = NSArray()
    var scrollheight = CGFloat()
    var keyboardheight = CGFloat()
    var myActivityIndicator = UIActivityIndicatorView()

    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        connectionClass.delegate = self
        
        profileString = ""
        
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
        
        self.getProfileInfo()
        
        NotificationCenter.default.addObserver(self, selector: #selector(ProfileViewController.handleKeyboardWillShowNotification(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ProfileViewController.handleKeyboardWillHideNotification(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
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
                keyboardheight = keyboardFrame.size.height

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
                            
                            tokenFieldView = TITokenFieldView(frame: CGRect(x: CGFloat(worklbl.frame.maxX+5.0), y: CGFloat(5.0), width: CGFloat(screenWidth-worklbl.frame.maxX-20.0), height: CGFloat(50.0)))
                            tokenFieldView.tokenField.delegate = self
                            tokenFieldView.backgroundColor = UIColor.clear
                            tokenFieldView.tokenField.placeholder = String(format: "%@", workInfoArray[j-1] as! CVarArg)
                            workview.addSubview(tokenFieldView)
                            
                            for item in array
                            {
                                let obj = item as! String
                                tokenFieldView.tokenField.addToken(withTitle: obj)
                                tokenFieldView.tokenField.layoutTokens(animated: true)
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
    
    func getframe(_ height: CGFloat)
    {
        var viewheight = CGFloat()
        if height > 50.0
        {
            viewheight = height - 50.0
        }
        else
        {
            viewheight = 0.0
        }
        
        var frame1 = tokenFieldView.superview?.frame
        frame1?.size.height = 50.0+viewheight
        tokenFieldView.superview?.frame = frame1!
        
        var frame2 = tokenFieldView.superview?.superview?.frame
        frame2?.size.height = 150.0+viewheight
        tokenFieldView.superview?.superview?.frame = frame2!
        
        for view : UIView in scrollView.subviews
        {
            if view.tag == 3
            {
                var frame3 = view.frame
                frame3.origin.y = 640.0+viewheight
                view.frame = frame3
                
                scrollView.contentSize = CGSize(width: CGFloat(screenWidth), height: view.frame.maxY+20.0)
                scrollheight = scrollView.contentSize.height

                if keyboardheight > 0.0
                {
                    scrollView.setContentOffset(CGPoint(x: 0.0, y: 490.0), animated: true)
                }
            }
        }
    }
    
    func tokenField(_ tokenField: TITokenField, willRemove token: TIToken) -> Bool
    {
        self.updatebtncolor(index: 2)
        return true
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
    
    func getProfileInfo()
    {
        self.startanimating()
        commonmethodClass.delayWithSeconds(0.0, completion: {
            self.connectionClass.getUserInfo()
        })
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

                let skillsstring = String(format: "%@", tokenFieldView.tokenTitles.componentsJoined(by: ",") as CVarArg)
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
        
        scrollView.setContentOffset(CGPoint(x: 0.0, y: 240.0), animated: true)
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
        self.stopanimating()
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
                    appDelegate.profilePicString = profilestring
                    
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
                        self.resetbtncolor(index: 3)
                    }
                    else if((InfoDict.value(forKey: "occupation")) != nil)
                    {
                        workInfoDictionary = InfoDict
                        self.resetbtncolor(index: 2)
                    }
                    else
                    {
                        generalInfoDictionary = InfoDict
                        appDelegate.locationString = String(format: "%@", InfoDict.value(forKey: "location") as! CVarArg)
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
                        appDelegate.profilePicString = profilestring
                    }
                }
                if let generalreponse = profileDictionary.value(forKey: "generalInfo") as? NSDictionary
                {
                    generalInfoDictionary = generalreponse
                    appDelegate.locationString = String(format: "%@", generalreponse.value(forKey: "location") as! CVarArg)
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
        
        self.stopanimating()
    }
    
    // MARK: - UITextView Delegate

    func textViewDidBeginEditing(_ textView: UITextView)
    {
        pickView.isHidden = true
        datepickView.isHidden = true
        
        let bottomOffset = CGPoint(x: 0.0, y: scrollView.contentSize.height - scrollView.bounds.size.height)
        scrollView.setContentOffset(bottomOffset, animated: true)
    }
    
    func textViewDidChange(_ textView: UITextView)
    {
        self.updatebtncolor(index: 3)
        
        var addressheight = CGFloat()
        addressheight = 0.0
        var txtheight = commonmethodClass.dynamicHeight(width: screenWidth-160, font: textView.font!, string: textView.text)
        txtheight = txtheight + 10.0
        txtheight = ceil(txtheight)
        if(txtheight<42.0)
        {
            txtheight = 42.0
        }
        addressheight = txtheight - 42.0
        
        var frame = self.addresstxtView.frame
        frame.size.height = txtheight
        self.addresstxtView.frame  = frame
        
        var frame1 = textView.superview?.frame
        frame1?.size.height = 50.0+addressheight
        textView.superview?.frame  = frame1!
        
        var frame2 = textView.superview?.superview?.frame
        frame2?.size.height = 200.0+addressheight
        textView.superview?.superview?.frame  = frame2!
        
        var size = scrollView.contentSize
        size.height = (textView.superview?.superview?.frame.maxY)!+20.0+keyboardheight
        scrollView.contentSize = size
        
        let bottomOffset = CGPoint(x: 0.0, y: scrollView.contentSize.height - scrollView.bounds.size.height)
        scrollView.setContentOffset(bottomOffset, animated: true)
        
        scrollheight = scrollView.contentSize.height-keyboardheight
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
        
        let index = (textField.superview?.superview?.tag)!
        if index == 1
        {
            scrollView.setContentOffset(CGPoint(x: 0.0, y: 240.0), animated: true)
        }
        if index == 2
        {
            scrollView.setContentOffset(CGPoint(x: 0.0, y: 490.0), animated: true)
        }
        if index == 3
        {
            scrollView.setContentOffset(CGPoint(x: 0.0, y: 640.0), animated: true)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        if textField != tokenFieldView.tokenField
        {
            textField.resignFirstResponder()
        }
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
