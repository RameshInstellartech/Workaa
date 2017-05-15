//
//  OneToOneChatViewController.swift
//  Workaa
//
//  Created by IN1947 on 27/03/17.
//  Copyright © 2017 IN1947. All rights reserved.
//

import UIKit
import CoreData
import AssetsLibrary
import Photos
import MobileCoreServices
import AVKit

class OneToOneChatViewController: UIViewController, ConnectionProtocol, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, ImageUploadDelegate, ASIHTTPRequestDelegate, ASIProgressDelegate
{
    var teamdictionary = NSDictionary()
    var userdictionary = NSDictionary()
    var alertClass = AlertClass()
    var validationClass = ValidationClass()
    var connectionClass = ConnectionClass()
    var commonmethodClass = CommonMethodClass()
    var selectedAlgorithm: SymmetricCryptorAlgorithm = .aes_256
    private let slp = SwiftLinkPreview()
    var imgData : NSData!
    var imageProgress : ImageUploadProgressView!
    var imagerequest : ASIFormDataRequest!
    var refreshControl = UIRefreshControl()
    var sectionArray = NSMutableArray()
    var msgdictionary = NSMutableDictionary()
    
    @IBOutlet weak var tblChat: UITableView!
    @IBOutlet weak var tvMessageEditor: PlaceholderTextView!
    @IBOutlet weak var conBottomEditor: NSLayoutConstraint!
    @IBOutlet weak var BottomEditorheight: NSLayoutConstraint!
    @IBOutlet weak var attachbtn: UIButton!
    @IBOutlet weak var sendbtn: UIButton!
    
    var pickedImage : UIImage!
    var loadcount = NSInteger()
    var totalcount = NSInteger()
    var pagecount = NSInteger()
    var laststring = String()
    
    @IBOutlet weak var lblOtherUserActivityStatus: UILabel!
    @IBOutlet weak var lblNewsBanner: UILabel!
    var nickname: String!
    var bannerLabelTimer: Timer!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        loadcount = 30
        laststring = "0"
        
        let button = UIButton.init(type: .system)
        button.setImage(UIImage(named: "yellowstar.png"), for: UIControlState.normal)
        button.addTarget(self, action: #selector(self.favmsg), for: UIControlEvents.touchUpInside)
        button.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        let barButton = UIBarButtonItem(customView: button)
        
        let filebutton = UIButton.init(type: .system)
        filebutton.setTitle(filesIcon, for: .normal)
        filebutton.titleLabel?.font = UIFont(name: Workaa_Font, size: 18.0)
        filebutton.addTarget(self, action: #selector(self.getFiles), for: UIControlEvents.touchUpInside)
        filebutton.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        let filebarButton = UIBarButtonItem(customView: filebutton)
        
        self.navigationItem.rightBarButtonItems = [barButton, filebarButton]
        
        print("teamdictionary =>\(teamdictionary)")
        print("userdictionary =>\(userdictionary)")

        NotificationCenter.default.addObserver(self, selector: #selector(GroupViewController.handleKeyboardWillShowNotification(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(GroupViewController.handleKeyboardWillHideNotification(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.getChatDetails), name: NSNotification.Name(rawValue: "DirectChat_Update"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.tablerefresh), name: NSNotification.Name(rawValue: "DirectChat_Refresh"), object: nil)
        
        nickname = "ramesh"
        
        connectionClass.delegate = self
        
        /*-------------------------------------------------------*/
        
        configureTableView()
        //configureNewsBannerLabel()
        //configureOtherUserActivityLabel()
        
        commonmethodClass.delayWithSeconds(0.1, completion: {
        self.loadImageUploadProgress()
        })
        
//        tvMessageEditor.layer.cornerRadius = 5.0
//        tvMessageEditor.layer.masksToBounds = true
//        tvMessageEditor.layer.borderColor = UIColor(red: CGFloat(216.0/255.0), green: CGFloat(216.0/255.0), blue: CGFloat(216.0/255.0), alpha: CGFloat(1.0)).cgColor
//        tvMessageEditor.layer.borderWidth = 1.0
        
        commonmethodClass.delayWithSeconds(0.0, completion: {
            self.getdirectmsg()
            self.getChatDetails()
            self.animateTable()
        })
        
        attachbtn.setTitle(attachIcon, for: .normal)
        sendbtn.setTitle(sendIcon, for: .normal)
        
        self.setRefreshControl()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        self.title = String(format: "%@ %@", userdictionary.value(forKey: "firstName") as! CVarArg,userdictionary.value(forKey: "lastName") as! CVarArg)
        
        navigationController?.navigationBar.barTintColor = greenColor
    }
    
    // MARK: - Viewcontroller Methods
    
    func getdirectmsg()
    {
        if laststring == "0"
        {
            //self.connectionClass.getGroupMsg(groupId: self.groupdictionary.value(forKey: "id") as! String, count: String(format: "%d", pagecount))
        }
    }
    
    func setRefreshControl()
    {
        let attributes = [ NSForegroundColorAttributeName : UIColor.darkGray ] as [String: Any]
        
        refreshControl.tintColor = UIColor.darkGray
        refreshControl.attributedTitle = NSAttributedString(string: "Fetching Older Data ...", attributes: attributes)
        refreshControl.addTarget(self, action: #selector(GroupViewController.loadMoreData(sender:)), for: .valueChanged)
        
        // Add to Table View
        if #available(iOS 10.0, *) {
            self.tblChat.refreshControl = refreshControl
        } else {
            self.tblChat.addSubview(refreshControl)
        }
    }
    
    func favmsg()
    {
        self.title = ""
        
        let favMsgObj = self.storyboard?.instantiateViewController(withIdentifier: "FavMsgViewID") as? FavMsgViewController
        favMsgObj?.userdictionary = userdictionary
        favMsgObj?.chattype = "DirectChat"
        self.navigationController?.pushViewController(favMsgObj!, animated: true)
    }
    
    func getFiles()
    {
        self.title = ""
        
        let filesViewObj = self.storyboard?.instantiateViewController(withIdentifier: "FilesViewID") as? FilesViewController
        filesViewObj?.userdictionary = userdictionary
        filesViewObj?.chattype = "DirectChat"
        self.navigationController?.pushViewController(filesViewObj!, animated: true)
    }
    
    func animateTable()
    {
        tblChat.reloadData()
        
        let cells = tblChat.visibleCells
        let tableHeight: CGFloat = tblChat.bounds.size.height
        
        for i in cells
        {
            let cell: UITableViewCell = i as UITableViewCell
            cell.transform = CGAffineTransform(translationX: 0, y: tableHeight)
        }
        
        var index = 0
        
        for a in cells
        {
            let cell: UITableViewCell = a as UITableViewCell
            UIView.animate(withDuration: 1.5, delay: 0.05 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [], animations: {
            cell.transform = CGAffineTransform(translationX: 0, y: 0);
            }, completion: nil)
        
            index += 1
        }
        
        commonmethodClass.delayWithSeconds(1.0, completion: {
            self.scrollToBottom(animated: true)
        })
        
        if(commonmethodClass.getDirectChatVisibleViewcontroller())
        {
            self.resetcount()
        }
    }
    
    func getChatDetails()
    {
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "OneToOne")
        fetchRequest.returnsObjectsAsFaults = false
        
        //            let userid = NSPredicate(format: "userid = %@", self.userdictionary.value(forKey: "id") as! String)
        let userid = NSPredicate(format: "senderuserid = %@", self.userdictionary.value(forKey: "id") as! String)
        let loginuserid = NSPredicate(format: "loginuserid = %@", self.commonmethodClass.retrieveuserid())
        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [userid, loginuserid])
        fetchRequest.predicate = predicate
        
        totalcount = try! managedContext.count(for: fetchRequest)
        print("count =>\(String(describing: totalcount))")
        if(totalcount>loadcount)
        {
            fetchRequest.fetchOffset = totalcount - loadcount
            fetchRequest.fetchLimit = loadcount
        }
        
        do {
            sectionArray.removeAllObjects()
            msgdictionary.removeAllObjects()
            
            let results =
                try managedContext.fetch(fetchRequest)
            let chatsection = results as! [NSManagedObject]
            for i in 0 ..< chatsection.count
            {
                var msgarray = NSMutableArray()
                
                let chatMessage = chatsection[i]
                let messageDate = String(format: "%@", chatMessage.value(forKey: "date") as! CVarArg)
                let datestring = String(format: "%@", commonmethodClass.convertDateSection(date: messageDate).uppercased())
                //                print("datestring =>\(datestring)")
                if(!sectionArray.contains(datestring))
                {
                    sectionArray.add(datestring)
                }
                
                if((msgdictionary.value(forKey: datestring)) != nil)
                {
                    msgarray = msgdictionary.value(forKey: datestring) as! NSMutableArray
                }
                
                msgarray.add(chatMessage)
                
                msgdictionary.setValue(msgarray, forKey: datestring)
            }
            //            print("msgdictionary =>\(msgdictionary)")
            //            print("sectionArray =>\(sectionArray)")
            
            self.tblChat.reloadData()
        
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    func tablerefresh()
    {
        tblChat.reloadData()
        
        if(commonmethodClass.getDirectChatVisibleViewcontroller())
        {
            self.resetcount()
        }
    }
    
    func resetcount()
    {
        SocketIOManager.sharedInstance.directResetCount() { (messageInfo) -> Void in
            print("Send messageInfo =>\(messageInfo)")
        }
    }
    
    func loadImageUploadProgress()
    {
        imageProgress = Bundle.main.loadNibNamed("ImageUploadProgressView", owner: nil, options: nil)?[0] as! ImageUploadProgressView
        imageProgress.frame = CGRect(x: 0, y: 0, width: screenWidth, height: 70)
        imageProgress.loadProgressView()
        imageProgress.isHidden = true
        self.view.addSubview(imageProgress)
    }
    
    func sendfile(imagedata : Data, filename : String)
    {
        let imageUploadView = self.storyboard?.instantiateViewController(withIdentifier: "ImageUploadViewID") as? ImageUploadViewController
        imageUploadView?.filename = filename
        imageUploadView?.delegate = self
        let navController = UINavigationController(rootViewController: imageUploadView!)
        navController.navigationBar.barTintColor = greenColor
        navController.navigationBar.isTranslucent = false
        navController.navigationBar.tintColor = UIColor.white
        navController.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
        self.present(navController, animated: true, completion: nil)
    }
    
    func imageUploadtoServer(filename : String, comment : String)
    {
        if pickedImage != nil
        {
            imageProgress.setImage(image: pickedImage)
        }
    
        commonmethodClass.delayWithSeconds(0.5, completion: {
        self.imageProgress.showProgressView()
        self.commonmethodClass.delayWithSeconds(0.5, completion: {
            self.FileSendToServer(userid: self.userdictionary.value(forKey: "id") as! String, imageData: self.imgData as Data, imagesize: String(self.imgData.length), filename: filename, caption: comment)
            })
        })
    }
    
    func fileUploadtoServer(filename : String, comment : String)
    {
        commonmethodClass.delayWithSeconds(0.5, completion: {
        self.imageProgress.showProgressView()
        self.commonmethodClass.delayWithSeconds(0.5, completion: {
            self.FileSendToServer(userid: self.userdictionary.value(forKey: "id") as! String, imageData: appDelegate.mediadata as Data, imagesize: String(appDelegate.mediadata.length), filename: filename, caption: comment)
            })
        })
    }
    
    func imageUpload(image : UIImage)
    {
        let imageUploadView = self.storyboard?.instantiateViewController(withIdentifier: "ImageUploadViewID") as? ImageUploadViewController
        imageUploadView?.uploadimage = image
        imageUploadView?.delegate = self
        let navController = UINavigationController(rootViewController: imageUploadView!)
        navController.navigationBar.barTintColor = greenColor
        navController.navigationBar.isTranslucent = false
        navController.navigationBar.tintColor = UIColor.white
        navController.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
        self.present(navController, animated: true, completion: nil)
    }
    
    func startTyping()
    {
        //SocketIOManager.sharedInstance.sendStartTypingMessage(groupid: groupdictionary.value(forKey: "GROUPID") as! String, typing: "1")
    }
    
    func stopTyping()
    {
        //SocketIOManager.sharedInstance.sendStopTypingMessage(groupid: groupdictionary.value(forKey: "GROUPID") as! String, typing: "0")
    }
    
    func configureTableView()
    {
        tblChat.delegate = self
        tblChat.dataSource = self
        tblChat.register(UINib(nibName: "ChatCell", bundle: nil), forCellReuseIdentifier: "idCellChat")
        tblChat.estimatedRowHeight = 90.0
        tblChat.rowHeight = UITableViewAutomaticDimension
        tblChat.tableFooterView = UIView(frame: .zero)
    }
    
    func configureNewsBannerLabel()
    {
        lblNewsBanner.layer.cornerRadius = 15.0
        lblNewsBanner.clipsToBounds = true
        lblNewsBanner.alpha = 0.0
    }
    
    func configureOtherUserActivityLabel()
    {
        lblOtherUserActivityStatus.isHidden = true
        lblOtherUserActivityStatus.text = ""
    }
    
    func scrollToBottom(animated: Bool)
    {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300))
        {
            let numberOfSections = self.tblChat.numberOfSections
            
            if numberOfSections > 0
            {
                let numberOfRows = self.tblChat.numberOfRows(inSection: numberOfSections-1)
                
                if numberOfRows > 0
                {
                    let indexPath = IndexPath(row: numberOfRows-1, section: (numberOfSections-1))
                    self.tblChat.scrollToRow(at: indexPath, at: .bottom, animated: animated)
                }
            }
        }
    }
    
