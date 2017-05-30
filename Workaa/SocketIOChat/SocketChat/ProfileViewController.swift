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
    @IBOutlet weak var tblprofile: UITableView!
    @IBOutlet weak var pickerView : UIPickerView!
    @IBOutlet weak var pickView : UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var datepickView : UIView!
    
    private let skillsfield = CustomizedTokenField()

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
    var genderArray = NSArray()
    var gendertxtfield : UITextField!
    var brithdaytxtfield : UITextField!
    var firstnametxtfield : UITextField!
    var lastnametxtfield : UITextField!
    var locationtxtfield : UITextField!
    var addresstxtfield : PlaceholderTextView!
    var phonetxtfield : UITextField!
    var designationtxtfield : UITextField!

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
                tblprofile.contentSize = CGSize(width: screenWidth, height: tblprofile.contentSize.height+keyboardFrame.size.height)
            }
        }
    }
    
    func handleKeyboardWillHideNotification(notification: NSNotification)
    {
        if let userInfo = notification.userInfo
        {
            if let keyboardFrame = (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue
            {
                tblprofile.contentSize = CGSize(width: screenWidth, height: tblprofile.contentSize.height-keyboardFrame.size.height)
            }
        }
    }

    func getProfileInfo()
    {
        self.connectionClass.getUserInfo()
    }
    
    func saveaction(sender: UIButton!)
    {
        print("sender =>\(sender.tag)")
        if(sender.tag==0)
        {
            self.connectionClass.getUploadProfilePic(imageData: self.imgData as Data)
        }
        else if(sender.tag==1)
        {
            print("date =>\(datePicker.date)")
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let dateString = dateFormatter.string(from: datePicker.date)
            
            let predicate = NSPredicate(format: "name like %@",gendertxtfield.text!);
            let filteredArray = genderArray.filter { predicate.evaluate(with: $0) };
            if filteredArray.count > 0
            {
                let genderdictionary = filteredArray[0] as! NSDictionary
                let idstring = String(format: "%@", genderdictionary.value(forKey: "id") as! CVarArg)

                self.connectionClass.UpdateGeneralInfo(firstname: firstnametxtfield.text!, lastname: lastnametxtfield.text!, gender: idstring, dob: dateString, location: locationtxtfield.text!, myself: "test")
            }
        }
        else if(sender.tag==2)
        {
            print("skillsfield =>\(skillsfield.texts)")
            let skillsstring = String(format: "%@", skillsfield.texts as CVarArg)
            self.connectionClass.UpdateWorkInfo(occupation: designationtxtfield.text!, skills: skillsstring)
        }
        else if(sender.tag==3)
        {
            self.connectionClass.UpdateContactInfo(phone: phonetxtfield.text!, address: addresstxtfield.text!)
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
        
        brithdaytxtfield.text = String(format: "%@", commonmethodClass.convertDateFormatterOnly(date: dateString))
    }
    
    @IBAction func doneAction(sender : AnyObject)
    {
        pickView.isHidden = true
    }
    
    @IBAction func datepickerdoneAction(sender : AnyObject)
    {
        datepickView.isHidden = true
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
                    
                    imageBool = true
                    imagecount = 1
                }
                else
                {
                    if((InfoDict.value(forKey: "address")) != nil)
                    {
                        contactInfoDictionary = InfoDict
                    }
                    else if((InfoDict.value(forKey: "occupation")) != nil)
                    {
                        workInfoDictionary = InfoDict
                    }
                    else
                    {
                        generalInfoDictionary = InfoDict
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
            }
            
            tblprofile.reloadData()
        }
    }
    
    // MARK: - UITextView Delegate

    func textViewDidBeginEditing(_ textView: UITextView)
    {
        
    }
    
    func textViewDidChange(_ textView: UITextView)
    {
        
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool
    {
        if (text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    // MARK: - UITextField Delegate
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        print("textField =>\(textField.tag)")
        
        if textField.placeholder == "Gender"
        {
            if genderArray.count>0
            {
                pickView.isHidden = false
                datepickView.isHidden = true
                pickerView.reloadAllComponents()
            }
            
            commonmethodClass.delayWithSeconds(0.0, completion: {
                textField.resignFirstResponder()
            })
        }
        else if textField.placeholder == "Birthday"
        {
            pickView.isHidden = true
            datepickView.isHidden = false
            
            commonmethodClass.delayWithSeconds(0.0, completion: {
                textField.resignFirstResponder()
            })
        }
        else
        {
            pickView.isHidden = true
            datepickView.isHidden = true
        }
        
//        commonmethodClass.delayWithSeconds(0.5, completion: {
//            self.tblprofile.scrollToRow(at: IndexPath(row: 0, section: textField.tag), at: .top, animated: true)
//        })
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        if(textField.tag==1)
        {
            generaleditBool = true
            
//            commonmethodClass.delayWithSeconds(0.0, completion: {
//                textField.resignFirstResponder()
//            })
            
//            var headerIndexPath = IndexPath(for: 0, section: textField.tag)
//            tblprofile.reloadRows(at: [headerIndexPath], with: .automatic)

//            let sectionHeader = tableView(tblprofile, viewForHeaderInSection: textField.tag) as! UITableViewCell
//            for view : UIView in sectionHeader.contentView.subviews
//            {
//                if let savebtn = view as? UIButton
//                {
//                    print("view =>\(savebtn.currentTitle)")
//                    if savebtn.currentTitle == "SAVE"
//                    {
//                        savebtn.setTitleColor(greenColor, for: .normal)
//                        savebtn.setTitle("asdgasdg", for: .normal)
//                        break
//                    }
//                }
//            }
        }
        
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
                    }
                }
            }
            else
            {
                let imageData = UIImageJPEGRepresentation(pickImage, 1.0)
                print("imageData => \(String(describing: imageData?.count))")
                
                self.imgData = imageData as NSData!
            }
            
            tblprofile.reloadData()
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
                    txtfield?.text = String(format: "%@", generalInfoDictionary.value(forKey: "firstName") as! CVarArg)
                    firstnametxtfield = txtfield
                }
                else if(indexPath.row==1)
                {
                    txtfield?.text = String(format: "%@", generalInfoDictionary.value(forKey: "lastName") as! CVarArg)
                    lastnametxtfield = txtfield
                }
                else if(indexPath.row==2)
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
                    gendertxtfield = txtfield
                }
                else if(indexPath.row==3)
                {
                    let brithday = String(format: "%@", generalInfoDictionary.value(forKey: "dob") as! CVarArg)
                    
                    txtfield?.text = String(format: "%@", commonmethodClass.convertDate(date: brithday))
                    brithdaytxtfield = txtfield
                }
                else if(indexPath.row==4)
                {
                    txtfield?.text = String(format: "%@", generalInfoDictionary.value(forKey: "location") as! CVarArg)
                    locationtxtfield = txtfield
                }
            }
            else if(indexPath.section==2)
            {
                txtfield?.isUserInteractionEnabled = true

                titlelbl?.text = workInfoArray[indexPath.row] as? String
                
                txtfield?.placeholder = workInfoArray[indexPath.row] as? String
                
                if(indexPath.row==0)
                {
                    txtfield?.text = String(format: "%@", workInfoDictionary.value(forKey: "occupation") as! CVarArg)
                    designationtxtfield = txtfield
                }
                else if(indexPath.row==1)
                {
                    txtfield?.isHidden = true
                    
                    var text = String(format: "%@", workInfoDictionary.value(forKey: "skills") as! CVarArg)
                    text = String(text.characters.filter { !" \n\t\r()".characters.contains($0) })
                    let array = (text.components(separatedBy: ",")) as NSArray
                    print("array =>\(array)")
                    
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
            else if(indexPath.section==3)
            {
                titlelbl?.text = contactInfoArray[indexPath.row] as? String
                
                txtfield?.placeholder = contactInfoArray[indexPath.row] as? String
                
                if(indexPath.row==0)
                {
                    txtfield?.text = String(format: "%@", contactInfoDictionary.value(forKey: "phone") as! CVarArg)
                    txtfield?.isUserInteractionEnabled = true
                    phonetxtfield = txtfield
                }
                else if(indexPath.row==1)
                {
                    txtfield?.text = String(format: "%@", commonmethodClass.retrieveemail())
                    txtfield?.isUserInteractionEnabled = false
                }
                else if(indexPath.row==2)
                {
                    addtxtfield?.placeholder = (contactInfoArray[indexPath.row] as? String)!
                    addtxtfield?.text = String(format: "%@", contactInfoDictionary.value(forKey: "address") as! CVarArg)
                    addresstxtfield = addtxtfield
                    txtfield?.isHidden = true
                    addtxtfield?.isHidden = false
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
                    var txtheight = commonmethodClass.dynamicHeight(width: screenWidth-160, font: UIFont (name: LatoRegular, size: 17)!, string: String(format: "%@", contactInfoDictionary.value(forKey: "address") as! CVarArg))
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
        return 50.0
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
                if(pickimage != nil)
                {
                    savebtn?.setTitleColor(greenColor, for: .normal)
                }
                else
                {
                    savebtn?.setTitleColor(UIColor.lightGray, for: .normal)
                }
                break
            case 1:
                titlelbl?.text = "GENERAL INFO";
//                if(generaleditBool==true)
//                {
//                    savebtn?.setTitleColor(greenColor, for: .normal)
//                }
//                else
//                {
//                    savebtn?.setTitleColor(UIColor.lightGray, for: .normal)
//                }
                break
            case 2:
                titlelbl?.text = "WORK INFO";
                break
            case 3:
                titlelbl?.text = "CONTACT INFO";
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
        gendertxtfield.text = genderdictionary["name"] as? String
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
