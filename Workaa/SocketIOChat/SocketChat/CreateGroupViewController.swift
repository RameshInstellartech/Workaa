//
//  CreateGroupViewController.swift
//  Workaa
//
//  Created by IN1947 on 10/03/17.
//  Copyright © 2017 IN1947. All rights reserved.
//

import UIKit
import Photos

class CreateGroupViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, ConnectionProtocol, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet weak var scrollview: UIScrollView!
    @IBOutlet weak var profileimage: UIImageView!
    @IBOutlet weak var groupnametxtField : UITextField!
    @IBOutlet weak var switchtype : TTFadeSwitch!
    @IBOutlet weak var hourswitchtype : TTFadeSwitch!
    @IBOutlet weak var groupDesc: PlaceholderTextView!
    @IBOutlet weak var cameralbl : UILabel!
    @IBOutlet weak var uploadlbl : UILabel!
    @IBOutlet weak var tblteamlist: UITableView!
    @IBOutlet weak var tblheight: NSLayoutConstraint!

    var validationClass = ValidationClass()
    var alertClass = AlertClass()
    var connectionClass = ConnectionClass()
    var commonmethodClass = CommonMethodClass()
    var imgData = NSData()
    var userListView = UserListView()
    var selecteduserArray = NSMutableArray()

    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let leftcontainView = UIView()
        leftcontainView.frame = CGRect(x: 0.0, y: 0.0, width: 44.0, height: 44.0)
        let closeiconbtn = UIButton()
        closeiconbtn.frame = CGRect(x: CGFloat(0.0), y: CGFloat(0.0), width: CGFloat(44.0), height: CGFloat(44.0))
        closeiconbtn.titleLabel?.font = UIFont(name: Workaa_Font, size: CGFloat(25.0))
        closeiconbtn.backgroundColor = UIColor.clear
        closeiconbtn.setTitleColor(UIColor.white, for: .normal)
        closeiconbtn.setTitle(closeIcon, for: .normal)
        closeiconbtn.contentHorizontalAlignment = .left
        closeiconbtn.addTarget(self, action: #selector(CreateGroupViewController.closeaction), for: .touchUpInside)
        leftcontainView.addSubview(closeiconbtn)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftcontainView)
        
        let rightcontainView = UIView()
        rightcontainView.frame = CGRect(x: 0.0, y: 0.0, width: 44.0, height: 44.0)
        let sendiconbtn = UIButton()
        sendiconbtn.frame = CGRect(x: CGFloat(0.0), y: CGFloat(0.0), width: CGFloat(44.0), height: CGFloat(44.0))
        sendiconbtn.titleLabel?.font = UIFont(name: Workaa_Font, size: CGFloat(27.0))
        sendiconbtn.backgroundColor = UIColor.clear
        sendiconbtn.setTitleColor(UIColor.white, for: .normal)
        sendiconbtn.setTitle(sendIcon, for: .normal)
        sendiconbtn.contentHorizontalAlignment = .right
        sendiconbtn.addTarget(self, action: #selector(CreateGroupViewController.creategroup), for: .touchUpInside)
        rightcontainView.addSubview(sendiconbtn)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightcontainView)
        
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CreateTeamViewController.profileaction))
        tapGesture.numberOfTapsRequired = 1
        profileimage.addGestureRecognizer(tapGesture)
                
        cameralbl.text = cameraIcon
        
        connectionClass.delegate = self
        
        groupnametxtField.attributedPlaceholder = NSAttributedString(string: groupnametxtField.placeholder!, attributes: [NSForegroundColorAttributeName:UIColor.darkGray])
        
        switchtype.thumbImage = UIImage(named: "switchToggle")
        switchtype.thumbHighlightImage = UIImage(named: "switchToggleHigh")
        switchtype.trackMaskImage = UIImage(named: "switchMask")
        switchtype.viewstring = "groupType"
        switchtype.onString = " PUBLIC"
        switchtype.offString = "PRIVATE"
        switchtype.onLabel.font = UIFont(name: LatoBlack, size: CGFloat(11.0))!
        switchtype.offLabel.font = UIFont(name: LatoBlack, size: CGFloat(11.0))!
        switchtype.onLabel.textColor = UIColor.white
        switchtype.offLabel.textColor = UIColor.white
        switchtype.labelsEdgeInsets = UIEdgeInsetsMake(0.0, 16.0, 0.0, 16.0)
        switchtype.thumbInsetX = -3.0
        switchtype.thumbOffsetY = 2.0
        switchtype.isOn = true
        
        hourswitchtype.thumbImage = UIImage(named: "switchToggle")
        hourswitchtype.thumbHighlightImage = UIImage(named: "switchToggleHigh")
        hourswitchtype.trackMaskImage = UIImage(named: "switchMask")
        hourswitchtype.viewstring = "hours"
        hourswitchtype.onString = "YES"
        hourswitchtype.offString = "NO "
        hourswitchtype.onLabel.font = UIFont(name: LatoBlack, size: CGFloat(12.0))!
        hourswitchtype.offLabel.font = UIFont(name: LatoBlack, size: CGFloat(12.0))!
        hourswitchtype.onLabel.textColor = UIColor.white
        hourswitchtype.offLabel.textColor = UIColor.white
        hourswitchtype.labelsEdgeInsets = UIEdgeInsetsMake(0.0, 30.0, 0.0, 32.0)
        hourswitchtype.thumbInsetX = -3.0
        hourswitchtype.thumbOffsetY = 2.0
        hourswitchtype.isOn = false
        
        tblteamlist.register(UINib(nibName: "teamUserTableViewCell", bundle: nil), forCellReuseIdentifier: "teamUserCell")
        
        NotificationCenter.default.addObserver(self, selector: #selector(GroupViewController.handleKeyboardWillShowNotification(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(GroupViewController.handleKeyboardWillHideNotification(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = false
        
        navigationController?.navigationBar.barTintColor = blueColor
        
        self.title = "New Group"
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
    
    func getselecteduser(array : NSMutableArray)
    {
        print("getselecteduser =>\(array)")
        
        for item in array
        {
            let obj = item as! NSDictionary
            let emailstring = String(format: "%@",obj.value(forKey: "email") as! CVarArg)

            let predicate = NSPredicate(format: "email like %@",emailstring);
            let filteredArray = selecteduserArray.filter { predicate.evaluate(with: $0) };
            if filteredArray.count == 0
            {
                selecteduserArray.add(obj)
            }
        }
        
        tblheight.constant = CGFloat(selecteduserArray.count * 50) + 55
        
        tblteamlist.reloadData()
    }
    
    func jsonToString(json: AnyObject) -> String
    {
        do {
            let data1 =  try JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted)
            let convertedString = String(data: data1, encoding: String.Encoding.utf8)
            return convertedString!
        } catch let myJSONError {
            print(myJSONError)
        }
        return""
    }
    
    // MARK: - KeyboardNotification Methods
    
    func handleKeyboardWillShowNotification(notification: NSNotification)
    {
        if let userInfo = notification.userInfo
        {
            if let keyboardFrame = (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue
            {
                scrollview.contentOffset = CGPoint(x: 0.0, y: keyboardFrame.size.height)
            }
        }
    }
    
    func handleKeyboardWillHideNotification(notification: NSNotification)
    {
        scrollview.contentOffset = CGPoint(x: 0.0, y: 0.0)
    }
    
    // MARK: - UIImagePickerControllerDelegate Methods
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        dismiss(animated: true, completion: nil)
        
        if let pickImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
            print("pickImage => \(pickImage)")
            
            cameralbl.isHidden = true
            uploadlbl.isHidden = true
            
            profileimage.image = pickImage
            
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
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - UITextField Delegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: UITextViewDelegate Methods
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool
    {
        if (text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    // MARK: - Actions Methods
    
    func closeaction()
    {
        navigation().popViewController(animated: true)
    }
    
    func creategroup()
    {
        if groupnametxtField.text?.characters.count == 0
        {
            alertClass.showAlert(alerttitle: "Info", alertmsg: groupCreateReponse.value(forKey: "nameRequired") as! String)
        }
//        else if (profileimage.image == nil)
//        {
//            alertClass.showAlert(alerttitle: "Info", alertmsg: groupCreateReponse.value(forKey: "imageRequired") as! String)
//        }
        else if !validationClass.containsAlphaNumeric(input: groupnametxtField.text!)
        {
            alertClass.showAlert(alerttitle: "Info", alertmsg: groupCreateReponse.value(forKey: "invalidName") as! String)
        }
        else if (groupnametxtField.text?.characters.count)! > 50
        {
            alertClass.showAlert(alerttitle: "Info", alertmsg: groupCreateReponse.value(forKey: "nameLength") as! String)
        }
        else if (groupDesc.text?.characters.count)! > 255
        {
            alertClass.showAlert(alerttitle: "Info", alertmsg: groupCreateReponse.value(forKey: "descriptionLength") as! String)
        }
        else
        {
            var privacy = "0"            
            if(!switchtype.isOn)
            {
                privacy = "1"
            }
            
            var hourstatus = "0"
            if(hourswitchtype.isOn)
            {
                hourstatus = "1"
            }
            
            let array = NSMutableArray()
            
            for item in selecteduserArray
            {
                let obj = item as! NSDictionary
                let keystring = String(format: "%@",obj.value(forKey: "email") as! CVarArg)
                let valuestring = String(format: "%@",obj.value(forKey: "admin") as! CVarArg)
                
                let dict = NSMutableDictionary()
                dict.setValue(valuestring, forKey: keystring)
                array.add(dict)
            }
            
            print("array =>\(array)")
            print("jsonToString =>\(self.jsonToString(json: array))")
            
            connectionClass.CreateGroup(groupname: groupnametxtField.text!, desc: groupDesc.text, privacy: privacy, imageData: self.imgData as Data, hourpermission: hourstatus, users: self.jsonToString(json: array))
        }
    }
    
    func profileaction()
    {
        alertClass.createGroupAttachment()
    }
    
    func getUseraction()
    {
        for v: UIView in userListView.subviews {
            v.removeFromSuperview()
        }
        userListView.removeFromSuperview()
        
        userListView = Bundle.main.loadNibNamed("UserListView", owner: nil, options: nil)?[0] as! UserListView
        userListView.frame = CGRect(x: 0.0, y: 0.0, width: screenWidth, height: screenHeight-64.0)
        userListView.loadUserListView(params: "Create Group", groupId: "")
        self.view.addSubview(userListView)
    }
    
    func usercloseaction(sender : UIButton)
    {
        print("sender =>\(sender.tag)")
        
        if(selecteduserArray.count>0)
        {
            selecteduserArray.removeObject(at: sender.tag)
        }
        
        tblheight.constant = CGFloat(selecteduserArray.count * 50) + 55

        tblteamlist.reloadData()
    }
    
    func userlevelaction(_ sender: UITapGestureRecognizer)
    {
         let tappedView = sender.view!
        print("sender =>\(tappedView.tag)")
        print("selecteduserArray =>\(selecteduserArray)")
        
        let userdictionary = selecteduserArray[tappedView.tag] as! NSDictionary
        var adminstring = String(format: "%@", userdictionary.value(forKey: "admin") as! CVarArg)
        if adminstring == "1"
        {
            adminstring = "0"
        }
        else
        {
            adminstring = "1"
        }
        userdictionary.setValue(adminstring, forKey: "admin")
        
        print("selecteduserArray =>\(selecteduserArray)")
        
        tblteamlist.reloadData()
    }
    
    // MARK: - Connection Delegate
    
    func GetFailureReponseMethod(errorreponse: String)
    {
        print("GetFailureReponseMethod")
    }
    
    func GetReponseMethod(reponse : NSDictionary)
    {
        print("reponse => \(reponse)")
        
        for aviewcontroller : UIViewController in navigation().viewControllers
        {
            if let grouplistView = aviewcontroller as? GroupListController
            {
                grouplistView.getGroupList()
                break
            }
        }
        
        navigation().popViewController(animated: true)
    }

    // MARK: UITableView Delegate and Datasource Methods
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return selecteduserArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "teamUserCell", for: indexPath) as! teamUserTableViewCell
        
        let userdictionary = selecteduserArray[indexPath.row] as! NSDictionary
        
        let filestring = String(format: "%@%@", kfilePath,(userdictionary["pic"] as? String)!)
        let fileUrl = NSURL(string: filestring)
        cell.profileimage.imageURL = fileUrl as URL?
        
        cell.closebtn.setTitle(closeIcon, for: .normal)
        cell.closebtn.addTarget(self, action: #selector(self.usercloseaction(sender:)), for: .touchUpInside)
        cell.closebtn.tag = indexPath.row
        cell.closebtn.contentEdgeInsets = UIEdgeInsetsMake(0.0, 12.0, 0.0, 0.0)
        
//        cell.lblusername.text = String(format: "%@ %@", userdictionary.value(forKey: "firstName") as! CVarArg, userdictionary.value(forKey: "lastName") as! CVarArg)
        cell.lblusername.text = String(format: "%@", userdictionary.value(forKey: "firstName") as! CVarArg)
        
        let levelstring = String(format: "%@",userdictionary.value(forKey: "admin") as! CVarArg)
        if levelstring == "1"
        {
            cell.levelView.layer.borderColor = blueColor.cgColor
            cell.levelLbl.textColor = blueColor
            cell.arrowLbl.textColor = blueColor
            cell.levelLbl.text = "Admin"
        }
        else
        {
            cell.levelView.layer.borderColor = lightgrayColor.cgColor
            cell.levelLbl.textColor = UIColor(red: 133.0/255.0, green: 133.0/255.0, blue: 133.0/255.0, alpha: 1.0)
            cell.arrowLbl.textColor = lightgrayColor
            cell.levelLbl.text = "Normal"
        }
        cell.levelView.layer.borderWidth = 1.0
        cell.arrowLbl.text = soliddownarrowIcon
        cell.levelView.tag = indexPath.row
        
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.userlevelaction))
        tapGesture.numberOfTapsRequired = 1
        cell.levelView.addGestureRecognizer(tapGesture)
        
        cell.selectionStyle = .none

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 55.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let headerheight = self.tableView(tableView, heightForHeaderInSection: section)

        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: headerheight))
        headerView.backgroundColor = UIColor(red: 249/255, green: 249/255, blue: 249/255, alpha: 1)
        
        let personlbl = UILabel()
        personlbl.frame = CGRect(x: CGFloat(15.0), y: CGFloat(0.0), width: CGFloat(30.0), height: CGFloat(headerheight))
        personlbl.font = UIFont(name: Workaa_Font, size: CGFloat(25.0))
        personlbl.backgroundColor = UIColor.clear
        personlbl.textColor = UIColor.darkGray
        personlbl.text = adduserIcon
        headerView.addSubview(personlbl)
        
        let memberslbl = UILabel()
        memberslbl.frame = CGRect(x: CGFloat(personlbl.frame.maxX+10.0), y: CGFloat(0.0), width: CGFloat(110.0), height: CGFloat(headerheight))
        memberslbl.font = UIFont(name: LatoRegular, size: CGFloat(16.0))
        memberslbl.backgroundColor = UIColor.clear
        memberslbl.textColor = UIColor.darkGray
        memberslbl.text = "Add Members"
        headerView.addSubview(memberslbl)
        
        let plusiconbtn = UIButton()
        plusiconbtn.frame = CGRect(x: CGFloat(screenWidth-55.0), y: CGFloat(0.0), width: CGFloat(40.0), height: CGFloat(headerheight))
        plusiconbtn.titleLabel?.font = UIFont(name: Workaa_Font, size: CGFloat(27.0))
        plusiconbtn.backgroundColor = UIColor.clear
        plusiconbtn.setTitleColor(UIColor.lightGray, for: .normal)
        plusiconbtn.setTitle(roundplusIcon, for: .normal)
//        plusiconbtn.addTarget(self, action: #selector(CreateGroupViewController.getUseraction), for: .touchUpInside)
        plusiconbtn.contentHorizontalAlignment = .right
        headerView.addSubview(plusiconbtn)
        
        let overlaybtn = UIButton()
        overlaybtn.frame = CGRect(x: CGFloat(0.0), y: CGFloat(0.0), width: CGFloat(screenWidth), height: CGFloat(headerheight))
        overlaybtn.backgroundColor = UIColor.clear
        overlaybtn.addTarget(self, action: #selector(CreateGroupViewController.getUseraction), for: .touchUpInside)
        headerView.addSubview(overlaybtn)
        
        return headerView
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