    func showBannerLabelAnimated()
    {
        UIView.animate(withDuration: 0.75, animations: { () -> Void in
            self.lblNewsBanner.alpha = 1.0
        }) { (finished) -> Void in
            self.bannerLabelTimer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(GroupViewController.hideBannerLabel), userInfo: nil, repeats: false)
        }
    }
    
    func hideBannerLabel()
    {
        if bannerLabelTimer != nil
        {
            bannerLabelTimer.invalidate()
            bannerLabelTimer = nil
        }
        
        UIView.animate(withDuration: 0.75, animations: { () -> Void in
            self.lblNewsBanner.alpha = 0.0
        }) { (finished) -> Void in}
    }
    
    func dismissKeyboard()
    {
        if tvMessageEditor.isFirstResponder
        {
            tvMessageEditor.resignFirstResponder()
            
            stopTyping()
        }
    }
    
    func ShareMessage(chatdetails : NSManagedObject)
    {
        let sharegroup = UIAlertController(title: "Share Message", message: "", preferredStyle: UIAlertControllerStyle.alert)
        
        sharegroup.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
        sharegroup.addAction(UIAlertAction(title: "Share", style: UIAlertActionStyle.default, handler: { (action) -> Void in
        
        let shareTxtField = sharegroup.textFields![0] as UITextField
        print("shareTxtField =>\(String(describing: shareTxtField.text))")
        
        var msgId = chatdetails.value(forKey: "msgid") as? String
        var cmtid = ""
        
        if let cmtDetails = chatdetails.value(forKey: "commentdetails") as? NSDictionary
        {
            cmtid = (cmtDetails.value(forKey: "cmtid") as? String)!
            msgId = (cmtDetails.value(forKey: "cmtid") as? String)!
        }
        
        if (chatdetails.value(forKey: "sharedetails") as? NSDictionary) != nil
        {
            cmtid = ""
            msgId = chatdetails.value(forKey: "msgid") as? String
        }
        
        print("cmtid =>\(cmtid)")
        
        SocketIOManager.sharedInstance.shareOneToOneMessage(message: shareTxtField.text!, msgId: msgId!, userid: self.userdictionary.value(forKey: "id") as! String) { (messageInfo) -> Void in
        
            print("Share messageInfo =>\(messageInfo)")
            
            msgId = chatdetails.value(forKey: "msgid") as? String
        
            if let getreponse = messageInfo.value(forKey: "apiResponse") as? NSDictionary
            {
                if let statuscode = getreponse.value(forKey: "status") as? NSInteger
                {
                    if statuscode==1
                    {
                        if let datareponse = getreponse.value(forKey: "data") as? NSDictionary
                        {
                            if let shareid = datareponse.value(forKey: "messageId") as? String
                            {
                                let userid = chatdetails.value(forKey: "userid") as? String
                                let username = chatdetails.value(forKey: "username") as? String
                                var message = chatdetails.value(forKey: "message") as? String
                                let sharedate = chatdetails.value(forKey: "date") as? String
                                let date = datareponse.value(forKey: "time") as? String
                                let teamid = chatdetails.value(forKey: "teamid") as? String
                                var imagepath = chatdetails.value(forKey: "imagepath") as? String
                                let imagetitle = chatdetails.value(forKey: "imagetitle") as? String
                                let filesize = chatdetails.value(forKey: "filesize") as? String
                                let filecaption = chatdetails.value(forKey: "filecaption") as? String
        
                                print("message =>\(String(describing: message))")
                                print("imagepath =>\(String(describing: imagepath))")
        
                                var chatdetailsdict : NSDictionary!
        
                                let sharedetails = ["shareid":msgId!, "sharemessage":shareTxtField.text!, "sharename":username!, "sharedate":sharedate!, "shareuserid":userid!, "shareteamid":teamid!] as [String : Any]
        
                                if let shareDetails = chatdetails.value(forKey: "sharedetails") as? NSDictionary
                                {
                                    print("shareDetails =>\(shareDetails)")
                                    let sharemessage = shareDetails.value(forKey: "sharemessage") as? String
        
                                    if sharemessage != ""
                                    {
                                        message = sharemessage
                                        imagepath = ""
                                    }
                                }
                                
                                if let cmtDetails = chatdetails.value(forKey: "commentdetails") as? NSDictionary
                                {
                                    if cmtid == ""
                                    {
                                        chatdetailsdict = ["userid":self.commonmethodClass.retrieveuserid(), "username":self.commonmethodClass.retrieveusername(), "message":message!, "date":date!, "teamid":self.commonmethodClass.retrieveteamid(), "imagepath":imagepath!, "msgid": shareid, "type": "share", "commentdetails":"", "sharedetails":sharedetails, "imagetitle":imagetitle!, "filesize":filesize!, "filecaption":filecaption!, "sendertype":"right", "senderuserid":self.userdictionary.value(forKey: "id") as! String, "starmsg":"0"]
                                    }
                                    else
                                    {
                                        chatdetailsdict = ["userid":self.commonmethodClass.retrieveuserid(), "username":self.commonmethodClass.retrieveusername(), "message":message!, "date":date!, "teamid":self.commonmethodClass.retrieveteamid(), "imagepath":imagepath!, "msgid": shareid, "type": "share", "commentdetails":cmtDetails, "sharedetails":sharedetails, "imagetitle":imagetitle!, "filesize":filesize!, "filecaption":filecaption!, "sendertype":"right", "senderuserid":self.userdictionary.value(forKey: "id") as! String, "starmsg":"0"]
                                    }
                                }
                                else
                                {
                                    chatdetailsdict = ["userid":self.commonmethodClass.retrieveuserid(), "username":self.commonmethodClass.retrieveusername(), "message":message!, "date":date!, "teamid":self.commonmethodClass.retrieveteamid(), "imagepath":imagepath!, "msgid": shareid, "type": "share", "commentdetails":"", "sharedetails":sharedetails, "imagetitle":imagetitle!, "filesize":filesize!, "filecaption":filecaption!, "sendertype":"right", "senderuserid":self.userdictionary.value(forKey: "id") as! String, "starmsg":"0"]
                                }
        
                                appDelegate.saveOneToOneChatDetails(chatdetails: chatdetailsdict)
                                
                                self.scrollToBottom(animated: true)
                            }
                        }
                    }
                    else
                    {
                        print("MSG ERROR")
                    }
                }
            }
        }
        
        }))
        
        sharegroup.addTextField(configurationHandler: {(textField: UITextField!) in
            textField.placeholder = "Add a message"
        })
        
        rootViewController?.present(sharegroup, animated: true, completion: nil)
    }
    
    func StarMessage(msgId : String, cmtId : String)
    {
        var idstring = ""
        if cmtId == ""
        {
            idstring = msgId
        }
        else
        {
            idstring = cmtId
        }
        
        SocketIOManager.sharedInstance.directstarMessage(msgId: idstring, uid: userdictionary.value(forKey: "id") as! String) { (messageInfo) -> Void in
            
            print("Send messageInfo =>\(messageInfo)")
            
            if let getreponse = messageInfo.value(forKey: "apiResponse") as? NSDictionary
            {
                if let statuscode = getreponse.value(forKey: "status") as? NSInteger
                {
                    if statuscode==1
                    {
                        do {
                            let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "OneToOne")
                            fetchRequest.returnsObjectsAsFaults = false
                            
                            let predicate = NSPredicate(format: "msgid = %@", msgId)
                            fetchRequest.predicate = predicate
                            
                            let results =
                                try managedContext.fetch(fetchRequest)
                            let messages = results as! [NSManagedObject]
                            if messages.count>0
                            {
                                for i in 0 ..< messages.count
                                {
                                    let getmanageObj = messages[i]
                                    if let cmtDetails = getmanageObj.value(forKey: "commentdetails") as? NSDictionary
                                    {
                                        if let shareDetails = getmanageObj.value(forKey: "sharedetails") as? NSDictionary
                                        {
                                            print("shareDetails =>\(shareDetails)")
                                            
                                            if cmtId == ""
                                            {
                                                getmanageObj.setValue("1", forKey: "starmsg")
                                            }
                                        }
                                        else
                                        {
                                            let cmtIdstring = String(format: "%@", cmtDetails.value(forKey: "cmtid") as! CVarArg)
                                            if cmtId == cmtIdstring
                                            {
                                                let commentdetails = cmtDetails.mutableCopy() as? NSMutableDictionary
                                                commentdetails?.setValue("1", forKey: "starmsg")
                                                getmanageObj.setValue(commentdetails, forKey: "commentdetails")
                                                self.updatestarcomment(cmtid: cmtIdstring, starmsg: "1")
                                                
                                                break
                                            }
                                        }
                                    }
                                    else
                                    {
                                        if cmtId == ""
                                        {
                                            getmanageObj.setValue("1", forKey: "starmsg")
                                        }
                                    }
                                }
                                
                                do {
                                    try managedContext.save()
                                    self.tblChat.reloadData()
                                } catch let error as NSError  {
                                    print("Could not save \(error), \(error.userInfo)")
                                }
                            }
                            
                        } catch let error as NSError {
                            print("Could not fetch \(error), \(error.userInfo)")
                        }
                    }
                }
            }
        }
    }
    
    func RemoveStarMessage(msgId : String, cmtId : String)
    {
        var idstring = ""
        if cmtId == ""
        {
            idstring = msgId
        }
        else
        {
            idstring = cmtId
        }
        
        SocketIOManager.sharedInstance.directRemoveFav(idstring: idstring, uid: userdictionary.value(forKey: "id") as! String) { (messageInfo) -> Void in
            
            print("Send messageInfo =>\(messageInfo)")
            
            if let getreponse = messageInfo.value(forKey: "apiResponse") as? NSDictionary
            {
                if let statuscode = getreponse.value(forKey: "status") as? NSInteger
                {
                    if statuscode==1
                    {
                        do {
                            let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "OneToOne")
                            fetchRequest.returnsObjectsAsFaults = false
                            
                            let predicate = NSPredicate(format: "msgid = %@", msgId)
                            fetchRequest.predicate = predicate
                            
                            let results =
                                try managedContext.fetch(fetchRequest)
                            let messages = results as! [NSManagedObject]
                            if messages.count>0
                            {
                                for i in 0 ..< messages.count
                                {
                                    let getmanageObj = messages[i]
                                    if let cmtDetails = getmanageObj.value(forKey: "commentdetails") as? NSDictionary
                                    {
                                        if let shareDetails = getmanageObj.value(forKey: "sharedetails") as? NSDictionary
                                        {
                                            print("shareDetails =>\(shareDetails)")
                                            
                                            if cmtId == ""
                                            {
                                                getmanageObj.setValue("0", forKey: "starmsg")
                                            }
                                        }
                                        else
                                        {
                                            let cmtIdstring = String(format: "%@", cmtDetails.value(forKey: "cmtid") as! CVarArg)
                                            if cmtId == cmtIdstring
                                            {
                                                let commentdetails = cmtDetails.mutableCopy() as? NSMutableDictionary
                                                commentdetails?.setValue("0", forKey: "starmsg")
                                                getmanageObj.setValue(commentdetails, forKey: "commentdetails")
                                                self.updatestarcomment(cmtid: cmtIdstring, starmsg: "0")
                                                
                                                break
                                            }
                                        }
                                    }
                                    else
                                    {
                                        if cmtId == ""
                                        {
                                            getmanageObj.setValue("0", forKey: "starmsg")
                                        }
                                    }
                                }
                                
                                do {
                                    try managedContext.save()
                                    self.tblChat.reloadData()
                                } catch let error as NSError  {
                                    print("Could not save \(error), \(error.userInfo)")
                                }
                            }
                            
                        } catch let error as NSError {
                            print("Could not fetch \(error), \(error.userInfo)")
                        }
                    }
                }
            }
        }
    }
    
    func updatestarcomment(cmtid : String, starmsg : String)
    {
        do {
            let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "OneToOneComment")
            fetchRequest.returnsObjectsAsFaults = false
            
            let predicate = NSPredicate(format: "cmtid = %@", cmtid)
            fetchRequest.predicate = predicate
            
            let results =
                try managedContext.fetch(fetchRequest)
            let messages = results as! [NSManagedObject]
            if messages.count>0
            {
                let getmanageObj = messages[0]
                getmanageObj.setValue(starmsg, forKey: "starmsg")
                
                do {
                    try managedContext.save()
                } catch let error as NSError  {
                    print("Could not save \(error), \(error.userInfo)")
                }
            }
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    func EditMessage(message : String, msgId : String)
    {
        let editgroup = UIAlertController(title: "Editing Message", message: "", preferredStyle: UIAlertControllerStyle.alert)
        
        editgroup.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
        editgroup.addAction(UIAlertAction(title: "Save", style: UIAlertActionStyle.default, handler: { (action) -> Void in
        
        let editTxtField = editgroup.textFields![0] as UITextField
        print("editTxtField =>\(String(describing: editTxtField.text))")
        
        if (editTxtField.text?.characters.count)! > 0
        {
            SocketIOManager.sharedInstance.oneTooneeditMessage(message: editTxtField.text!, msgId: msgId, userid: self.userdictionary.value(forKey: "id") as! String) { (messageInfo) -> Void in
        
                print("Send messageInfo =>\(messageInfo)")
                
                if let getreponse = messageInfo.value(forKey: "apiResponse") as? NSDictionary
                {
                    if let statuscode = getreponse.value(forKey: "status") as? NSInteger
                    {
                        if statuscode==1
                        {
                            let editmessage = String(format: "%@ (edited)", editTxtField.text!)
        
                            do {
                                let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "OneToOne")
                                fetchRequest.returnsObjectsAsFaults = false
        
                                let predicate = NSPredicate(format: "msgid = %@", msgId)
                                fetchRequest.predicate = predicate
        
                                let results =
                                    try managedContext.fetch(fetchRequest)
                                let editMessages = results as! [NSManagedObject]
                                if editMessages.count>0
                                {
                                    let getmanageObj = editMessages[0]
        
                                    if let shareDetails = getmanageObj.value(forKey: "sharedetails") as? NSDictionary
                                    {
                                        let shareid = shareDetails.value(forKey: "shareid") as? String
                                        let sharename = shareDetails.value(forKey: "sharename") as? String
                                        let sharedate = shareDetails.value(forKey: "sharedate") as? String
                                        let shareuserid = shareDetails.value(forKey: "shareuserid") as? String
                                        let shareteamid = shareDetails.value(forKey: "shareteamid") as? String
        
                                        let sharedetails = ["shareid":shareid!, "sharemessage":editmessage, "sharename":sharename!, "sharedate":sharedate!, "shareuserid":shareuserid!, "shareteamid":shareteamid!] as [String : Any]
        
                                        getmanageObj.setValue(sharedetails, forKey: "sharedetails")
                                    }
                                    else
                                    {
                                        getmanageObj.setValue(editmessage, forKey: "message")
                                    }
        
                                    do {
                                        try managedContext.save()
                                        self.tblChat.reloadData()
                                    } catch let error as NSError  {
                                        print("Could not save \(error), \(error.userInfo)")
                                    }
                                }
        
        } catch let error as NSError {
        print("Could not fetch \(error), \(error.userInfo)")
        }
        }
        }
        }
            }
        }
        }))
        
        editgroup.addTextField(configurationHandler: {(textField: UITextField!) in
            textField.text = message
            textField.text = textField.text?.replacingOccurrences(of: "(edited)", with: "", options: NSString.CompareOptions.literal, range:nil)
        })
        
        rootViewController?.present(editgroup, animated: true, completion: nil)
    }
    
    func DeleteMessage(msgId : NSString)
    {
        let alert = UIAlertController(title: "Are you sure you want to delete this message? This cannot be undone.", message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Yes, Delete the Message", style: .destructive , handler:{ (UIAlertAction)in
        
            SocketIOManager.sharedInstance.oneToonedeleteMessage(msgId: msgId as String, userid: self.userdictionary.value(forKey: "id") as! String) { (messageInfo) -> Void in
        
                print("Delete messageInfo =>\(messageInfo)")
        
                if let getreponse = messageInfo.value(forKey: "apiResponse") as? NSDictionary
                {
                    if let statuscode = getreponse.value(forKey: "status") as? NSInteger
                    {
                        if statuscode==1
                        {
                            do {
                                let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "OneToOne")
                                fetchRequest.returnsObjectsAsFaults = false
        
                                let predicate = NSPredicate(format: "msgid = %@", msgId)
                                fetchRequest.predicate = predicate
        
                                let results =
                                    try managedContext.fetch(fetchRequest)
                                let deleteMessages = results as! [NSManagedObject]
                                print("deleteMessages =>\(deleteMessages)")
                                if deleteMessages.count>0
                                {
                                    for i in 0 ..< deleteMessages.count
                                    {
                                        let getmanageObj = deleteMessages[i]
                                        managedContext.delete(getmanageObj);
                                    }
        
                                    do {
                                        try managedContext.save()
                                        self.getChatDetails()
                                    } catch let error as NSError  {
                                        print("Could not save \(error), \(error.userInfo)")
                                    }
                                }
        
                            } catch let error as NSError {
                                print("Could not fetch \(error), \(error.userInfo)")
                            }
                        }
                    }
                }
            }
        
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler:{ (UIAlertAction)in
            print("User click Dismiss button")
        }))
        
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
    
    // MARK: - ImageUpload Methods
    
    func FileSendToServer(userid:String, imageData:Data, imagesize:String, filename : String, caption:String)
    {
        let urlpath = String(format: "%@%@", kChatBaseURL,konetoonesendFile)
        print("urlpath =>\(urlpath)")
        
        imagerequest = ASIFormDataRequest(url: NSURL(string: urlpath)! as URL)
        imagerequest.requestMethod = "POST"
        imagerequest.delegate = self
        imagerequest.uploadProgressDelegate = self
        imagerequest.addPostValue(commonmethodClass.retrieveUsernameToken(), forKey: "token")
        imagerequest.addPostValue(userid as NSObjectProtocol!, forKey: "uid")
        imagerequest.addData(imageData, withFileName: filename, andContentType: "multipart/form-data", forKey: "image")
        imagerequest.addPostValue(imagesize as NSObjectProtocol!, forKey: "imagesize")
        imagerequest.addPostValue(caption as NSObjectProtocol!, forKey: "caption")
        imagerequest.addHeader("Accept", value: "application/json")
        imagerequest.startAsynchronous()
    }
    
    func requestFinished(_ request: ASIHTTPRequest!)
    {
        print("request.responseString() = \(request.responseString())")
        
        if request.responseString() != nil && !request.responseString().isEmpty
        {
            if (request.responseString().jsonValue() as? NSDictionary) != nil
            {
                let reponsedictionary = request.responseString().jsonValue() as! NSDictionary
                print("reponsedictionary = \(reponsedictionary)")
                
                if reponsedictionary.count>0
                {
                    if let getreponse = reponsedictionary.value(forKey: "apiResponse") as? NSDictionary
                    {
                        if let statuscode = getreponse.value(forKey: "status") as? NSInteger
                        {
                            if statuscode==1
                            {
                                imageProgress.uploadCompleted()
                                commonmethodClass.delayWithSeconds(0.5, completion: {
                                    self.imageProgress.animateView(self.imageProgress, withAnimationType: kCATransitionFromTop)
                                    self.commonmethodClass.delayWithSeconds(0.5, completion: {
                                        self.GetReponseMethod(reponse: getreponse)
                                    })
                                })
                            }
                            else
                            {
                                if let errormsg = getreponse.value(forKey: "MSG") as? String
                                {
                                    alertClass.showAlert(alerttitle: "Info", alertmsg: errormsg)
                                }
                            }
                        }
                    }
                }
            }
            else
            {
                alertClass.showAlert(alerttitle: "Info", alertmsg: servererrormsg)
            }
        }
        else
        {
            alertClass.showAlert(alerttitle: "Info", alertmsg: servererrormsg)
        }
    }
    
    func requestFailed(_ request: ASIHTTPRequest!)
    {
        var responseError : NSError?
        responseError = request.error as NSError?
        
        alertClass.showAlert(alerttitle: "Info", alertmsg: (responseError?.localizedDescription)!)
        
        self.cancelrequest()
    }
    
    func setProgress(_ newProgress: Float)
    {
        print("newProgress =>\(newProgress)")
        imageProgress.setProgress(progress: newProgress)
    }
    
    func cancelrequest()
    {
        commonmethodClass.delayWithSeconds(0.1, completion: {
            if self.imageProgress.progressView.progress < 1.0
            {
                self.imagerequest.cancel()
                self.imagerequest.delegate = nil
                self.imageProgress.animateView(self.imageProgress, withAnimationType: kCATransitionFromTop)
            }
        })
    }
    
    // MARK: - Actions Methods
    
    func loadMoreData(sender: UIRefreshControl)
    {
        commonmethodClass.delayWithSeconds(1.0, completion: {
            self.loadcount = self.loadcount + 30
            self.pagecount = self.pagecount + 1
            self.getdirectmsg()
            self.getChatDetails()
            self.refreshControl.endRefreshing()
        })
    }
    
    @IBAction func sendMessage(sender: AnyObject)
    {
        if tvMessageEditor.text.characters.count > 0
        {
            SocketIOManager.sharedInstance.sendOneToOneMessage(message: tvMessageEditor.text!, userid: userdictionary.value(forKey: "id") as! String) { (messageInfo) -> Void in
        
                print("Send messageInfo =>\(messageInfo)")
                
                if let getreponse = messageInfo.value(forKey: "apiResponse") as? NSDictionary
                {
                    if let statuscode = getreponse.value(forKey: "status") as? NSInteger
                    {
                        if statuscode==1
                        {
                            if let datareponse = getreponse.value(forKey: "data") as? NSDictionary
                            {
                                let chatdetails = ["userid":self.commonmethodClass.retrieveuserid(), "username":self.commonmethodClass.retrieveusername(), "message":self.tvMessageEditor.text!, "date":String(format: "%@", datareponse.value(forKey: "time") as! CVarArg), "teamid":self.commonmethodClass.retrieveteamid(), "imagepath":"", "msgid": String(format: "%@", datareponse.value(forKey: "messageId") as! CVarArg), "imagetitle":"", "filesize":"", "filecaption":"", "type":"message", "sendertype":"right", "senderuserid":self.userdictionary.value(forKey: "id") as! String, "starmsg":"0"] as [String : Any]
        
                                appDelegate.saveOneToOneChatDetails(chatdetails: chatdetails as NSDictionary)
        
                                self.tvMessageEditor.text = ""
                                self.tvMessageEditor.resignFirstResponder()
        
                                UIView.animate(withDuration: 0.25, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
        
                                    self.BottomEditorheight.constant = 50.0
                                    self.view.layoutIfNeeded()
        
                                }, completion: nil)
                            }
                        }
                        else
                        {
                            print("MSG ERROR")
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func attachment(sender: AnyObject)
    {
        alertClass.attachmentAlert()
    }
    
    func camera()
    {
        if UIImagePickerController.isSourceTypeAvailable(
        UIImagePickerControllerSourceType.camera)
        {
            let imagePicker = UIImagePickerController()
            imagePicker.mediaTypes = [kUTTypeImage as String, kUTTypeMovie as String]
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
            imagePicker.mediaTypes = [kUTTypeImage as String, kUTTypeMovie as String]
            imagePicker.delegate = self
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func MediaAction(sender: UIButton)
    {
        print("MediaAction =>\(sender.tag)")
        print("MediaAction =>\(String(describing: sender.currentTitle))")
    }
    
    func longPress(_ longPressGestureRecognizer: UILongPressGestureRecognizer)
    {
        if longPressGestureRecognizer.state == UIGestureRecognizerState.began
        {
            let touchPoint = longPressGestureRecognizer.location(in: tblChat)
            if let indexPath = tblChat.indexPathForRow(at: touchPoint)
            {
                let datestring = String(format: "%@", sectionArray.object(at: indexPath.section) as! CVarArg)
                let msgArray = msgdictionary.value(forKey: datestring) as! NSMutableArray
                let currentChatMessage = msgArray[indexPath.row] as! NSManagedObject
//                _ = currentChatMessage.value(forKey: "imagepath") as? NSString
//                let userid = String(format: "%@", currentChatMessage.value(forKey: "userid") as! CVarArg)
                let msgId = currentChatMessage.value(forKey: "msgid") as? NSString
                var message = currentChatMessage.value(forKey: "message") as? String
                let chattype = currentChatMessage.value(forKey: "type") as! String
                let sendertype = currentChatMessage.value(forKey: "sendertype") as! String
                let favstring = String(format: "%@", currentChatMessage.value(forKey: "starmsg") as! CVarArg)

                if chattype == "share"
                {
                    var starmsg = "Star Message"
                    if favstring == "1"
                    {
                        starmsg = "Remove Star"
                    }
                    
                    let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
                    
                    alert.addAction(UIAlertAction(title: "Share Message", style: .default , handler:{ (UIAlertAction)in
                        self.ShareMessage(chatdetails: currentChatMessage)
                    }))
                    
                    alert.addAction(UIAlertAction(title: starmsg, style: .default , handler:{ (UIAlertAction)in
                        if favstring == "1"
                        {
                            self.RemoveStarMessage(msgId: msgId! as String, cmtId: "")
                        }
                        else
                        {
                            self.StarMessage(msgId: msgId! as String, cmtId: "")
                        }
                    }))
                    
                    if sendertype == "right"
                    {
                        alert.addAction(UIAlertAction(title: "Edit Message", style: .default , handler:{ (UIAlertAction)in
                            
                            if let shareDetails = currentChatMessage.value(forKey: "sharedetails") as? NSDictionary
                            {
                                message = shareDetails.value(forKey: "sharemessage") as? String
                                
                                self.EditMessage(message: message!, msgId: msgId! as String)
                            }
                            else
                            {
                                self.EditMessage(message: message!, msgId: msgId! as String)
                            }
                            
                        }))
                        
                        alert.addAction(UIAlertAction(title: "Delete Message", style: .destructive , handler:{ (UIAlertAction)in
                            
                            self.DeleteMessage(msgId: msgId!)
                            
                        }))
                    }
                    
                    alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler:{ (UIAlertAction)in
                        print("User click Dismiss button")
                    }))
                    
                    self.present(alert, animated: true, completion: {
                        print("completion block")
                    })
                }
                else
                {
                    if let cmtDetails = currentChatMessage.value(forKey: "commentdetails") as? NSDictionary
                    {
                        let cmtfavstring = String(format: "%@", cmtDetails.value(forKey: "starmsg") as! CVarArg)
                        let cmtidstring = String(format: "%@", cmtDetails.value(forKey: "cmtid") as! CVarArg)
                        
                        var starmsg = "Star Comment"
                        if cmtfavstring == "1"
                        {
                            starmsg = "Remove Star"
                        }
                        
                        print("cmtDetails =>\(cmtDetails)")
                        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

                        alert.addAction(UIAlertAction(title: "Share Message", style: .default , handler:{ (UIAlertAction)in
                            self.ShareMessage(chatdetails: currentChatMessage)
                        }))
        
                        alert.addAction(UIAlertAction(title: starmsg, style: .default , handler:{ (UIAlertAction)in
                            if cmtfavstring == "1"
                            {
                                self.RemoveStarMessage(msgId: msgId! as String, cmtId: cmtidstring)
                            }
                            else
                            {
                                self.StarMessage(msgId: msgId! as String, cmtId: cmtidstring)
                            }
                        }))
                        
                        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler:{ (UIAlertAction)in
                            print("User click Dismiss button")
                        }))
        
                        self.present(alert, animated: true, completion: {
                            print("completion block")
                        })
                    }
                    else
                    {
                        if chattype == "message"
                        {
                            var starmsg = "Star Message"
                            if favstring == "1"
                            {
                                starmsg = "Remove Star"
                            }
                            
                            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
                            
                            alert.addAction(UIAlertAction(title: "Share Message", style: .default , handler:{ (UIAlertAction)in
                                self.ShareMessage(chatdetails: currentChatMessage)
                            }))
                            
                            alert.addAction(UIAlertAction(title: starmsg, style: .default , handler:{ (UIAlertAction)in
                                if favstring == "1"
                                {
                                    self.RemoveStarMessage(msgId: msgId! as String, cmtId: "")
                                }
                                else
                                {
                                    self.StarMessage(msgId: msgId! as String, cmtId: "")
                                }
                            }))
                            
                            if sendertype == "right"
                            {
                                alert.addAction(UIAlertAction(title: "Edit Message", style: .default , handler:{ (UIAlertAction)in
        
                                    if let shareDetails = currentChatMessage.value(forKey: "sharedetails") as? NSDictionary
                                    {
                                        message = shareDetails.value(forKey: "sharemessage") as? String
        
                                        self.EditMessage(message: message!, msgId: msgId! as String)
                                    }
                                    else
                                    {
                                        self.EditMessage(message: message!, msgId: msgId! as String)
                                    }
        
                                }))
                
                                alert.addAction(UIAlertAction(title: "Delete Message", style: .destructive , handler:{ (UIAlertAction)in
        
                                    self.DeleteMessage(msgId: msgId!)
        
                                }))
                            }
                            
                            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler:{ (UIAlertAction)in
                                print("User click Dismiss button")
                            }))
                            
                            self.present(alert, animated: true, completion: {
                                print("completion block")
                            })
                        }
                        else
                        {
                            var starmsg = "Star File"
                            if favstring == "1"
                            {
                                starmsg = "Remove Star"
                            }
                            
                            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
                            
                            alert.addAction(UIAlertAction(title: "Share File", style: .default , handler:{ (UIAlertAction)in
                                self.ShareMessage(chatdetails: currentChatMessage)
                            }))
                            
                            alert.addAction(UIAlertAction(title: starmsg, style: .default , handler:{ (UIAlertAction)in
                                if favstring == "1"
                                {
                                    self.RemoveStarMessage(msgId: msgId! as String, cmtId: "")
                                }
                                else
                                {
                                    self.StarMessage(msgId: msgId! as String, cmtId: "")
                                }
                            }))
                            
                            if sendertype == "right"
                            {
                                alert.addAction(UIAlertAction(title: "Delete File", style: .destructive , handler:{ (UIAlertAction)in
                                    self.DeleteMessage(msgId: msgId!)
                                }))
                            }
                            
                            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler:{ (UIAlertAction)in
                                print("User click Dismiss button")
                            }))
                            
                            self.present(alert, animated: true, completion: {
                                print("completion block")
                            })
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - ReponseDelegate Methods
    
    func GetFailureReponseMethod(errorreponse: String)
    {
        print("GetFailureReponseMethod")
    }
    
    func GetReponseMethod(reponse : NSDictionary)
    {
        print("reponse => \(reponse)")
    
        if let datareponse = reponse.value(forKey: "data") as? NSDictionary
        {
            if let filedictionary = datareponse.value(forKey: "file") as? NSDictionary
            {
                if let imagepath = filedictionary.value(forKey: "path") as? String
                {
                    var filesize : String!
                    var filetype : String!
                    filesize = ""
                    filetype = "image"
    
                    if appDelegate.mediadata != nil
                    {
                        if appDelegate.mediadata.length > 0
                        {
                            let formatter = ByteCountFormatter()
                            formatter.allowedUnits = ByteCountFormatter.Units.useAll
                            filesize = formatter.string(fromByteCount: Int64((appDelegate.mediadata.length)))
                            print("filesize =>\(filesize)")
                            filetype = "file"
                        }
                    }
                    
                    let chatdetails = ["userid":self.commonmethodClass.retrieveuserid(), "username":self.commonmethodClass.retrieveusername(), "message":"", "date":String(format: "%@", datareponse.value(forKey: "time") as! CVarArg), "teamid":self.commonmethodClass.retrieveteamid(), "imagepath":imagepath, "msgid":String(format: "%@", datareponse.value(forKey: "messageId") as! CVarArg), "imagetitle":String(format: "%@", filedictionary.value(forKey: "title") as! CVarArg), "filesize":filesize, "filecaption":String(format: "%@", filedictionary.value(forKey: "caption") as! CVarArg), "type":filetype, "sendertype":"right", "senderuserid":self.userdictionary.value(forKey: "id") as! String, "starmsg":"0"] as [String : Any]
    
                    let fileUrl = NSURL(string: imagepath)
    
                    if pickedImage != nil
                    {
                        let resizeimage : UIImage
    
                        if (pickedImage.size.width)>screenWidth
                        {
                            resizeimage = pickedImage.resizeWith(width: screenWidth)!
                        }
                        else
                        {
                            resizeimage = pickedImage
                        }
    
                        print("resizeimage => \(resizeimage)")
    
                        appDelegate.createfilefolder(imageData: (resizeimage.lowestQualityJPEGNSData), imagepath: (fileUrl?.lastPathComponent)!)
                        pickedImage = nil
                        imageProgress.imageView.image = nil
                    }
                    else
                    {
                        if appDelegate.mediadata != nil
                        {
                            if appDelegate.mediadata.length > 0
                            {
                                appDelegate.createfilefolder(imageData: appDelegate.mediadata, imagepath: (fileUrl?.lastPathComponent)!)
                                appDelegate.mediadata = nil
                            }
                        }
                    }
    
                    appDelegate.saveOneToOneChatDetails(chatdetails: chatdetails as NSDictionary)
                    
                    self.scrollToBottom(animated: true)
                }
            }
        }
    }
    
    // MARK: - UIImagePickerControllerDelegate Methods
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        dismiss(animated: true, completion: nil)
    
        if let pickImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
            print("pickImage => \(pickImage)")
    
            pickedImage = pickImage
    
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
    
                        self.imageUpload(image: self.pickedImage)
                    }
                }
            }
            else
            {
                let imageData = UIImageJPEGRepresentation(pickedImage, 1.0)
                print("imageData => \(String(describing: imageData?.count))")
    
                self.imgData = imageData as NSData!
    
                self.imageUpload(image: self.pickedImage)
            }
        }
        else
        {
            if let pickmediaurl = info[UIImagePickerControllerMediaURL] as? NSURL
            {
                print("pickmediaurl => \(pickmediaurl)")
                if let mediaData = NSData(contentsOf: pickmediaurl as URL)
                {
                    appDelegate.mediadata = mediaData
    
                    print("lastPathComponent "+pickmediaurl.lastPathComponent!)
                    print("pathExtension "+pickmediaurl.pathExtension!)
                    print("videoData => \(mediaData.length)")
    
                    self.sendfile(imagedata: mediaData as Data, filename: pickmediaurl.lastPathComponent!)
                }
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - KeyboardNotification Methods
    
    func handleKeyboardWillShowNotification(notification: NSNotification)
    {
        if let userInfo = notification.userInfo
        {
            if let keyboardFrame = (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue
            {
                conBottomEditor.constant = keyboardFrame.size.height
                view.layoutIfNeeded()
            }
        }
    }
    
    func handleKeyboardWillHideNotification(notification: NSNotification)
    {
        conBottomEditor.constant = 0
        view.layoutIfNeeded()
    }
    
    func handleConnectedUserUpdateNotification(notification: NSNotification)
    {
        let connectedUserInfo = notification.object as! [String: AnyObject]
        let connectedUserNickname = connectedUserInfo["nickname"] as? String
        lblNewsBanner.text = "User \(connectedUserNickname!.uppercased()) was just connected."
        showBannerLabelAnimated()
    }
    
    func handleDisconnectedUserUpdateNotification(notification: NSNotification)
    {
        let disconnectedUserNickname = notification.object as! String
        lblNewsBanner.text = "User \(disconnectedUserNickname.uppercased()) has left."
        showBannerLabelAnimated()
    }
    
    func handleUserTypingNotification(notification: NSNotification)
    {
        if let typingUsersDictionary = notification.object as? [String: AnyObject]
        {
            var names = ""
            var totalTypingUsers = 0
            for (typingUser, _) in typingUsersDictionary
            {
                if typingUser != nickname
                {
                    names = (names == "") ? typingUser : "\(names), \(typingUser)"
                    totalTypingUsers += 1
                }
            }
    
            if totalTypingUsers > 0
            {
                let verb = (totalTypingUsers == 1) ? "is" : "are"
    
                lblOtherUserActivityStatus.text = "\(names) \(verb) now typing a message..."
                lblOtherUserActivityStatus.isHidden = false
            }
            else
            {
                lblOtherUserActivityStatus.isHidden = true
            }
        }
    }
    
    // MARK: UITableView Delegate and Datasource Methods
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return sectionArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        let section = String(format: "%@", sectionArray.object(at: section) as! CVarArg)
        let seccount = msgdictionary.value(forKey: section) as! NSMutableArray
        return seccount.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "idCellChat", for: indexPath) as! ChatCell
        
        let datestring = String(format: "%@", sectionArray.object(at: indexPath.section) as! CVarArg)
        let msgArray = msgdictionary.value(forKey: datestring) as! NSMutableArray
        let currentChatMessage = msgArray[indexPath.row] as! NSManagedObject
        
        let senderNickname = currentChatMessage.value(forKey: "username") as? String
        let message = currentChatMessage.value(forKey: "message") as? NSString
        let messageDate = currentChatMessage.value(forKey: "date") as? String
        let filepath = currentChatMessage.value(forKey: "imagepath") as? NSString
        _ = currentChatMessage.value(forKey: "userid") as? NSString
        let imagetitle = currentChatMessage.value(forKey: "imagetitle") as? NSString
        let filesize = currentChatMessage.value(forKey: "filesize") as? NSString
        let chattype = currentChatMessage.value(forKey: "type") as! String
        let sendertype = currentChatMessage.value(forKey: "sendertype") as! String
        let favstring = String(format: "%@", currentChatMessage.value(forKey: "starmsg") as! CVarArg)

        let cellheight = self.tableView(tableView, heightForRowAt: indexPath)
    
        cell.rightlinkView?.isHidden = true
        cell.leftlinkView?.isHidden = true

        let longPressGesture:UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(GroupViewController.longPress(_:)))
        longPressGesture.minimumPressDuration = 0.5
        cell.addGestureRecognizer(longPressGesture)
    
        if chattype == "share"
        {
            cell.rightimageView?.isHidden = true
            cell.leftimageView?.isHidden = true
            cell.lefttextView?.isHidden = true
            cell.righttextView?.isHidden = true
            cell.rightcommentView?.isHidden = true
            cell.leftcommentView?.isHidden = true
            cell.rightfileView?.isHidden = true
            cell.leftfileView?.isHidden = true
            
            let shareDetails = currentChatMessage.value(forKey: "sharedetails") as? NSDictionary
            
            _ = shareDetails?.value(forKey: "sharedate") as? NSString
            let sharename = shareDetails?.value(forKey: "sharename") as? NSString
            let sharemessage = shareDetails?.value(forKey: "sharemessage") as? NSString
            _ = shareDetails?.value(forKey: "shareuserid") as? NSString
            let userName = currentChatMessage.value(forKey: "username") as? String
            let message = currentChatMessage.value(forKey: "message") as? String
            
            var sharetxtheight : CGFloat!
            if (sharemessage?.isEqual(to: ""))!
            {
                sharetxtheight = 0.0
            }
            else
            {
                sharetxtheight = commonmethodClass.dynamicHeight(width: screenWidth-100, font: UIFont (name: LatoRegular, size: 16)!, string: sharemessage! as String)
            }
            sharetxtheight = ceil(sharetxtheight)
            
            if let cmtDetails = currentChatMessage.value(forKey: "commentdetails") as? NSDictionary
            {
                cell.rightsharetextView?.isHidden = true
                cell.leftsharetextView?.isHidden = true
                cell.rightshareimageView?.isHidden = true
                cell.leftshareimageView?.isHidden = true
                cell.rightsharefileView?.isHidden = true
                cell.leftsharefileView?.isHidden = true
                
                let senderName = cmtDetails.value(forKey: "senderusername") as? NSString
                let cmtMsg = cmtDetails.value(forKey: "cmtmsg") as? NSString
                _ = cmtDetails.value(forKey: "username") as? String
                _ = cmtDetails.value(forKey: "senderuserid") as? NSString
                
                if sendertype == "right"
                {
                    cell.rightsharecommentView?.isHidden = false
                    cell.leftsharecommentView?.isHidden = true
                    
                    cell.rightsubsharecommentView?.layer.cornerRadius = 10
                    
                    cell.rightsharecommentDatelbl?.text = commonmethodClass.convertDateFormatter(date: messageDate!)
                    
                    cell.rightsharecommenttextheight?.constant = sharetxtheight
                    
                    cell.rightsharecommenttextlbl?.text = sharemessage! as String
                    
                    cell.rightsharecommentnamelbl?.text = senderName as String?
                    
                    //                        let cmtdetails = String(format: "Commented on %@'s file %@ : %@", cmtuserName!, imagetitle!, cmtMsg!)
                    let cmtdetails = String(format: "Commented on file %@ : %@", imagetitle!, cmtMsg!)
                    //                        let namerange = (cmtdetails as NSString).range(of: cmtuserName!)
                    let titlerange = (cmtdetails as NSString).range(of: imagetitle! as String)
                    let attributedString = NSMutableAttributedString(string:cmtdetails)
                    //                        attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.yellow , range: namerange)
                    //                        attributedString.addAttribute(NSFontAttributeName, value: UIFont (name: LatoBlack, size: cell.rightsharecommentdetailslbl.font.pointSize)! , range: namerange)
                    attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.purple , range: titlerange)
                    attributedString.addAttribute(NSFontAttributeName, value: UIFont (name: LatoBlack, size: (cell.rightsharecommentdetailslbl?.font.pointSize)!)! , range: titlerange)
                    
                    cell.rightsharecommentdetailslbl?.attributedText = attributedString
                    
                    if favstring == "0"
                    {
                        cell.rightsharecommentstarimage?.isHidden = true
                    }
                    else
                    {
                        cell.rightsharecommentstarimage?.isHidden = false
                    }
                }
                else
                {
                    cell.rightsharecommentView?.isHidden = true
                    cell.leftsharecommentView?.isHidden = false
                    
                    cell.leftsubsharecommentView?.layer.cornerRadius = 10
                    
                    cell.leftsharecommentDatelbl?.text = commonmethodClass.convertDateFormatter(date: messageDate!)
                    
                    cell.leftsharecommenttextheight?.constant = sharetxtheight
                    
                    cell.leftsharecommenttextlbl?.text = sharemessage! as String
                    
                    cell.leftsharecommentnamelbl?.text = senderName as String?
                    
                    //                        let cmtdetails = String(format: "Commented on %@'s file %@ : %@", cmtuserName!, imagetitle!, cmtMsg!)
                    let cmtdetails = String(format: "Commented on file %@ : %@", imagetitle!, cmtMsg!)
                    //                        let namerange = (cmtdetails as NSString).range(of: cmtuserName!)
                    let titlerange = (cmtdetails as NSString).range(of: imagetitle! as String)
                    let attributedString = NSMutableAttributedString(string:cmtdetails)
                    //                        attributedString.addAttribute(NSForegroundColorAttributeName, value: greenColor , range: namerange)
                    //                        attributedString.addAttribute(NSFontAttributeName, value: UIFont (name: LatoBlack, size: cell.leftsharecommentdetailslbl.font.pointSize)! , range: namerange)
                    attributedString.addAttribute(NSForegroundColorAttributeName, value: blueColor , range: titlerange)
                    attributedString.addAttribute(NSFontAttributeName, value: UIFont (name: LatoBlack, size: (cell.leftsharecommentdetailslbl?.font.pointSize)!)! , range: titlerange)
                    
                    cell.leftsharecommentdetailslbl?.attributedText = attributedString
                    
                    var UserNametextwidth = commonmethodClass.widthOfString(usingFont: (cell.leftsharecommentUserNamelbl?.font!)!, text: userName! as NSString)
                    UserNametextwidth = ceil(UserNametextwidth)
                    
                    var UserTagNametextwidth = commonmethodClass.widthOfString(usingFont: (cell.leftsharecommentUserTagNamelbl?.font!)!, text: userName! as NSString)
                    UserTagNametextwidth = UserTagNametextwidth + 15
                    UserTagNametextwidth = ceil(UserTagNametextwidth)
                    
                    let totaluserwidth = UserNametextwidth + UserTagNametextwidth
                    
                    if totaluserwidth>(screenWidth-70)
                    {
                        UserTagNametextwidth = totaluserwidth - UserNametextwidth - 35
                    }
                    
                    cell.leftsharecommentUserNamewidth?.constant = UserNametextwidth
                    cell.leftsharecommentUserTagNamewidth?.constant = UserTagNametextwidth
                    
                    cell.leftsharecommentUserNamelbl?.text = userName! as String
                    cell.leftsharecommentUserTagNamelbl?.text = String(format: "@%@", userName!)
                    
                    if favstring == "0"
                    {
                        cell.leftsharecommentstarimage?.isHidden = true
                    }
                    else
                    {
                        cell.leftsharecommentstarimage?.isHidden = false
                    }
                }
            }
            else
            {
                cell.rightsharecommentView?.isHidden = true
                cell.leftsharecommentView?.isHidden = true
                
                if (filepath?.isEqual(to: ""))!
                {
                    cell.rightshareimageView?.isHidden = true
                    cell.leftshareimageView?.isHidden = true
                    cell.rightsharefileView?.isHidden = true
                    cell.leftsharefileView?.isHidden = true
                    
                    if sendertype == "right"
                    {
                        cell.rightsharetextView?.isHidden = false
                        cell.leftsharetextView?.isHidden = true
                        
                        cell.rightsubsharetextView?.layer.cornerRadius = 10
                        
                        cell.rightsharetextDatelbl?.text = commonmethodClass.convertDateFormatter(date: messageDate!)
                        
                        cell.rightsharetextheight?.constant = sharetxtheight
                        
                        cell.rightsharetextlbl?.text = sharemessage! as String
                        
                        cell.rightsharetextnamelbl?.text = sharename as String?
                        
                        cell.rightsharetextmessagelbl?.text = message
                        
                        if favstring == "0"
                        {
                            cell.rightsharetextstarimage?.isHidden = true
                        }
                        else
                        {
                            cell.rightsharetextstarimage?.isHidden = false
                        }
                    }
                    else
                    {
                        cell.rightsharetextView?.isHidden = true
                        cell.leftsharetextView?.isHidden = false
                        
                        cell.leftsubsharetextView?.layer.cornerRadius = 10
                        
                        cell.leftsharetextDatelbl?.text = commonmethodClass.convertDateFormatter(date: messageDate!)
                        
                        cell.leftsharetextheight?.constant = sharetxtheight
                        
                        cell.leftsharetextlbl?.text = sharemessage! as String
                        
                        cell.leftsharetextnamelbl?.text = sharename as String?
                        
                        cell.leftsharetextmessagelbl?.text = message
                        
                        var UserNametextwidth = commonmethodClass.widthOfString(usingFont: (cell.leftsharetextUserNamelbl?.font!)!, text: userName! as NSString)
                        UserNametextwidth = ceil(UserNametextwidth)
                        
                        var UserTagNametextwidth = commonmethodClass.widthOfString(usingFont: (cell.leftsharetextUserTagNamelbl?.font!)!, text: userName! as NSString)
                        UserTagNametextwidth = UserTagNametextwidth + 15
                        UserTagNametextwidth = ceil(UserTagNametextwidth)
                        
                        let totaluserwidth = UserNametextwidth + UserTagNametextwidth
                        
                        if totaluserwidth>(screenWidth-70)
                        {
                            UserTagNametextwidth = totaluserwidth - UserNametextwidth - 35
                        }
                        
                        cell.leftsharetextUserNamewidth?.constant = UserNametextwidth
                        cell.leftsharetextUserTagNamewidth?.constant = UserTagNametextwidth
                        
                        cell.leftsharetextUserNamelbl?.text = userName! as String
                        cell.leftsharetextUserTagNamelbl?.text = String(format: "@%@", userName!)
                        
                        if favstring == "0"
                        {
                            cell.leftsharetextstarimage?.isHidden = true
                        }
                        else
                        {
                            cell.leftsharetextstarimage?.isHidden = false
                        }
                    }
                }
                else
                {
                    cell.rightsharetextView?.isHidden = true
                    cell.leftsharetextView?.isHidden = true
                    
                    let filestring = String(format: "%@%@", kfilePath,filepath!)
                    let fileUrl = NSURL(string: filestring)
                    let path = appDelegate.getFolderPath().appendingPathComponent((fileUrl?.lastPathComponent)!)
                    var fileextension = String(format: "%@", (fileUrl?.pathExtension)!) as NSString
                    fileextension = fileextension.lowercased as NSString
                    
                    if (fileextension.isEqual(to: "jpg") || fileextension.isEqual(to: "png") || fileextension.isEqual(to: "jpeg") || fileextension.isEqual(to: "gif"))
                    {
                        cell.rightsharefileView?.isHidden = true
                        cell.leftsharefileView?.isHidden = true
                        
                        if sendertype == "right"
                        {
                            cell.rightshareimageView?.isHidden = false
                            cell.leftshareimageView?.isHidden = true
                            
                            cell.rightsubshareimageView?.layer.cornerRadius = 10
                            
                            cell.rightshareimageDatelbl?.text = commonmethodClass.convertDateFormatter(date: messageDate!)
                            
                            var sharedetails : String!
                            sharedetails = String(format: "Shared an image : %@",(imagetitle?.deletingPathExtension)!)
                            //                                if(userid?.isEqual(to: shareuserid as! String))!
                            //                                {
                            //                                    sharedetails = String(format: "Shared an image : %@",(imagetitle?.deletingPathExtension)!)
                            //                                }
                            //                                else
                            //                                {
                            //                                    sharedetails = String(format: "Shared %@'s image : %@", sharename!, (imagetitle?.deletingPathExtension)!)
                            //                                }
                            
                            let titlerange = (sharedetails as NSString).range(of: (imagetitle?.deletingPathExtension)!)
                            let attributedString = NSMutableAttributedString(string:sharedetails)
                            attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.purple , range: titlerange)
                            attributedString.addAttribute(NSFontAttributeName, value: UIFont (name: LatoBlack, size: (cell.rightshareimagedetailslbl?.font.pointSize)!)! , range: titlerange)
                            
                            cell.rightshareimagedetailslbl?.attributedText = attributedString
                            cell.rightshareimagedetailslbl?.adjustsFontSizeToFitWidth = true
                            
                            cell.rightshareimagetextheight?.constant = sharetxtheight
                            
                            cell.rightshareimagetextlbl?.text = sharemessage! as String
                            
                            cell.rightshareimage?.showActivityIndicator = false
                            cell.rightshareimage?.image = UIImage(contentsOfFile: path.path)
                            cell.rightshareimage?.imageURL = fileUrl as URL?
                            
                            if favstring == "0"
                            {
                                cell.rightshareimagestarimage?.isHidden = true
                            }
                            else
                            {
                                cell.rightshareimagestarimage?.isHidden = false
                            }
                        }
                        else
                        {
                            cell.rightshareimageView?.isHidden = true
                            cell.leftshareimageView?.isHidden = false
                            
                            cell.leftsubshareimageView?.layer.cornerRadius = 10
                            
                            cell.leftshareimageDatelbl?.text = commonmethodClass.convertDateFormatter(date: messageDate!)
                            
                            //                                let sharedetails = String(format: "Shared %@'s image : %@", sharename!, (imagetitle?.deletingPathExtension)!)
                            
                            let sharedetails = String(format: "Shared an image : %@",(imagetitle?.deletingPathExtension)!)
                            
                            let titlerange = (sharedetails as NSString).range(of: (imagetitle?.deletingPathExtension)!)
                            let attributedString = NSMutableAttributedString(string:sharedetails)
                            attributedString.addAttribute(NSForegroundColorAttributeName, value: blueColor , range: titlerange)
                            attributedString.addAttribute(NSFontAttributeName, value: UIFont (name: LatoBlack, size: (cell.leftshareimagedetailslbl?.font.pointSize)!)! , range: titlerange)
                            
                            cell.leftshareimagedetailslbl?.attributedText = attributedString
                            cell.leftshareimagedetailslbl?.adjustsFontSizeToFitWidth = true
                            
                            cell.leftshareimagetextheight?.constant = sharetxtheight
                            
                            cell.leftshareimagetextlbl?.text = sharemessage! as String
                            
                            cell.leftshareimage?.showActivityIndicator = false
                            cell.leftshareimage?.image = UIImage(contentsOfFile: path.path)
                            cell.leftshareimage?.imageURL = fileUrl as URL?
                            
                            var UserNametextwidth = commonmethodClass.widthOfString(usingFont: (cell.leftshareimageUserNamelbl?.font!)!, text: userName! as NSString)
                            UserNametextwidth = ceil(UserNametextwidth)
                            
                            var UserTagNametextwidth = commonmethodClass.widthOfString(usingFont: (cell.leftshareimageUserTagNamelbl?.font!)!, text: userName! as NSString)
                            UserTagNametextwidth = UserTagNametextwidth + 15
                            UserTagNametextwidth = ceil(UserTagNametextwidth)
                            
                            let totaluserwidth = UserNametextwidth + UserTagNametextwidth
                            
                            if totaluserwidth>(screenWidth-70)
                            {
                                UserTagNametextwidth = totaluserwidth - UserNametextwidth - 35
                            }
                            
                            cell.leftshareimageUserNamewidth?.constant = UserNametextwidth
                            cell.leftshareimageUserTagNamewidth?.constant = UserTagNametextwidth
                            
                            cell.leftshareimageUserNamelbl?.text = userName! as String
                            cell.leftshareimageUserTagNamelbl?.text = String(format: "@%@", userName!)
                            
                            if favstring == "0"
                            {
                                cell.leftshareimagestarimage?.isHidden = true
                            }
                            else
                            {
                                cell.leftshareimagestarimage?.isHidden = false
                            }
                        }
                    }
                    else
                    {
                        cell.rightshareimageView?.isHidden = true
                        cell.leftshareimageView?.isHidden = true
                        
                        if sendertype == "right"
                        {
                            cell.rightsharefileView?.isHidden = false
                            cell.leftsharefileView?.isHidden = true
                            
                            cell.rightsubsharefileView?.layer.cornerRadius = 10
                            
                            cell.rightsharefileDatelbl?.text = commonmethodClass.convertDateFormatter(date: messageDate!)
                            
                            var sharedetails : String!
                            sharedetails = String(format: "Shared a file : %@",(imagetitle?.deletingPathExtension)!)
                            //                                if(userid?.isEqual(to: shareuserid as! String))!
                            //                                {
                            //                                    sharedetails = String(format: "Shared a file : %@",(imagetitle?.deletingPathExtension)!)
                            //                                }
                            //                                else
                            //                                {
                            //                                    sharedetails = String(format: "Shared %@'s file : %@", sharename!, (imagetitle?.deletingPathExtension)!)
                            //                                }
                            
                            let titlerange = (sharedetails as NSString).range(of: (imagetitle?.deletingPathExtension)!)
                            let attributedString = NSMutableAttributedString(string:sharedetails)
                            attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.purple , range: titlerange)
                            attributedString.addAttribute(NSFontAttributeName, value: UIFont (name: LatoBlack, size: (cell.rightsharefiledetailslbl?.font.pointSize)!)! , range: titlerange)
                            
                            cell.rightsharefiledetailslbl?.attributedText = attributedString
                            cell.rightsharefiledetailslbl?.adjustsFontSizeToFitWidth = true
                            
                            cell.rightsharefiletypebtn?.layer.borderColor = redColor.cgColor
                            cell.rightsharefiletypebtn?.layer.borderWidth = 2.0
                            cell.rightsharefiletypebtn?.layer.cornerRadius = 5.0;
                            cell.rightsharefiletypebtn?.layer.masksToBounds = true
                            cell.rightsharefiletypebtn?.setTitle(fileUrl?.pathExtension?.uppercased(), for: .normal)
                            cell.rightsharefiletypebtn?.titleLabel?.adjustsFontSizeToFitWidth = true
                            
                            cell.rightsharefiletitlelbl?.text = (imagetitle! as NSString).deletingPathExtension
                            
                            cell.rightsharefilesizelbl?.text = filesize as String?
                            
                            cell.rightsharefiletextlbl?.text = sharemessage! as String
                            
                            if favstring == "0"
                            {
                                cell.rightsharefilestarimage?.isHidden = true
                            }
                            else
                            {
                                cell.rightsharefilestarimage?.isHidden = false
                            }
                        }
                        else
                        {
                            cell.rightsharefileView?.isHidden = true
                            cell.leftsharefileView?.isHidden = false
                            
                            cell.leftsubsharefileView?.layer.cornerRadius = 10
                            
                            cell.leftsharefileDatelbl?.text = commonmethodClass.convertDateFormatter(date: messageDate!)
                            
                            //                                let sharedetails = String(format: "Shared %@'s file : %@", sharename!, (imagetitle?.deletingPathExtension)!)
                            
                            let sharedetails = String(format: "Shared a file : %@",(imagetitle?.deletingPathExtension)!)
                            
                            let titlerange = (sharedetails as NSString).range(of: (imagetitle?.deletingPathExtension)!)
                            let attributedString = NSMutableAttributedString(string:sharedetails)
                            attributedString.addAttribute(NSForegroundColorAttributeName, value: blueColor , range: titlerange)
                            attributedString.addAttribute(NSFontAttributeName, value: UIFont (name: LatoBlack, size: (cell.leftsharefiledetailslbl?.font.pointSize)!)! , range: titlerange)
                            
                            cell.leftsharefiledetailslbl?.attributedText = attributedString
                            cell.leftsharefiledetailslbl?.adjustsFontSizeToFitWidth = true
                            
                            cell.leftsharefiletypebtn?.layer.borderColor = blueColor.cgColor
                            cell.leftsharefiletypebtn?.layer.borderWidth = 2.0
                            cell.leftsharefiletypebtn?.layer.cornerRadius = 5.0;
                            cell.leftsharefiletypebtn?.layer.masksToBounds = true
                            cell.leftsharefiletypebtn?.setTitle(fileUrl?.pathExtension?.uppercased(), for: .normal)
                            cell.leftsharefiletypebtn?.titleLabel?.adjustsFontSizeToFitWidth = true
                            
                            cell.leftsharefiletitlelbl?.text = (imagetitle! as NSString).deletingPathExtension
                            
                            cell.leftsharefilesizelbl?.text = filesize as String?
                            
                            cell.leftsharefiletextlbl?.text = sharemessage! as String
                            
                            var UserNametextwidth = commonmethodClass.widthOfString(usingFont: (cell.leftsharefileUserNamelbl?.font!)!, text: userName! as NSString)
                            UserNametextwidth = ceil(UserNametextwidth)
                            
                            var UserTagNametextwidth = commonmethodClass.widthOfString(usingFont: (cell.leftsharefileUserTagNamelbl?.font!)!, text: userName! as NSString)
                            UserTagNametextwidth = UserTagNametextwidth + 15
                            UserTagNametextwidth = ceil(UserTagNametextwidth)
                            
                            let totaluserwidth = UserNametextwidth + UserTagNametextwidth
                            
                            if totaluserwidth>(screenWidth-70)
                            {
                                UserTagNametextwidth = totaluserwidth - UserNametextwidth - 35
                            }
                            
                            cell.leftsharefileUserNamewidth?.constant = UserNametextwidth
                            cell.leftsharefileUserTagNamewidth?.constant = UserTagNametextwidth
                            
                            cell.leftsharefileUserNamelbl?.text = userName! as String
                            cell.leftsharefileUserTagNamelbl?.text = String(format: "@%@", userName!)
                            
                            if favstring == "0"
                            {
                                cell.leftsharefilestarimage?.isHidden = true
                            }
                            else
                            {
                                cell.leftsharefilestarimage?.isHidden = false
                            }
                        }
                    }
                }
            }
        }
        else
        {
            cell.rightsharetextView?.isHidden = true
            cell.leftsharetextView?.isHidden = true
            cell.rightshareimageView?.isHidden = true
            cell.leftshareimageView?.isHidden = true
            cell.rightsharefileView?.isHidden = true
            cell.leftsharefileView?.isHidden = true
            cell.rightsharecommentView?.isHidden = true
            cell.leftsharecommentView?.isHidden = true
    
            if let cmtDetails = currentChatMessage.value(forKey: "commentdetails") as? NSDictionary
            {
                cell.rightimageView?.isHidden = true
                cell.leftimageView?.isHidden = true
                cell.lefttextView?.isHidden = true
                cell.righttextView?.isHidden = true
                cell.rightfileView?.isHidden = true
                cell.leftfileView?.isHidden = true
    
                let cmtMsg = cmtDetails.value(forKey: "cmtmsg") as? NSString
                let senderName = cmtDetails.value(forKey: "senderusername") as? NSString
                _ = cmtDetails.value(forKey: "username") as? NSString
                _ = cmtDetails.value(forKey: "senderuserid") as? NSString
                let cmtfavstring = String(format: "%@", cmtDetails.value(forKey: "starmsg") as! CVarArg)

                if sendertype == "right"
                {
                    cell.rightcommentView?.isHidden = false
                    cell.leftcommentView?.isHidden = true
    
                    cell.rightsubcommentView?.layer.cornerRadius = 10
    
                    cell.rightcommentDatelbl?.text = commonmethodClass.convertDateFormatter(date: messageDate!)
    
                    //                    let cmtdetails = String(format: "Commented on %@'s file %@", userName!, imagetitle!)
                    let cmtdetails = String(format: "Commented on file %@", imagetitle!)
                    //                    let namerange = (cmtdetails as NSString).range(of: userName as! String)
                    let titlerange = (cmtdetails as NSString).range(of: imagetitle! as String)
                    let attributedString = NSMutableAttributedString(string:cmtdetails)
                    //                    attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.yellow , range: namerange)
                    //                    attributedString.addAttribute(NSFontAttributeName, value: UIFont (name: LatoBlack, size: cell.rightcommentDetailslbl.font.pointSize)! , range: namerange)
                    attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.purple , range: titlerange)
                    attributedString.addAttribute(NSFontAttributeName, value: UIFont (name: LatoBlack, size: (cell.rightcommentDetailslbl?.font.pointSize)!)! , range: titlerange)
    
                    cell.rightcommentDetailslbl?.attributedText = attributedString
                    cell.rightcommentDetailslbl?.adjustsFontSizeToFitWidth = true
    
                    cell.rightcommentMsglbl?.text = cmtMsg as String!
                    
                    if cmtfavstring == "0"
                    {
                        cell.rightcommentstarimage?.isHidden = true
                    }
                    else
                    {
                        cell.rightcommentstarimage?.isHidden = false
                    }
                }
                else
                {
                    cell.rightcommentView?.isHidden = true
                    cell.leftcommentView?.isHidden = false
    
                    cell.leftsubcommentView?.layer.cornerRadius = 10
    
                    cell.leftcommentDatelbl?.text = commonmethodClass.convertDateFormatter(date: messageDate!)
    
                    var UserNametextwidth = commonmethodClass.widthOfString(usingFont: (cell.leftcommentUserNamelbl?.font!)!, text: senderName! as NSString)
                    UserNametextwidth = ceil(UserNametextwidth)
    
                    var UserTagNametextwidth = commonmethodClass.widthOfString(usingFont: (cell.leftcommentUserTagNamelbl?.font!)!, text: senderName! as NSString)
                    UserTagNametextwidth = UserTagNametextwidth + 15
                    UserTagNametextwidth = ceil(UserTagNametextwidth)
    
                    let totaluserwidth = UserNametextwidth + UserTagNametextwidth
    
                    if totaluserwidth>(screenWidth-70)
                    {
                        UserTagNametextwidth = totaluserwidth - UserNametextwidth - 35
                    }
    
                    cell.leftcommentUserNamewidth?.constant = UserNametextwidth
                    cell.leftcommentUserTagNamewidth?.constant = UserTagNametextwidth
    
                    cell.leftcommentUserNamelbl?.text = senderName! as String
                    cell.leftcommentUserTagNamelbl?.text = String(format: "@%@", senderName!)
    
                    //                    let cmtdetails = String(format: "Commented on %@'s file %@", userName!, imagetitle!)
                    let cmtdetails = String(format: "Commented on file %@", imagetitle!)
                    //                    let namerange = (cmtdetails as NSString).range(of: userName as! String)
                    let titlerange = (cmtdetails as NSString).range(of: imagetitle! as String)
                    let attributedString = NSMutableAttributedString(string:cmtdetails)
                    //                    attributedString.addAttribute(NSForegroundColorAttributeName, value: greenColor , range: namerange)
                    //                    attributedString.addAttribute(NSFontAttributeName, value: UIFont (name: LatoBlack, size: cell.rightcommentDetailslbl.font.pointSize)! , range: namerange)
                    attributedString.addAttribute(NSForegroundColorAttributeName, value: blueColor , range: titlerange)
                    attributedString.addAttribute(NSFontAttributeName, value: UIFont (name: LatoBlack, size: (cell.rightcommentDetailslbl?.font.pointSize)!)! , range: titlerange)
    
                    cell.leftcommentDetailslbl?.attributedText = attributedString
                    cell.leftcommentDetailslbl?.adjustsFontSizeToFitWidth = true
    
                    cell.leftcommentMsglbl?.text = cmtMsg as String!
                    
                    if cmtfavstring == "0"
                    {
                        cell.leftcommentstarimage?.isHidden = true
                    }
                    else
                    {
                        cell.leftcommentstarimage?.isHidden = false
                    }
                }
            }
            else
            {
                cell.rightcommentView?.isHidden = true
                cell.leftcommentView?.isHidden = true
    
                if chattype == "message"
                {
                    cell.rightimageView?.isHidden = true
                    cell.leftimageView?.isHidden = true
                    cell.rightfileView?.isHidden = true
                    cell.leftfileView?.isHidden = true
    
                    var textwidth = commonmethodClass.widthOfString(usingFont: (cell.righttextMessagelbl?.font!)!, text: message!)
                    textwidth = textwidth + 50
                    textwidth = ceil(textwidth)
                    
                    if sendertype == "right"
                    {
                        cell.lefttextView?.isHidden = true
                        cell.righttextView?.isHidden = false
                        
                        if textwidth>(screenWidth-70)
                        {
                            textwidth = screenWidth-70
                        }
                        
                        cell.righttextwidth?.constant = textwidth
                        
                        if cellheight>120
                        {
                            cell.righttextMessageView?.layer.cornerRadius = 20
                        }
                        else
                        {
                            cell.righttextMessageView?.layer.cornerRadius = (cellheight-20)/2
                        }
                        
                        cell.righttextMessageView?.layer.masksToBounds = true
                        
                        cell.righttextMessagelbl?.text = message as String?
                        
                        cell.righttextDatelbl?.text = commonmethodClass.convertDateFormatter(date: messageDate!)
                        
                        if favstring == "0"
                        {
                            cell.righttextstarimage?.isHidden = true
                        }
                        else
                        {
                            cell.righttextstarimage?.isHidden = false
                        }
                    }
                    else
                    {
                        cell.lefttextView?.isHidden = false
                        cell.righttextView?.isHidden = true
                        
                        var UserNametextwidth = commonmethodClass.widthOfString(usingFont: (cell.lefttextUserNamelbl?.font!)!, text: senderNickname! as NSString)
                        UserNametextwidth = ceil(UserNametextwidth)
                        
                        var UserTagNametextwidth = commonmethodClass.widthOfString(usingFont: (cell.lefttextUserTagNamelbl?.font!)!, text: senderNickname! as NSString)
                        UserTagNametextwidth = UserTagNametextwidth + 15
                        UserTagNametextwidth = ceil(UserTagNametextwidth)
                        
                        if textwidth>(screenWidth-70)
                        {
                            textwidth = screenWidth-70
                        }
                        
                        var totaluserwidth = UserNametextwidth + UserTagNametextwidth + 60
                        
                        if totaluserwidth>(screenWidth-70)
                        {
                            totaluserwidth = screenWidth-70
                            UserTagNametextwidth = totaluserwidth - UserNametextwidth - 60
                        }
                        
                        cell.lefttextUserNamewidth?.constant = UserNametextwidth
                        cell.lefttextUserTagNamewidth?.constant = UserTagNametextwidth
                        
                        if totaluserwidth>textwidth
                        {
                            cell.lefttextwidth?.constant = totaluserwidth
                        }
                        else
                        {
                            cell.lefttextwidth?.constant = textwidth
                        }
                        
                        if cellheight>120
                        {
                            cell.lefttextMessageView?.layer.cornerRadius = 20
                        }
                        else
                        {
                            cell.lefttextMessageView?.layer.cornerRadius = (cellheight-20)/2
                        }
                        
                        cell.lefttextMessageView?.layer.masksToBounds = true
                        
                        cell.lefttextUserNamelbl?.text = senderNickname
                        
                        cell.lefttextUserTagNamelbl?.text = String(format: "@%@", senderNickname!)
                        
                        cell.lefttextMessagelbl?.text = message as String?
                        
                        cell.lefttextDatelbl?.text = commonmethodClass.convertDateFormatter(date: messageDate!)
                        
                        if favstring == "0"
                        {
                            cell.lefttextstarimage?.isHidden = true
                        }
                        else
                        {
                            cell.lefttextstarimage?.isHidden = false
                        }
                    }
                }
                else
                {
                    cell.lefttextView?.isHidden = true
                    cell.righttextView?.isHidden = true
    
                    let filestring = String(format: "%@%@", kfilePath,filepath!)
    
                    let fileUrl = NSURL(string: filestring)
                    let path = appDelegate.getFolderPath().appendingPathComponent((fileUrl?.lastPathComponent)!)
    
                    var fileextension = String(format: "%@", (fileUrl?.pathExtension)!) as NSString
                    fileextension = fileextension.lowercased as NSString
    
                    if chattype == "image"
                    {
                        cell.rightfileView?.isHidden = true
                        cell.leftfileView?.isHidden = true
    
                        if sendertype == "right"
                        {
                            cell.rightimageView?.isHidden = false
                            cell.leftimageView?.isHidden = true
    
                            cell.rightchatimage?.showActivityIndicator = false
                            cell.rightchatimage?.image = UIImage(contentsOfFile: path.path)
                            cell.rightchatimage?.imageURL = fileUrl as URL?
    
                            cell.rightchatimage?.layer.cornerRadius = 10
    
                            cell.rightimageDatelbl?.text = commonmethodClass.convertDateFormatter(date: messageDate!)
                            
                            if favstring == "0"
                            {
                                cell.rightimagestarimage?.isHidden = true
                            }
                            else
                            {
                                cell.rightimagestarimage?.isHidden = false
                            }
                        }
                        else
                        {
                            cell.rightimageView?.isHidden = true
                            cell.leftimageView?.isHidden = false
    
                            cell.leftsubimageView?.layer.cornerRadius = 10
    
                            var UserNametextwidth = commonmethodClass.widthOfString(usingFont: (cell.leftimageUserNamelbl?.font!)!, text: senderNickname! as NSString)
                            UserNametextwidth = ceil(UserNametextwidth)
    
                            var UserTagNametextwidth = commonmethodClass.widthOfString(usingFont: (cell.leftimageUserTagNamelbl?.font!)!, text: senderNickname! as NSString)
                            UserTagNametextwidth = UserTagNametextwidth + 15
                            UserTagNametextwidth = ceil(UserTagNametextwidth)
    
                            let totaluserwidth = UserNametextwidth + UserTagNametextwidth
    
                            if totaluserwidth>(screenWidth-70)
                            {
                                UserTagNametextwidth = totaluserwidth - UserNametextwidth - 45
                            }
    
                            cell.leftimageUserNamewidth?.constant = UserNametextwidth
                            cell.leftimageUserTagNamewidth?.constant = UserTagNametextwidth
    
                            cell.leftimageUserNamelbl?.text = senderNickname
    
                            cell.leftimageUserTagNamelbl?.text = String(format: "@%@", senderNickname!)
    
                            cell.leftchatimage?.showActivityIndicator = false
                            cell.leftchatimage?.image = UIImage(contentsOfFile: path.path)
                            cell.leftchatimage?.imageURL = fileUrl as URL?
    
                            cell.leftimageMessagelbl?.text = ""
    
                            var msgHeight = commonmethodClass.dynamicHeight(width: screenWidth-120, font: (cell.leftimageMessagelbl?.font!)!, string: cell.leftimageMessagelbl?.text! as! String)
                            msgHeight = ceil(msgHeight)
                            // print("msgHeight =>\(msgHeight)")
    
                            cell.leftimageMessageheight?.constant = msgHeight
    
                            cell.leftimageDatelbl?.text = commonmethodClass.convertDateFormatter(date: messageDate!)
                            
                            if favstring == "0"
                            {
                                cell.leftimagestarimage?.isHidden = true
                            }
                            else
                            {
                                cell.leftimagestarimage?.isHidden = false
                            }
                        }
                    }
                    else
                    {
                        cell.rightimageView?.isHidden = true
                        cell.leftimageView?.isHidden = true
    
                        if sendertype == "right"
                        {
                            cell.rightfileView?.isHidden = false
                            cell.leftfileView?.isHidden = true
    
                            cell.rightsubfileView?.layer.cornerRadius = 10
    
                            cell.rightfileDatelbl?.text = commonmethodClass.convertDateFormatter(date: messageDate!)
    
                            cell.rightfiletypebtn?.layer.borderColor = redColor.cgColor
                            cell.rightfiletypebtn?.layer.borderWidth = 2.0
                            cell.rightfiletypebtn?.layer.cornerRadius = 5.0;
                            cell.rightfiletypebtn?.layer.masksToBounds = true
                            cell.rightfiletypebtn?.setTitle(fileUrl?.pathExtension?.uppercased(), for: .normal)
                            cell.rightfiletypebtn?.titleLabel?.adjustsFontSizeToFitWidth = true
    
                            cell.rightfiletitlelbl?.text = (imagetitle! as NSString).deletingPathExtension
    
                            cell.rightfilesizelbl?.text = filesize as String?
                            
                            if favstring == "0"
                            {
                                cell.rightfilestarimage?.isHidden = true
                            }
                            else
                            {
                                cell.rightfilestarimage?.isHidden = false
                            }
                        }
                        else
                        {
                            cell.rightfileView?.isHidden = true
                            cell.leftfileView?.isHidden = false
    
                            cell.leftsubfileView?.layer.cornerRadius = 10
    
                            var UserNametextwidth = commonmethodClass.widthOfString(usingFont: (cell.leftfileUserNamelbl?.font!)!, text: senderNickname! as NSString)
                            UserNametextwidth = ceil(UserNametextwidth)
    
                            var UserTagNametextwidth = commonmethodClass.widthOfString(usingFont: (cell.leftfileUserTagNamelbl?.font!)!, text: senderNickname! as NSString)
                            UserTagNametextwidth = UserTagNametextwidth + 15
                            UserTagNametextwidth = ceil(UserTagNametextwidth)
    
                            let totaluserwidth = UserNametextwidth + UserTagNametextwidth
    
                            if totaluserwidth>(screenWidth-70)
                            {
                                UserTagNametextwidth = totaluserwidth - UserNametextwidth - 45
                            }
    
                            cell.leftfileUserNamewidth?.constant = UserNametextwidth
                            cell.leftfileUserTagNamewidth?.constant = UserTagNametextwidth
    
                            cell.leftfileUserNamelbl?.text = senderNickname
    
                            cell.leftfileUserTagNamelbl?.text = String(format: "@%@", senderNickname!)
    
                            cell.leftfileDatelbl?.text = commonmethodClass.convertDateFormatter(date: messageDate!)
    
                            cell.leftfiletypebtn?.layer.borderColor = blueColor.cgColor
                            cell.leftfiletypebtn?.layer.borderWidth = 2.0
                            cell.leftfiletypebtn?.layer.cornerRadius = 5.0;
                            cell.leftfiletypebtn?.layer.masksToBounds = true
                            cell.leftfiletypebtn?.setTitle(fileUrl?.pathExtension?.uppercased(), for: .normal)
                            cell.leftfiletypebtn?.titleLabel?.adjustsFontSizeToFitWidth = true
    
                            cell.leftfiletitlelbl?.text = (imagetitle! as NSString).deletingPathExtension
    
                            cell.leftfilesizelbl?.text = filesize as String?
                            
                            if favstring == "0"
                            {
                                cell.leftfilestarimage?.isHidden = true
                            }
                            else
                            {
                                cell.leftfilestarimage?.isHidden = false
                            }
                        }
                    }
                }
            }
        }
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        let datestring = String(format: "%@", sectionArray.object(at: indexPath.section) as! CVarArg)
        let msgArray = msgdictionary.value(forKey: datestring) as! NSMutableArray
        let currentChatMessage = msgArray[indexPath.row] as! NSManagedObject
        let filepath = currentChatMessage.value(forKey: "imagepath") as? NSString
        let message = currentChatMessage.value(forKey: "message") as? NSString
        _ = currentChatMessage.value(forKey: "userid") as? NSString
        let imagetitle = currentChatMessage.value(forKey: "imagetitle") as? NSString
        let chattype = currentChatMessage.value(forKey: "type") as! String
        let sendertype = currentChatMessage.value(forKey: "sendertype") as! String
        
        if chattype == "share"
        {
            let shareDetails = currentChatMessage.value(forKey: "sharedetails") as? NSDictionary
            let sharemessage = shareDetails?.value(forKey: "sharemessage") as? NSString
            
            var sharetxtheight : CGFloat!
            if (sharemessage?.isEqual(to: ""))!
            {
                sharetxtheight = 0.0
            }
            else
            {
                sharetxtheight = commonmethodClass.dynamicHeight(width: screenWidth-100, font: UIFont (name: LatoRegular, size: 16)!, string: sharemessage! as String)
            }
            sharetxtheight = ceil(sharetxtheight)
            
            if let cmtDetails = currentChatMessage.value(forKey: "commentdetails") as? NSDictionary
            {
                let cmtMsg = cmtDetails.value(forKey: "cmtmsg") as? NSString
                _ = cmtDetails.value(forKey: "senderuserid") as? NSString
                let cmtuserName = cmtDetails.value(forKey: "username") as? String
                
                let cmtdetails = String(format: "Commented on %@'s file %@ : %@", cmtuserName!, imagetitle!, cmtMsg!)
                
                var height = commonmethodClass.dynamicHeight(width: screenWidth-120, font: UIFont (name: LatoRegular, size: 16)!, string: cmtdetails as String)
                height = ceil(height)
                
                if sendertype == "right"
                {
                    return sharetxtheight+height+70.0
                }
                else
                {
                    return sharetxtheight+height+110.0
                }
            }
            else
            {
                if (filepath?.isEqual(to: ""))!
                {
                    var height = commonmethodClass.dynamicHeight(width: screenWidth-120, font: UIFont (name: LatoRegular, size: 16)!, string: message! as String)
                    height = ceil(height)
                    
                    if sendertype == "right"
                    {
                        return sharetxtheight+height+75.0
                    }
                    else
                    {
                        return sharetxtheight+height+115.0
                    }
                }
                else
                {
                    let filestring = String(format: "%@%@", kfilePath,filepath!)
                    let fileUrl = NSURL(string: filestring)
                    
                    var fileextension = String(format: "%@", (fileUrl?.pathExtension)!) as NSString
                    fileextension = fileextension.lowercased as NSString
                    
                    if (fileextension.isEqual(to: "jpg") || fileextension.isEqual(to: "png") || fileextension.isEqual(to: "jpeg") || fileextension.isEqual(to: "gif"))
                    {
                        if sendertype == "right"
                        {
                            return sharetxtheight+330.0
                        }
                        else
                        {
                            return sharetxtheight+370.0
                        }
                    }
                    else
                    {
                        if sendertype == "right"
                        {
                            return sharetxtheight+150.0
                        }
                        else
                        {
                            return sharetxtheight+190.0
                        }
                    }
                }
            }
        }
        else
        {
            if let cmtDetails = currentChatMessage.value(forKey: "commentdetails") as? NSDictionary
            {
                let cmtMsg = cmtDetails.value(forKey: "cmtmsg") as? NSString
                _ = cmtDetails.value(forKey: "senderuserid") as? NSString
    
                var height = commonmethodClass.dynamicHeight(width: screenWidth-100, font: UIFont (name: LatoRegular, size: 15)!, string: cmtMsg! as String)
                height = ceil(height)
    
                if sendertype == "right"
                {
                    return height+110.0
                }
                else
                {
                    return height+150.0
                }
            }
            else
            {
                if chattype == "message"
                {
                    var height = commonmethodClass.dynamicHeight(width: screenWidth-120, font: UIFont (name: LatoRegular, size: 16)!, string: message! as String)
                    height = ceil(height)
    
                    if sendertype == "right"
                    {
                        return height+50
                    }
                    else
                    {
                        return height+70
                    }
                }
                else
                {
                    let filestring = String(format: "%@%@", kfilePath,filepath!)
                    let fileUrl = NSURL(string: filestring)
    
                    var fileextension = String(format: "%@", (fileUrl?.pathExtension)!) as NSString
                    fileextension = fileextension.lowercased as NSString
    
                    if chattype == "image"
                    {
                        if sendertype == "right"
                        {
                            return 250.0
                        }
                        else
                        {
                            return 300.0
                        }
                    }
                    else
                    {
                        if sendertype == "right"
                        {
                            return 90.0
                        }
                        else
                        {
                            return 120.0
                        }
                    }
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 50.0))
        
        if(sectionArray.count>0)
        {
            let datestring = String(format: "%@", sectionArray.object(at: section) as! CVarArg)
            
            var Txtwidth = commonmethodClass.widthOfString(usingFont: UIFont(name: LatoBold, size: CGFloat(13.0))!, text: datestring as NSString)
            Txtwidth = ceil(Txtwidth)
            
            let view = UIView()
            view.frame = CGRect(x: CGFloat((screenWidth - (Txtwidth + 30.0)) / 2.0), y: CGFloat(10.0), width: CGFloat(Txtwidth + 30.0), height: CGFloat(30.0))
            view.backgroundColor = UIColor.black
            view.layer.cornerRadius = view.frame.size.height / 2.0
            view.layer.masksToBounds = true
            headerView.addSubview(view)
            
            let label = UILabel()
            label.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(view.frame.size.width), height: CGFloat(view.frame.size.height))
            label.text = datestring
            label.font = UIFont(name: LatoBold, size: CGFloat(13.0))
            label.textAlignment = .center
            label.textColor = UIColor.white
            label.backgroundColor = UIColor.clear
            view.addSubview(label)
        }
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let datestring = String(format: "%@", sectionArray.object(at: indexPath.section) as! CVarArg)
        let msgArray = msgdictionary.value(forKey: datestring) as! NSMutableArray
        let currentChatMessage = msgArray[indexPath.row] as! NSManagedObject
        let msgId = currentChatMessage.value(forKey: "msgid") as? NSString
        let userName = currentChatMessage.value(forKey: "username") as? NSString
        let chattype = currentChatMessage.value(forKey: "type") as! String
        let sendertype = currentChatMessage.value(forKey: "sendertype") as! String
        let userId = self.userdictionary.value(forKey: "id") as! NSString
        let userlogo = self.userdictionary.value(forKey: "pic") as! NSString

        print("currentChatMessage =>\(currentChatMessage)")
        
        if chattype == "image"
        {
            let cell: ChatCell? = (tblChat.cellForRow(at: indexPath) as? ChatCell)
            var imgView : UIImageView!
            if sendertype == "right"
            {
                imgView = (cell?.rightchatimage)!
            }
            else
            {
                imgView = (cell?.leftchatimage)!
            }
            PhotoViewController.showImage(from: imgView, chatdetails: currentChatMessage, groupId: userId, msgId: msgId!, userName: userName!, filetype : "Image", chttype : "OneToOneChat", grouplog: userlogo as String, groupdictionary: NSDictionary())
        }
        else if chattype == "file"
        {
            PhotoViewController.showFile(chatdetails: currentChatMessage, groupId: userId, msgId: msgId!, userName: userName!, filetype : "File", chttype : "OneToOneChat", grouplog: userlogo as String, groupdictionary: NSDictionary())
        }
    }
    
    // MARK: UITextViewDelegate Methods
    
    func textViewDidBeginEditing(_ textView: UITextView)
    {
    
    }
    
    func textViewDidChange(_ textView: UITextView)
    {
        if(textView.contentSize.height > 170)
        {
            UIView.animate(withDuration: 0.25, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
    
                self.BottomEditorheight.constant = 184.0
                self.view.layoutIfNeeded()
    
            }, completion: nil)
        }
        else
        {
            UIView.animate(withDuration: 0.25, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
    
                self.BottomEditorheight.constant = textView.contentSize.height+14
                self.view.layoutIfNeeded()
    
            }, completion: nil)
        }
        
        //        startTyping()
        //
        //        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(stopTyping), object: nil)
        //
        //        self.perform(#selector(stopTyping), with: nil, afterDelay: 0.5)
    }
    
    func textViewDidEndEditing(_ textView: UITextView)
    {
        //stopTyping()
    }
    
    // MARK: didReceiveMemoryWarning
    
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