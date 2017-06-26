//
//  GroupDetailsInfoViewController.swift
//  Workaa
//
//  Created by IN1947 on 06/05/17.
//  Copyright © 2017 IN1947. All rights reserved.
//

import UIKit
import Photos

class GroupDetailsInfoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ConnectionProtocol, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var grouplogo: AsyncImageView!
    @IBOutlet weak var groupname: UITextField!
    @IBOutlet weak var editbtn: UIButton!
    @IBOutlet weak var favarrow: UILabel!
    @IBOutlet weak var filesarrow: UILabel!
    @IBOutlet weak var switchtype : TTFadeSwitch!
    @IBOutlet weak var hourswitchtype : TTFadeSwitch!
    @IBOutlet weak var tblteamlist: UITableView!
    @IBOutlet weak var tblheight: NSLayoutConstraint!
    @IBOutlet weak var groupfiles: UILabel!
    @IBOutlet weak var groupfavmsg: UILabel!
    @IBOutlet weak var groupmemaction: UIView!

    var groupid = String()
    var groupInfodictionary = NSDictionary()
    var selecteduserArray = NSMutableArray()
    var userListView = UserListView()
    var connectionClass = ConnectionClass()
    var commonmethodClass = CommonMethodClass()
    var imgData : NSData!
    var sendertag = NSInteger()
    var myActivityIndicator = UIActivityIndicatorView()

    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        connectionClass.delegate = self
        
        editbtn.setTitle(editIcon, for: .normal)
        editbtn.layer.borderColor = UIColor.lightGray.cgColor
        editbtn.layer.borderWidth = 0.5
        
        favarrow.text = rightarrowIcon
        filesarrow.text = rightarrowIcon
        
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
        switchtype.addTarget(self, action: #selector(typeswitchValueDidChange), for: .valueChanged)
        
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
        hourswitchtype.addTarget(self, action: #selector(hoursswitchValueDidChange), for: .valueChanged)
        
        tblteamlist.register(UINib(nibName: "GroupUserTableViewCell", bundle: nil), forCellReuseIdentifier: "GroupUserCell")
        
        print("groupid =>\(groupid)")

        for view : UIView in groupmemaction.subviews
        {
            for view1 : UIView in view.subviews
            {
                if(view1.tag==0)
                {
                    for view2 : UIView in view1.subviews
                    {
                        if let btn = view2 as? UIButton
                        {
                            btn.setTitle(closeIcon, for: .normal)
                        }
                    }
                }
            }
        }
        
        scrollView.isHidden = true
        self.startanimating()
        commonmethodClass.delayWithSeconds(0.0, completion: {
            self.getGroupInfo()
        })
    }

    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        self.title = "Group Details"
        
        self.navigationController?.navigationBar.isHidden = false
        
        navigationController?.navigationBar.barTintColor = blueColor
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
    
    func typeswitchValueDidChange()
    {
        print("typeswitchValueDidChange =>\(switchtype.isOn)")
        
        var privacy = ""
        if(switchtype.isOn)
        {
            privacy = "0"
        }
        else
        {
            privacy = "1"
        }
        
        connectionClass.UpdateGroupType(groupid: String(format: "%@", groupInfodictionary.value(forKey: "id") as! CVarArg), type: privacy)
    }
    
    func hoursswitchValueDidChange()
    {
        print("hoursswitchValueDidChange =>\(hourswitchtype.isOn)")
        
        var hourstatus = ""
        if(hourswitchtype.isOn)
        {
            hourstatus = "1"
        }
        else
        {
            hourstatus = "0"
        }
        
        connectionClass.UpdateGroupHours(groupid: String(format: "%@", groupInfodictionary.value(forKey: "id") as! CVarArg), hours: hourstatus)
    }
    
    func getGroupInfo()
    {
        connectionClass.getGroupInfo(groupid: groupid)
    }
    
    func profileaction()
    {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Take Photo", style: .default , handler:{ (UIAlertAction)in
            self.camera()
        }))
        alert.addAction(UIAlertAction(title: "Choose From Library", style: .default , handler:{ (UIAlertAction)in
            self.library()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel , handler:{ (UIAlertAction)in
            print("Cancel")
        }))
       self.present(alert, animated: true, completion: {
            print("completion block")
        })
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
    
    @IBAction func close(sender : UIButton)
    {
        groupmemaction.isHidden = true
    }
    
    @IBAction func usercloseaction(sender : UIButton)
    {
        print("sender =>\(sendertag)")
        
        let adminstring = String(format: "%@", groupInfodictionary.value(forKey: "admin") as! CVarArg)
        if(commonmethodClass.retrieveteamadmin()=="1" || adminstring=="1")
        {
            if(selecteduserArray.count>0)
            {
                let userdictionary = selecteduserArray[sendertag] as! NSDictionary
                let emailstring = String(format: "%@", userdictionary.value(forKey: "email") as! CVarArg)
                let dictionary = connectionClass.UpdateRemoveUser(groupid: String(format: "%@", groupInfodictionary.value(forKey: "id") as! CVarArg), email: emailstring)
                print("dictionary =>\(dictionary)")
                if(dictionary.count>0)
                {
                    if let statuscode = dictionary.value(forKey: "status") as? NSInteger
                    {
                        if statuscode==1
                        {
                            selecteduserArray.removeObject(at: sendertag)
                            
                            self.close(sender: sender)
                            
                            tblheight.constant = CGFloat(selecteduserArray.count * 50) + 55
                            
                            tblteamlist.reloadData()
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func userlevelaction(sender : UIButton)
    {
        let admnstring = String(format: "%@", groupInfodictionary.value(forKey: "admin") as! CVarArg)
        if(commonmethodClass.retrieveteamadmin()=="1" || admnstring=="1")
        {
            print("sender =>\(sendertag)")
            print("selecteduserArray =>\(selecteduserArray)")
            
            let userdictionary = selecteduserArray[sendertag] as! NSDictionary
            var adminstring = String(format: "%@", userdictionary.value(forKey: "admin") as! CVarArg)
            let emailstring = String(format: "%@", userdictionary.value(forKey: "email") as! CVarArg)
            var dictionary = NSDictionary()
            if adminstring == "1"
            {
                adminstring = "0"
                
                dictionary = connectionClass.UpdateRemoveAdmin(groupid: String(format: "%@", groupInfodictionary.value(forKey: "id") as! CVarArg), email: emailstring)
            }
            else
            {
                adminstring = "1"
                
                dictionary = connectionClass.UpdateMarkAdmin(groupid: String(format: "%@", groupInfodictionary.value(forKey: "id") as! CVarArg), email: emailstring)
            }
            
            if(dictionary.count>0)
            {
                if let statuscode = dictionary.value(forKey: "status") as? NSInteger
                {
                    if statuscode==1
                    {
                        userdictionary.setValue(adminstring, forKey: "admin")
                        
                        print("selecteduserArray =>\(selecteduserArray)")
                        
                        self.close(sender: sender)
                        
                        tblteamlist.reloadData()
                    }
                }
            }
        }
    }
    
    func getUseraction()
    {
        let adminstring = String(format: "%@", groupInfodictionary.value(forKey: "admin") as! CVarArg)
        if(commonmethodClass.retrieveteamadmin()=="1" || adminstring=="1")
        {
            for v: UIView in userListView.subviews {
                v.removeFromSuperview()
            }
            userListView.removeFromSuperview()
            
            userListView = Bundle.main.loadNibNamed("UserListView", owner: nil, options: nil)?[0] as! UserListView
            userListView.frame = CGRect(x: 0.0, y: 0.0, width: screenWidth, height: screenHeight-64.0)
            userListView.loadUserListView(params: "Group Details", groupId: String(format: "%@", groupInfodictionary.value(forKey: "id") as! CVarArg))
            self.view.addSubview(userListView)
        }
    }
    
    @IBAction func editaction(sender: AnyObject)
    {
        let admnstring = String(format: "%@", groupInfodictionary.value(forKey: "admin") as! CVarArg)
        if(commonmethodClass.retrieveteamadmin()=="1" || admnstring=="1")
        {
            groupname.isUserInteractionEnabled = true
            groupname.becomeFirstResponder()
        }
    }
    
    @IBAction func favouriteaction(sender: AnyObject)
    {
        self.title = ""
        
        let favMsgObj = self.storyboard?.instantiateViewController(withIdentifier: "FavMsgViewID") as? FavMsgViewController
        favMsgObj?.groupdictionary = groupInfodictionary
        favMsgObj?.chattype = "GroupChat"
        self.navigationController?.pushViewController(favMsgObj!, animated: true)
    }
    
    @IBAction func filesaction(sender: AnyObject)
    {
        self.title = ""
        
        let filesViewObj = self.storyboard?.instantiateViewController(withIdentifier: "FilesViewID") as? FilesViewController
        filesViewObj?.groupdictionary = groupInfodictionary
        filesViewObj?.chattype = "GroupChat"
        self.navigationController?.pushViewController(filesViewObj!, animated: true)
    }
    
    func updatelogo()
    {
        connectionClass.UpdateGroupLogo(groupid: String(format: "%@", groupInfodictionary.value(forKey: "id") as! CVarArg), imageData: self.imgData as Data)
    }
    
    func updatetitle()
    {
        if (groupname.text?.characters.count)!>0
        {
            connectionClass.UpdateGroupTitle(groupid: String(format: "%@", groupInfodictionary.value(forKey: "id") as! CVarArg), name: groupname.text!)
        }
    }
    
    func getselecteduser(array : NSMutableArray)
    {
        print("getselecteduser =>\(array)")
        
        let emailarray = NSMutableArray()
        for item in array
        {
            let obj = item as! NSDictionary
            let emailstring = String(format: "%@",obj.value(forKey: "email") as! CVarArg)
            
            let predicate = NSPredicate(format: "email like %@",emailstring);
            let filteredArray = selecteduserArray.filter { predicate.evaluate(with: $0) };
            if filteredArray.count == 0
            {
                selecteduserArray.add(obj)
                emailarray.add(emailstring)
            }
        }
        
        if(emailarray.count>0)
        {
            connectionClass.GroupInvitePeople(email: emailarray.componentsJoined(by: ","), groupid: String(format: "%@", groupInfodictionary.value(forKey: "id") as! CVarArg))
        }
        
        tblheight.constant = CGFloat(selecteduserArray.count * 50) + 55
        
        tblteamlist.reloadData()
    }
    
    // MARK: - UITextField Delegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        
        self.updatetitle()
        
        return true
    }
    
    // MARK: - UIImagePickerControllerDelegate Methods
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        dismiss(animated: true, completion: nil)
        
        if let pickImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
            print("pickImage => \(pickImage)")
            
            grouplogo.image = pickImage
            
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
                        
                        self.updatelogo()
                    }
                }
            }
            else
            {
                let imageData = UIImageJPEGRepresentation(pickImage, 1.0)
                print("imageData => \(String(describing: imageData?.count))")
                
                self.imgData = imageData as NSData!
                
                self.updatelogo()
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
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
            if let groupInfo = getreponse.value(forKey: "groupInfo") as? NSDictionary
            {
                groupInfodictionary = groupInfo
                
                let filestring = String(format: "%@%@", kfilePath, groupInfo.value(forKey: "logo") as! CVarArg)
                let fileUrl = NSURL(string: filestring)
                grouplogo.imageURL = fileUrl as URL?
                
                let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.profileaction))
                tapGesture.numberOfTapsRequired = 1
                grouplogo.addGestureRecognizer(tapGesture)
                
                groupname.text = String(format: "%@", groupInfo.value(forKey: "name") as! CVarArg)
                
                let grouptype = String(format: "%@", groupInfo.value(forKey: "type") as! CVarArg)
                if grouptype == "0"
                {
                    switchtype.isOn = true
                }
                else
                {
                    switchtype.isOn = false
                }
                
                let hours = String(format: "%@", groupInfo.value(forKey: "hours") as! CVarArg)
                if hours == "0"
                {
                    hourswitchtype.isOn = false
                }
                else
                {
                    hourswitchtype.isOn = true
                }
                
                let admnstring = String(format: "%@", groupInfo.value(forKey: "admin") as! CVarArg)
                if(commonmethodClass.retrieveteamadmin()=="1" || admnstring=="1")
                {
                    switchtype.isUserInteractionEnabled = true
                    hourswitchtype.isUserInteractionEnabled = true
                }
                else
                {
                    switchtype.isUserInteractionEnabled = false
                    hourswitchtype.isUserInteractionEnabled = false
                }
                
                let files = String(format: "%@", groupInfo.value(forKey: "files") as! CVarArg)
                groupfiles.text = files
                
                let favourite = String(format: "%@", groupInfo.value(forKey: "favourite") as! CVarArg)
                groupfavmsg.text = favourite
                
                if(commonmethodClass.retrieveteamadmin()=="1" || admnstring=="1")
                {
                    grouplogo.isUserInteractionEnabled = true
                }

                if let users = groupInfo.value(forKey: "users_list") as? NSArray
                {
                    selecteduserArray.removeAllObjects()

                    for item in users
                    {
                        let obj = item as! NSDictionary
                        selecteduserArray.add(obj)
                    }
                    
                    if(selecteduserArray.count>0)
                    {
                        tblheight.constant = CGFloat(selecteduserArray.count * 50) + 55
                        tblteamlist.reloadData()
                    }
                }
                
                scrollView.isHidden = false
            }
        }
        
        self.stopanimating()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupUserCell", for: indexPath) as! GroupUserTableViewCell
        
        let userdictionary = selecteduserArray[indexPath.row] as! NSDictionary
        
        let filestring = String(format: "%@%@", kfilePath,(userdictionary["pic"] as? String)!)
        let fileUrl = NSURL(string: filestring)
        cell.profileimage.imageURL = fileUrl as URL?
        
        cell.lblusername.text = String(format: "%@ %@", userdictionary.value(forKey: "firstName") as! CVarArg, userdictionary.value(forKey: "lastName") as! CVarArg)
        
        let levelstring = String(format: "%@",userdictionary.value(forKey: "admin") as! CVarArg)
        if levelstring == "1"
        {
            cell.levelView.isHidden = false
        }
        else
        {
            cell.levelView.isHidden = true
        }
        
        cell.levelView.layer.borderColor = lightgrayColor.cgColor
        cell.levelView.layer.borderWidth = 1.0
        
        let adminstring = String(format: "%@", groupInfodictionary.value(forKey: "admin") as! CVarArg)
        if(commonmethodClass.retrieveteamadmin()=="1" || adminstring=="1")
        {
            cell.selectionStyle = .gray
        }
        else
        {
            cell.selectionStyle = .none
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let adminstring = String(format: "%@", groupInfodictionary.value(forKey: "admin") as! CVarArg)
        if(commonmethodClass.retrieveteamadmin()=="1" || adminstring=="1")
        {
            sendertag = indexPath.row
            
            let userdictionary = selecteduserArray[indexPath.row] as! NSDictionary
            let namestring = String(format: "%@ %@", userdictionary.value(forKey: "firstName") as! CVarArg, userdictionary.value(forKey: "lastName") as! CVarArg)
            let levelstring = String(format: "%@",userdictionary.value(forKey: "admin") as! CVarArg)
            
            for view : UIView in groupmemaction.subviews
            {
                for view1 : UIView in view.subviews
                {
                    for view2 : UIView in view1.subviews
                    {
                        if let lbl = view2 as? UILabel
                        {
                            if(view1.tag==1)
                            {
                                if levelstring == "1"
                                {
                                    lbl.text = "Remove Admin"
                                }
                                else
                                {
                                    lbl.text = "Make Group Admin"
                                }
                            }
                            if(view1.tag==2)
                            {
                                lbl.text = String(format: "Remove %@",namestring)
                            }
                        }
                    }
                }
            }
            
            groupmemaction.isHidden = false
        }
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
        
        if groupInfodictionary.count > 0
        {
            let adminstring = String(format: "%@", groupInfodictionary.value(forKey: "admin") as! CVarArg)
            if(commonmethodClass.retrieveteamadmin()=="1" || adminstring=="1")
            {
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
            }
        }
        
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
