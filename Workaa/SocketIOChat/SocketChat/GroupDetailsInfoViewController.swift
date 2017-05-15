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

    var groupdictionary = NSDictionary()
    var selecteduserArray = NSMutableArray()
    var userListView = UserListView()
    var connectionClass = ConnectionClass()
    var commonmethodClass = CommonMethodClass()
    var imgData : NSData!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        connectionClass.delegate = self
        
        let filestring = String(format: "%@%@", kfilePath, groupdictionary.value(forKey: "logo") as! CVarArg)
        let fileUrl = NSURL(string: filestring)
        grouplogo.imageURL = fileUrl as URL?
        
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(GroupDetailsInfoViewController.profileaction))
        tapGesture.numberOfTapsRequired = 1
        grouplogo.addGestureRecognizer(tapGesture)
        
        groupname.text = String(format: "%@", groupdictionary.value(forKey: "name") as! CVarArg)
        
        editbtn.setTitle(editIcon, for: .normal)
        editbtn.layer.borderColor = UIColor.lightGray.cgColor
        editbtn.layer.borderWidth = 0.5
        
        favarrow.text = rightarrowIcon
        filesarrow.text = rightarrowIcon
        
        switchtype.thumbImage = UIImage(named: "switchToggle")
        switchtype.thumbHighlightImage = UIImage(named: "switchToggleHigh")
        switchtype.trackMaskImage = UIImage(named: "switchMask")
        switchtype.onString = " PUBLIC"
        switchtype.offString = "PRIVATE"
        switchtype.onLabel.font = UIFont(name: LatoBold, size: CGFloat(14.0))!
        switchtype.offLabel.font = UIFont(name: LatoBold, size: CGFloat(14.0))!
        switchtype.onLabel.textColor = UIColor.white
        switchtype.offLabel.textColor = UIColor.white
        switchtype.labelsEdgeInsets = UIEdgeInsetsMake(0.0, 10.0, 0.0, 10.0)
        switchtype.thumbInsetX = -3.0
        switchtype.thumbOffsetY = 2.0
        switchtype.addTarget(self, action: #selector(typeswitchValueDidChange), for: .valueChanged)
        let grouptype = String(format: "%@", groupdictionary.value(forKey: "type") as! CVarArg)
        if grouptype == "0"
        {
            switchtype.isOn = true
        }
        else
        {
            switchtype.isOn = false
        }
        
        hourswitchtype.thumbImage = UIImage(named: "switchToggle")
        hourswitchtype.thumbHighlightImage = UIImage(named: "switchToggleHigh")
        hourswitchtype.trackMaskImage = UIImage(named: "switchMask")
        hourswitchtype.onString = "YES"
        hourswitchtype.offString = "NO "
        hourswitchtype.onLabel.font = UIFont(name: LatoBold, size: CGFloat(15.0))!
        hourswitchtype.offLabel.font = UIFont(name: LatoBold, size: CGFloat(15.0))!
        hourswitchtype.onLabel.textColor = UIColor.white
        hourswitchtype.offLabel.textColor = UIColor.white
        hourswitchtype.labelsEdgeInsets = UIEdgeInsetsMake(0.0, 27.0, 0.0, 27.0)
        hourswitchtype.thumbInsetX = -3.0
        hourswitchtype.thumbOffsetY = 2.0
        hourswitchtype.addTarget(self, action: #selector(hoursswitchValueDidChange), for: .valueChanged)
        let hours = String(format: "%@", groupdictionary.value(forKey: "hours") as! CVarArg)
        if hours == "0"
        {
            hourswitchtype.isOn = false
        }
        else
        {
            hourswitchtype.isOn = true
        }
        
        let admnstring = String(format: "%@", groupdictionary.value(forKey: "admin") as! CVarArg)
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
        
        tblteamlist.register(UINib(nibName: "teamUserTableViewCell", bundle: nil), forCellReuseIdentifier: "teamUserCell")
        
        commonmethodClass.delayWithSeconds(0.1, completion: {
            self.getUserList()
        })
        
        let files = String(format: "%@", groupdictionary.value(forKey: "files") as! CVarArg)
        groupfiles.text = files
        
        let favourite = String(format: "%@", groupdictionary.value(forKey: "favourite") as! CVarArg)
        groupfavmsg.text = favourite
        
        print("groupdictionary =>\(groupdictionary)")
    }

    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        self.title = "Group Details"
        
        self.navigationController?.navigationBar.isHidden = false
        
        navigationController?.navigationBar.barTintColor = blueColor
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
        
        connectionClass.UpdateGroupType(groupid: String(format: "%@", groupdictionary.value(forKey: "id") as! CVarArg), type: privacy)
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
        
        connectionClass.UpdateGroupHours(groupid: String(format: "%@", groupdictionary.value(forKey: "id") as! CVarArg), hours: hourstatus)
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
    
    func getUserList()
    {
        connectionClass.UserList(groupid: (groupdictionary["id"] as? String)!)
    }
    
    func usercloseaction(sender : UIButton)
    {
        print("sender =>\(sender.tag)")
        
        let adminstring = String(format: "%@", groupdictionary.value(forKey: "admin") as! CVarArg)
        if(commonmethodClass.retrieveteamadmin()=="1" || adminstring=="1")
        {
            if(selecteduserArray.count>0)
            {
                let userdictionary = selecteduserArray[sender.tag] as! NSDictionary
                let emailstring = String(format: "%@", userdictionary.value(forKey: "email") as! CVarArg)
                connectionClass.UpdateRemoveUser(groupid: String(format: "%@", groupdictionary.value(forKey: "id") as! CVarArg), email: emailstring)
                
                selecteduserArray.removeObject(at: sender.tag)
            }
            
            tblheight.constant = CGFloat(selecteduserArray.count * 50) + 55
            
            tblteamlist.reloadData()
        }
    }
    
    func userlevelaction(_ sender: UITapGestureRecognizer)
    {
        let admnstring = String(format: "%@", groupdictionary.value(forKey: "admin") as! CVarArg)
        if(commonmethodClass.retrieveteamadmin()=="1" || admnstring=="1")
        {
            let tappedView = sender.view!
            print("sender =>\(tappedView.tag)")
            print("selecteduserArray =>\(selecteduserArray)")
            
            let userdictionary = selecteduserArray[tappedView.tag] as! NSDictionary
            var adminstring = String(format: "%@", userdictionary.value(forKey: "admin") as! CVarArg)
            let emailstring = String(format: "%@", userdictionary.value(forKey: "email") as! CVarArg)
            if adminstring == "1"
            {
                adminstring = "0"
                
                connectionClass.UpdateRemoveAdmin(groupid: String(format: "%@", groupdictionary.value(forKey: "id") as! CVarArg), email: emailstring)
            }
            else
            {
                adminstring = "1"
                
                connectionClass.UpdateMarkAdmin(groupid: String(format: "%@", groupdictionary.value(forKey: "id") as! CVarArg), email: emailstring)
            }
            userdictionary.setValue(adminstring, forKey: "admin")
            
            print("selecteduserArray =>\(selecteduserArray)")
            
            tblteamlist.reloadData()
        }
    }
    
    func getUseraction()
    {
        let adminstring = String(format: "%@", groupdictionary.value(forKey: "admin") as! CVarArg)
        if(commonmethodClass.retrieveteamadmin()=="1" || adminstring=="1")
        {
            for v: UIView in userListView.subviews {
                v.removeFromSuperview()
            }
            userListView.removeFromSuperview()
            
            userListView = Bundle.main.loadNibNamed("UserListView", owner: nil, options: nil)?[0] as! UserListView
            userListView.frame = CGRect(x: 0.0, y: 0.0, width: screenWidth, height: screenHeight-64.0)
            userListView.loadUserListView(params: "Group Details", groupId: String(format: "%@", groupdictionary.value(forKey: "id") as! CVarArg))
            self.view.addSubview(userListView)
        }
    }
    
    @IBAction func editaction(sender: AnyObject)
    {
        let admnstring = String(format: "%@", groupdictionary.value(forKey: "admin") as! CVarArg)
        if(commonmethodClass.retrieveteamadmin()=="1" || admnstring=="1")
        {
            grouplogo.isUserInteractionEnabled = true
            groupname.isUserInteractionEnabled = true
        }
    }
    
    @IBAction func favouriteaction(sender: AnyObject)
    {
        self.title = ""
        
        let favMsgObj = self.storyboard?.instantiateViewController(withIdentifier: "FavMsgViewID") as? FavMsgViewController
        favMsgObj?.groupdictionary = groupdictionary
        favMsgObj?.chattype = "GroupChat"
        self.navigationController?.pushViewController(favMsgObj!, animated: true)
    }
    
    @IBAction func filesaction(sender: AnyObject)
    {
        self.title = ""
        
        let filesViewObj = self.storyboard?.instantiateViewController(withIdentifier: "FilesViewID") as? FilesViewController
        filesViewObj?.groupdictionary = groupdictionary
        filesViewObj?.chattype = "GroupChat"
        self.navigationController?.pushViewController(filesViewObj!, animated: true)
    }
    
    func updatelogo()
    {
        connectionClass.UpdateGroupLogo(groupid: String(format: "%@", groupdictionary.value(forKey: "id") as! CVarArg), imageData: self.imgData as Data)
    }
    
    func updatetitle()
    {
        if (groupname.text?.characters.count)!>0
        {
            connectionClass.UpdateGroupTitle(groupid: String(format: "%@", groupdictionary.value(forKey: "id") as! CVarArg), name: groupname.text!)
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
            connectionClass.GroupInvitePeople(email: emailarray.componentsJoined(by: ","), groupid: String(format: "%@", groupdictionary.value(forKey: "id") as! CVarArg))
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
    }
    
    func GetReponseMethod(reponse : NSDictionary)
    {
        print("reponse => \(reponse)")
        
        if let getreponse = reponse.value(forKey: "data") as? NSDictionary
        {
            if let users = getreponse.value(forKey: "usersList") as? NSArray
            {
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
        }
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
        
        cell.lblusername.text = String(format: "%@ %@", userdictionary.value(forKey: "firstName") as! CVarArg, userdictionary.value(forKey: "lastName") as! CVarArg)
        
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
            cell.levelView.layer.borderColor = UIColor.lightGray.cgColor
            cell.levelLbl.textColor = UIColor.lightGray
            cell.arrowLbl.textColor = UIColor.lightGray
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
        personlbl.frame = CGRect(x: CGFloat(20.0), y: CGFloat(0.0), width: CGFloat(30.0), height: CGFloat(headerheight))
        personlbl.font = UIFont(name: Workaa_Font, size: CGFloat(25.0))
        personlbl.backgroundColor = UIColor.clear
        personlbl.textColor = UIColor.black
        personlbl.text = adduserIcon
        headerView.addSubview(personlbl)
        
        let memberslbl = UILabel()
        memberslbl.frame = CGRect(x: CGFloat(personlbl.frame.maxX+10.0), y: CGFloat(0.0), width: CGFloat(110.0), height: CGFloat(headerheight))
        memberslbl.font = UIFont(name: LatoRegular, size: CGFloat(17.0))
        memberslbl.backgroundColor = UIColor.clear
        memberslbl.textColor = UIColor.black
        memberslbl.text = "Add Members"
        headerView.addSubview(memberslbl)
        
        let plusiconbtn = UIButton()
        plusiconbtn.frame = CGRect(x: CGFloat(screenWidth-55.0), y: CGFloat(0.0), width: CGFloat(40.0), height: CGFloat(headerheight))
        plusiconbtn.titleLabel?.font = UIFont(name: Workaa_Font, size: CGFloat(27.0))
        plusiconbtn.backgroundColor = UIColor.clear
        plusiconbtn.setTitleColor(UIColor.darkGray, for: .normal)
        plusiconbtn.setTitle(roundplusIcon, for: .normal)
        plusiconbtn.addTarget(self, action: #selector(GroupDetailsInfoViewController.getUseraction), for: .touchUpInside)
        plusiconbtn.contentHorizontalAlignment = .right
        headerView.addSubview(plusiconbtn)
        
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
