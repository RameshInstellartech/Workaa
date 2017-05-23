//
//  PhotoViewController.swift
//  Workaa
//
//  Created by IN1947 on 27/01/17.
//  Copyright © 2017 IN1947. All rights reserved.
//

import UIKit
import CoreData
import Photos
import AVKit

class PhotoViewController: UIViewController, UIScrollViewDelegate, UITextViewDelegate, UITableViewDelegate, UITableViewDataSource, UIDocumentInteractionControllerDelegate
{
    var topView: UIView!
    var bottomView: UIView!
    var commentoverlayView: UIView!
    var commentView: UIView!
    var commentMsgView: UIView!
    var zoomeableScrollView: UIScrollView!
    var theImageView: UIImageView!
    var tempViewContainer: UIView!
    var originalImageRect = CGRect.zero
    var controller: UIViewController!
    var selfController: UIViewController!
    var originalImage: UIImageView!
    var s_backgroundScale: CGFloat = 1.0
    var commonmethodClass = CommonMethodClass()
    var cmttblView : UITableView!
    var commentMessages = [NSManagedObject]()
    var chatMessages = [NSManagedObject]()
    var cmtMsgEditor: PlaceholderTextView!
    var msgId : NSString!
    var groupId : NSString!
    var userName : NSString!
    let cellReuseIdentifier = "idCellCmt"
    var sendbutton : UIButton!
    var borderView : UIView!
    var editView : EditCommentView!
    var filtype : String!
    var chattype : String!
    var grouplogo : AsyncImageView!
    var usernamelbl : UILabel!
    var filetitlelbl : UILabel!
    var dictionary = NSDictionary()

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.view = UIView(frame: UIScreen.main.bounds)
        self.view.backgroundColor = UIColor.clear
        
        let scrollView = UIScrollView(frame: self.view.bounds)
        scrollView.maximumZoomScale = 5.0
        scrollView.minimumZoomScale = 1.0
        scrollView.delegate = self
        scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(scrollView)
        self.zoomeableScrollView = scrollView
        
        let imageView = UIImageView(frame: self.view.bounds)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        self.zoomeableScrollView.addSubview(imageView)
        self.theImageView = imageView
        
        topView = UIView()
        topView.frame = CGRect(x: CGFloat(0.0), y: CGFloat(20.0), width: CGFloat(UIScreen.main.bounds.size.width), height: CGFloat(44.0))
        topView.backgroundColor = UIColor.clear
        topView.isHidden = true
        self.view.addSubview(topView)
        
        let closebutton = UIButton()
        closebutton.addTarget(self, action: #selector(self.onBackgroundTap), for: .touchUpInside)
        closebutton.backgroundColor = UIColor.clear
        closebutton.setTitle(closeIcon, for: .normal)
        closebutton.setTitleColor(UIColor.white, for: .normal)
        closebutton.titleLabel?.font = UIFont(name: Workaa_Font, size: 25.0)
        closebutton.frame = CGRect(x: CGFloat(UIScreen.main.bounds.size.width - 44.0), y: CGFloat(0.0), width: CGFloat(44.0), height: CGFloat(44.0))
        topView.addSubview(closebutton)
        
        grouplogo = AsyncImageView()
        grouplogo.frame = CGRect(x: CGFloat(10.0), y: CGFloat(5.0), width: CGFloat(34.0), height: CGFloat(34.0))
        grouplogo.layer.cornerRadius = grouplogo.frame.size.height / 2.0
        grouplogo.layer.masksToBounds = true
        grouplogo.backgroundColor = UIColor.clear
        grouplogo.activityIndicatorColor = UIColor.white
        grouplogo.activityIndicatorStyle = .white
        grouplogo.contentMode = .scaleAspectFill
        grouplogo.clipsToBounds = true
        topView.addSubview(grouplogo)
        
        usernamelbl = UILabel()
        usernamelbl.frame = CGRect(x: CGFloat(grouplogo.frame.maxX+10.0), y: CGFloat(0.0), width: CGFloat((closebutton.frame.origin.x-(grouplogo.frame.maxX+10.0))), height: CGFloat(22.0))
        usernamelbl.font = UIFont(name: LatoBold, size: CGFloat(15.0))
        usernamelbl.backgroundColor = UIColor.clear
        usernamelbl.textColor = UIColor.white
        usernamelbl.text = ""
        topView.addSubview(usernamelbl)
        
        filetitlelbl = UILabel()
        filetitlelbl.frame = CGRect(x: CGFloat(grouplogo.frame.maxX+10.0), y: CGFloat(22.0), width: CGFloat((closebutton.frame.origin.x-(grouplogo.frame.maxX+10.0))), height: CGFloat(22.0))
        filetitlelbl.font = UIFont(name: LatoBold, size: CGFloat(15.0))
        filetitlelbl.backgroundColor = UIColor.clear
        filetitlelbl.textColor = UIColor.white
        filetitlelbl.text = ""
        topView.addSubview(filetitlelbl)
        
        bottomView = UIView()
        bottomView.frame = CGRect(x: CGFloat(0.0), y: CGFloat(UIScreen.main.bounds.size.height - 44.0), width: CGFloat(UIScreen.main.bounds.size.width), height: CGFloat(44.0))
        bottomView.backgroundColor = UIColor.clear
        bottomView.isHidden = true
        self.view.addSubview(bottomView)
        
        let commentbutton = UIButton()
        commentbutton.addTarget(self, action: #selector(self.commentAction), for: .touchUpInside)
        commentbutton.backgroundColor = UIColor.clear
        commentbutton.setTitle(cmtIcon, for: .normal)
        commentbutton.setTitleColor(UIColor.white, for: .normal)
        commentbutton.titleLabel?.font = UIFont(name: Workaa_Font, size: 25.0)
        commentbutton.frame = CGRect(x: CGFloat(UIScreen.main.bounds.size.width - 44.0), y: CGFloat(0.0), width: CGFloat(44.0), height: CGFloat(44.0))
        bottomView.addSubview(commentbutton)
        
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(self.handleDoubleTap))
        doubleTap.numberOfTapsRequired = 2
        self.zoomeableScrollView.addGestureRecognizer(doubleTap)
        
        commonmethodClass.delayWithSeconds(0.25, completion: {
            self.animate(self.topView, withAnimationType: kCATransitionFromBottom)
            self.animate(self.bottomView, withAnimationType: kCATransitionFromTop)
        })
        
        commentoverlayView = UIView()
        commentoverlayView.frame = self.view.bounds
        commentoverlayView.backgroundColor = UIColor(white: CGFloat(0.0), alpha: CGFloat(0.5))
        commentoverlayView.isHidden = true
        commentoverlayView.isUserInteractionEnabled = true
        self.view.addSubview(commentoverlayView)
        
        let overlaytap = UITapGestureRecognizer(target: self, action: #selector(self.commentviewhide))
        commentoverlayView.addGestureRecognizer(overlaytap)
        
        commentView = UIView()
        commentView.frame = CGRect(x: CGFloat(0.0), y: CGFloat(UIScreen.main.bounds.size.height / 2.0), width: CGFloat(UIScreen.main.bounds.size.width), height: CGFloat(UIScreen.main.bounds.size.height / 2.0))
        commentView.isHidden = true
        commentView.backgroundColor = UIColor.black
        self.view.addSubview(commentView)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.showandhideView))
        self.theImageView.addGestureRecognizer(tap)
        
        cmttblView = UITableView(frame: CGRect(x: CGFloat(0.0), y: CGFloat(0.0), width: CGFloat(commentView.frame.size.width), height: CGFloat(commentView.frame.size.height-44.0)), style: UITableViewStyle.plain)
        cmttblView.backgroundColor = UIColor.clear
        cmttblView.separatorColor = UIColor.clear
        cmttblView.delegate      =   self
        cmttblView.dataSource    =   self
        cmttblView.register(UINib(nibName: "CmtCell", bundle: nil), forCellReuseIdentifier: cellReuseIdentifier)
        cmttblView.showsHorizontalScrollIndicator = false
        cmttblView.showsVerticalScrollIndicator = false
        commentView.addSubview(cmttblView)
        
        commentMsgView = UIView()
        commentMsgView.frame = CGRect(x: CGFloat(0.0), y: CGFloat(commentView.frame.size.height-44.0), width: CGFloat(commentView.frame.size.width), height: 44.0)
        commentMsgView.backgroundColor = UIColor.black
        commentView.addSubview(commentMsgView)
        
        borderView = UIView()
        borderView.frame = CGRect(x: CGFloat(0.0), y: CGFloat(0.0), width: CGFloat(commentMsgView.frame.size.width), height: 0.5)
        borderView.backgroundColor = UIColor.lightGray
        commentMsgView.addSubview(borderView)
        
        cmtMsgEditor = PlaceholderTextView()
        cmtMsgEditor.frame = CGRect(x: CGFloat(10.0), y: CGFloat(5.0), width: CGFloat(commentMsgView.frame.size.width-20.0), height: CGFloat(34.0))
        cmtMsgEditor.textColor = UIColor.darkGray
        cmtMsgEditor.font = UIFont(name: LatoRegular, size: CGFloat(15))
        cmtMsgEditor.autocorrectionType = UITextAutocorrectionType.no
        cmtMsgEditor.keyboardType = UIKeyboardType.default
        cmtMsgEditor.returnKeyType = UIReturnKeyType.default
        cmtMsgEditor.delegate = self
        cmtMsgEditor.layer.cornerRadius = 5.0
        cmtMsgEditor.layer.masksToBounds = true
        cmtMsgEditor.placeholder = "Add your comment..."
        cmtMsgEditor.placeholderColor = UIColor.lightGray
        commentMsgView.addSubview(cmtMsgEditor)
        
        sendbutton = UIButton()
        sendbutton.addTarget(self, action: #selector(self.sendAction), for: .touchUpInside)
        sendbutton.setTitle(sendIcon, for: .normal)
        sendbutton.setTitleColor(UIColor.white, for: .normal)
        sendbutton.frame = CGRect(x: CGFloat(cmtMsgEditor.frame.maxX+5), y: CGFloat((commentMsgView.frame.size.height-34.0)/2.0), width: CGFloat(34.0), height: CGFloat(34.0))
        sendbutton.titleLabel?.font = UIFont(name: Workaa_Font, size: 22.0)
        sendbutton.backgroundColor = greenColor
        sendbutton.isHidden = true
        sendbutton.layer.cornerRadius = sendbutton.frame.size.height/2.0
        sendbutton.layer.masksToBounds = true
        commentMsgView.addSubview(sendbutton)
        
        NotificationCenter.default.addObserver(self, selector: #selector(PhotoViewController.handleKeyboardWillShowNotification(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(PhotoViewController.handleKeyboardWillHideNotification(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        print("filtype =>\(filtype)")

        if filtype == "File"
        {
            self.theImageView.isHidden = true
            self.zoomeableScrollView.isHidden = true
        }
    }
    
    func handleKeyboardWillShowNotification(notification: NSNotification)
    {
        if let userInfo = notification.userInfo
        {
            if let keyboardFrame = (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue
            {
                if editView != nil
                {
                    if editView.subviews.count==0
                    {
                        var frame = commentView.frame
                        frame.origin.y -= keyboardFrame.size.height
                        commentView.frame  = frame
                        view.layoutIfNeeded()
                    }
                    else
                    {
                        editView.keyboardheight = keyboardFrame.size.height
                    }
                }
                else
                {
                    var frame = commentView.frame
                    frame.origin.y -= keyboardFrame.size.height
                    commentView.frame  = frame
                    view.layoutIfNeeded()
                }
            }
        }
    }
    
    func handleKeyboardWillHideNotification(notification: NSNotification)
    {
        commentView.frame = CGRect(x: CGFloat(0.0), y: CGFloat(UIScreen.main.bounds.size.height / 2.0), width: CGFloat(UIScreen.main.bounds.size.width), height: CGFloat(UIScreen.main.bounds.size.height / 2.0))
        view.layoutIfNeeded()
    }
    
    func getcommentDetails()
    {
        do {
            
            var tablename = "GroupComment"
            if chattype == "OneToOneChat"
            {
                tablename = "OneToOneComment"
            }
            if chattype == "CafeChat"
            {
                tablename = "CafeComment"
            }
            
            let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: tablename)
            fetchRequest.returnsObjectsAsFaults = false
            
            let predicate = NSPredicate(format: "msgid = %@", self.msgId)
            fetchRequest.predicate = predicate
            
            let results =
                try managedContext.fetch(fetchRequest)
            commentMessages.removeAll()
            commentMessages = results as! [NSManagedObject]
            print("commentMessages =>\(commentMessages.count)")
            self.cmttblView.reloadData()
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    func showandhideView()
    {
        if topView.isHidden == false && bottomView.isHidden == false
        {
            self.animate(topView, withAnimationType: kCATransitionFromTop)
            self.animate(bottomView, withAnimationType: kCATransitionFromBottom)
        }
        else
        {
            self.animate(topView, withAnimationType: kCATransitionFromBottom)
            self.animate(bottomView, withAnimationType: kCATransitionFromTop)
        }
    }
    
    func commentviewhide()
    {
        cmtMsgEditor.resignFirstResponder()

        self.animate(commentView, withAnimationType: kCATransitionFromBottom)
        commonmethodClass.delayWithSeconds(0.5, completion: {
            self.commentoverlayView.isHidden = true
        })
    }
    
    func handleDoubleTap(_ gestureRecognizer: UIGestureRecognizer)
    {
        let scrollView: UIScrollView? = (gestureRecognizer.view as? UIScrollView)
        if CGFloat((scrollView?.zoomScale)!) > CGFloat((scrollView?.minimumZoomScale)!)
        {
            scrollView?.setZoomScale((scrollView?.minimumZoomScale)!, animated: true)
        }
        else
        {
            scrollView?.setZoomScale((scrollView?.maximumZoomScale)!, animated: true)
        }
    }
    
    func animate(_ animateView: UIView, withAnimationType animType: String)
    {
        let animation = CATransition()
        animation.type = kCATransitionPush
        animation.subtype = animType
        animation.duration = 0.5
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        animateView.layer.add(animation, forKey: kCATransition)
        animateView.isHidden = !animateView.isHidden
    }
    
    func sendAction()
    {
        if cmtMsgEditor.text.characters.count > 0
        {
            if chattype == "OneToOneChat"
            {
                SocketIOManager.sharedInstance.sendOneToOneComment(msgid: self.msgId as String, comment: cmtMsgEditor.text, userid: self.groupId as String) { (messageInfo) -> Void in
                    
                    print("Send messageInfo =>\(messageInfo)")
                    
                    if let getreponse = messageInfo.value(forKey: "apiResponse") as? NSDictionary
                    {
                        if let statuscode = getreponse.value(forKey: "status") as? NSInteger
                        {
                            if statuscode==1
                            {
                                if let datareponse = getreponse.value(forKey: "data") as? NSDictionary
                                {
                                    if let reponse = datareponse.value(forKey: "file") as? NSDictionary
                                    {
                                        print("reponse =>\(reponse)")
                                        
                                        let cmtId = String(format: "%@", datareponse.value(forKey: "messageId") as! CVarArg)
                                        let date = String(format: "%@", datareponse.value(forKey: "time") as! CVarArg)
                                        
                                        let cmtdetails = ["userid":self.commonmethodClass.retrieveuserid(), "username":self.commonmethodClass.retrieveusername(), "cmtmsg":self.cmtMsgEditor.text!, "date":date, "teamid":self.commonmethodClass.retrieveteamid(), "msgid": self.msgId, "cmtid": cmtId, "starmsg":"0", "flname" : self.commonmethodClass.retrievename()] as [String : Any]
                                        
                                        appDelegate.saveOneToOneCommentDetails(chatdetails: cmtdetails as NSDictionary)
                                        
                                        let chatcmtdetails = ["username":self.commonmethodClass.retrieveusername(), "userid":self.commonmethodClass.retrieveusername(), "cmtmsg":self.cmtMsgEditor.text!, "senderusername":self.commonmethodClass.retrieveusername(), "senderuserid":self.commonmethodClass.retrieveuserid(), "cmtid":cmtId, "starmsg":"0", "flname" : self.commonmethodClass.retrievename()] as [String : Any]
                                        print("chatcmtdetails =>\(chatcmtdetails)")
                                        
                                        appDelegate.saveOneToOneChatCmtDetails(cmtdetails: chatcmtdetails as NSDictionary, msgId: self.msgId as String, sendertype: "right")
                                        
                                        self.cmtMsgEditor.text = ""
                                        self.cmtMsgEditor.resignFirstResponder()
                                        
                                        self.scrollToBottom()
                                        
                                        self.textViewDidChange(self.cmtMsgEditor)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            else if chattype == "CafeChat"
            {
                SocketIOManager.sharedInstance.sendCafeComment(msgid: self.msgId as String, comment: cmtMsgEditor.text) { (messageInfo) -> Void in
                    
                    print("Send messageInfo =>\(messageInfo)")
                    
                    if let getreponse = messageInfo.value(forKey: "apiResponse") as? NSDictionary
                    {
                        if let statuscode = getreponse.value(forKey: "status") as? NSInteger
                        {
                            if statuscode==1
                            {
                                if let datareponse = getreponse.value(forKey: "data") as? NSDictionary
                                {
                                    if let reponse = datareponse.value(forKey: "file") as? NSDictionary
                                    {
                                        print("reponse =>\(reponse)")
                                        
                                        let cmtId = String(format: "%@", datareponse.value(forKey: "messageId") as! CVarArg)
                                        let date = String(format: "%@", datareponse.value(forKey: "time") as! CVarArg)
                                        
                                        let cmtdetails = ["userid":self.commonmethodClass.retrieveuserid(), "username":self.commonmethodClass.retrieveusername(), "cmtmsg":self.cmtMsgEditor.text!, "date":date, "teamid":self.commonmethodClass.retrieveteamid(), "msgid": self.msgId, "cmtid": cmtId, "starmsg":"0", "flname" : self.commonmethodClass.retrievename()] as [String : Any]
                                        
                                        appDelegate.saveCafeCommentDetails(chatdetails: cmtdetails as NSDictionary)
                                        
                                        let username = String(format: "%@", self.commonmethodClass.retrieveusername())
                                        let userid = String(format: "%@", self.commonmethodClass.retrieveuserid())
                                        
                                        let chatcmtdetails = ["username":username, "userid":userid, "cmtmsg":self.cmtMsgEditor.text!, "senderusername":self.commonmethodClass.retrieveusername(), "senderuserid":self.commonmethodClass.retrieveuserid(), "cmtid":cmtId, "starmsg":"0", "flname" : self.commonmethodClass.retrievename()] as [String : Any]
                                        print("chatcmtdetails =>\(chatcmtdetails)")
                                        
                                        appDelegate.saveCafeChatCmtDetails(cmtdetails: chatcmtdetails as NSDictionary, msgId: self.msgId as String)
                                        
                                        self.cmtMsgEditor.text = ""
                                        self.cmtMsgEditor.resignFirstResponder()
                                        
                                        self.scrollToBottom()
                                        
                                        self.textViewDidChange(self.cmtMsgEditor)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            else
            {
                SocketIOManager.sharedInstance.sendComment(msgid: self.msgId as String, comment: cmtMsgEditor.text, groupid: self.groupId as String) { (messageInfo) -> Void in
                    
                    print("Send messageInfo =>\(messageInfo)")
                    
                    if let getreponse = messageInfo.value(forKey: "apiResponse") as? NSDictionary
                    {
                        if let statuscode = getreponse.value(forKey: "status") as? NSInteger
                        {
                            if statuscode==1
                            {
                                if let datareponse = getreponse.value(forKey: "data") as? NSDictionary
                                {
                                    if let reponse = datareponse.value(forKey: "file") as? NSDictionary
                                    {
                                        print("reponse =>\(reponse)")
                                        
                                        let cmtId = String(format: "%@", datareponse.value(forKey: "messageId") as! CVarArg)
                                        let date = String(format: "%@", datareponse.value(forKey: "time") as! CVarArg)
                                        
                                        let cmtdetails = ["userid":self.commonmethodClass.retrieveuserid(), "username":self.commonmethodClass.retrieveusername(), "cmtmsg":self.cmtMsgEditor.text!, "date":date, "teamid":self.commonmethodClass.retrieveteamid(), "groupid":self.groupId, "msgid": self.msgId, "cmtid": cmtId, "starmsg":"0", "flname" : self.commonmethodClass.retrievename()] as [String : Any]
                                        
                                        appDelegate.saveCommentDetails(chatdetails: cmtdetails as NSDictionary)
                                        
                                        let username = String(format: "%@", self.commonmethodClass.retrieveusername())
                                        let userid = String(format: "%@", self.commonmethodClass.retrieveuserid())
                                        
                                        let chatcmtdetails = ["username":username, "userid":userid, "cmtmsg":self.cmtMsgEditor.text!, "senderusername":self.commonmethodClass.retrieveusername(), "senderuserid":self.commonmethodClass.retrieveuserid(), "cmtid":cmtId, "starmsg":"0", "flname" : self.commonmethodClass.retrievename()] as [String : Any]
                                        print("chatcmtdetails =>\(chatcmtdetails)")
                                        
                                        appDelegate.saveChatCmtDetails(cmtdetails: chatcmtdetails as NSDictionary, msgId: self.msgId as String, date: date)
                                        
                                        self.cmtMsgEditor.text = ""
                                        self.cmtMsgEditor.resignFirstResponder()
                                        
                                        self.scrollToBottom()
                                        
                                        self.textViewDidChange(self.cmtMsgEditor)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func commentAction()
    {
        commentoverlayView.isHidden = false
        self.animate(commentView, withAnimationType: kCATransitionFromTop)
        cmttblView.reloadData()
    }
    
    func rootViewController() -> UIViewController
    {
        var controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController
        if ((controller?.presentedViewController) != nil)
        {
            controller = controller?.presentedViewController
        }
        return controller!
    }
    
    func showImage(from imageView: UIImageView, chatdetails : NSManagedObject, groupId : NSString, msgId : NSString, userName : NSString, filetype : String, chttype : String, grouplog : String, groupdictionary : NSDictionary)
    {
        filtype = filetype
        chattype = chttype
        
        let controller: UIViewController? = self.rootViewController()
        self.tempViewContainer = UIView(frame: (controller?.view?.bounds)!)
        self.tempViewContainer.backgroundColor = controller?.view?.backgroundColor
        controller?.view?.backgroundColor = UIColor.black
        for subView: UIView in (controller?.view?.subviews)!
        {
            self.tempViewContainer.addSubview(subView)
        }
        controller?.view?.addSubview(self.tempViewContainer)
        
        self.controller = controller
        self.view.frame = (controller?.view.bounds)!
        self.view.backgroundColor = UIColor.clear
        controller?.view.addSubview(self.view)
        self.theImageView.image = imageView.image
        self.originalImageRect = imageView.convert(imageView.bounds, to: self.view)

        self.theImageView.frame = self.originalImageRect
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.getcommentDetails), name: NSNotification.Name(rawValue: "Details_Update"), object: nil)
        
        UIView.animate(withDuration: 0.3, animations: {() -> Void in
            self.view.backgroundColor = UIColor(white: CGFloat(0.0), alpha: CGFloat(1.0))
            self.tempViewContainer.layer.transform = CATransform3DMakeScale(self.s_backgroundScale, self.s_backgroundScale, self.s_backgroundScale)
            self.theImageView.frame = self.centered(onScreenImage: self.theImageView.image!)
        }, completion: {(_ finished: Bool) -> Void in
            self.adjustScrollInsetsToCenterImage()
        })

        self.selfController = self
        self.originalImage = imageView
        chatMessages = [chatdetails]
        self.groupId = groupId
        self.msgId = msgId
        self.userName = userName
        imageView.image = nil
        self.dictionary = groupdictionary
        
        print("chatMessages Photo =>\(chatMessages)")
        print("chattype =>\(chattype)")
        
        let getmanageObj = chatMessages[0]
        if chattype == "GroupChat" || chattype == "OneToOneChat"
        {
            let filestring = String(format: "%@%@", kfilePath,grouplog)
            let fileUrl = NSURL(string: filestring)
            grouplogo.imageURL = fileUrl as URL?
        }
        usernamelbl.text = String(format: "%@",getmanageObj.value(forKey: "username") as! CVarArg)
        filetitlelbl.text = String(format: "%@",getmanageObj.value(forKey: "imagetitle") as! CVarArg)

        self.getcommentDetails()
    }
    
    func showFile(chatdetails : NSManagedObject, groupId : NSString, msgId : NSString, userName : NSString, filetype : String, chttype : String, grouplog : String, groupdictionary : NSDictionary)
    {
        filtype = filetype
        chattype = chttype

        let controller: UIViewController? = self.rootViewController()
        self.tempViewContainer = UIView(frame: (controller?.view?.bounds)!)
        self.tempViewContainer.backgroundColor = controller?.view?.backgroundColor
        controller?.view?.backgroundColor = UIColor.white
        for subView: UIView in (controller?.view?.subviews)!
        {
            self.tempViewContainer.addSubview(subView)
        }
        controller?.view?.addSubview(self.tempViewContainer)
        
        self.controller = controller
        self.view.frame = (controller?.view.bounds)!
        self.view.backgroundColor = UIColor.clear
        controller?.view.addSubview(self.view)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.getcommentDetails), name: NSNotification.Name(rawValue: "Details_Update"), object: nil)
        
        UIView.animate(withDuration: 0.3, animations: {() -> Void in
            self.view.backgroundColor = UIColor.black
            self.tempViewContainer.layer.transform = CATransform3DMakeScale(self.s_backgroundScale, self.s_backgroundScale, self.s_backgroundScale)
        }, completion: {(_ finished: Bool) -> Void in
        })
        
        self.selfController = self
        chatMessages = [chatdetails]
        self.groupId = groupId
        self.msgId = msgId
        self.userName = userName
        self.dictionary = groupdictionary

        print("chatMessages Photo =>\(chatMessages)")
        print("chattype =>\(chattype)")
        
        let getmanageObj = chatMessages[0]
        if chattype == "GroupChat" || chattype == "OneToOneChat"
        {
            let filestring = String(format: "%@%@", kfilePath,grouplog)
            let fileUrl = NSURL(string: filestring)
            grouplogo.imageURL = fileUrl as URL?
        }
        usernamelbl.text = String(format: "%@",getmanageObj.value(forKey: "username") as! CVarArg)
        filetitlelbl.text = String(format: "%@",getmanageObj.value(forKey: "imagetitle") as! CVarArg)

        self.getcommentDetails()
        
        let currentChatMessage = chatMessages[0]
        let imagetitle = currentChatMessage.value(forKey: "imagetitle") as? NSString
        let filepath = currentChatMessage.value(forKey: "imagepath") as? NSString
        let filestring = String(format: "%@%@", kfilePath,filepath!)
        let fileUrl = NSURL(string: filestring)
        let path = appDelegate.getFolderPath().appendingPathComponent((fileUrl?.lastPathComponent)!)
        
        print("filestring =>\(filestring)")
        print("path =>\(path)")
        
        var fileextension = String(format: "%@", (fileUrl?.pathExtension)!) as NSString
        fileextension = fileextension.lowercased as NSString
        
        let filetypebtn = UIButton()
        filetypebtn.setTitle(imagetitle?.pathExtension.uppercased(), for: .normal)
        filetypebtn.setTitleColor(UIColor.white, for: .normal)
        filetypebtn.titleLabel?.font = UIFont (name: LatoBold, size: 16)!
        filetypebtn.frame = CGRect(x: CGFloat((self.view.frame.size.width-50.0)/2.0), y: CGFloat(((self.view.frame.size.height-50.0)/2.0)-70.0), width: CGFloat(50.0), height: CGFloat(50.0))
        filetypebtn.backgroundColor = UIColor.clear
        filetypebtn.layer.borderColor = UIColor.white.cgColor
        filetypebtn.layer.borderWidth = 2.0
        filetypebtn.layer.cornerRadius = 5.0;
        filetypebtn.layer.masksToBounds = true
        filetypebtn.titleLabel?.adjustsFontSizeToFitWidth = true
        filetypebtn.isHidden = true
        self.view.insertSubview(filetypebtn, belowSubview: commentoverlayView)
        
        let viewfilebtn = UIButton(type: .system)
        viewfilebtn.addTarget(self, action: #selector(self.viewFileAction), for: .touchUpInside)
        if (fileextension.isEqual(to: "mp3") || fileextension.isEqual(to: "amr") || fileextension.isEqual(to: "wav") || fileextension.isEqual(to: "m4a") || fileextension.isEqual(to: "mp4") || fileextension.isEqual(to: "avi") || fileextension.isEqual(to: "mov"))
        {
            viewfilebtn.setTitle("Tap to play file", for: .normal)
            viewfilebtn.frame = CGRect(x: CGFloat((self.view.frame.size.width-120.0)/2.0), y: CGFloat(((self.view.frame.size.height-50.0)/2.0)), width: CGFloat(120.0), height: CGFloat(35.0))
        }
        else
        {
            viewfilebtn.setTitle("View File", for: .normal)
            viewfilebtn.frame = CGRect(x: CGFloat((self.view.frame.size.width-90.0)/2.0), y: CGFloat(((self.view.frame.size.height-50.0)/2.0)), width: CGFloat(90.0), height: CGFloat(35.0))
        }
        viewfilebtn.setTitleColor(UIColor.white, for: .normal)
        viewfilebtn.titleLabel?.font = UIFont (name: LatoBold, size: 15)!
        viewfilebtn.backgroundColor = greenColor
        viewfilebtn.layer.cornerRadius = 5.0;
        viewfilebtn.layer.masksToBounds = true
        viewfilebtn.titleLabel?.adjustsFontSizeToFitWidth = true
        viewfilebtn.isHidden = true
        self.view.insertSubview(viewfilebtn, belowSubview: commentoverlayView)
        
        self.commonmethodClass.delayWithSeconds(0.3, completion: {
            UIView.animate(withDuration: 0.3, animations: {() -> Void in
                filetypebtn.isHidden = false
                viewfilebtn.isHidden = false
            }, completion: {(_ finished: Bool) -> Void in
            })
        })
    }
    
    func viewFileAction()
    {
        let currentChatMessage = chatMessages[0]
        let filepath = currentChatMessage.value(forKey: "imagepath") as? NSString
        let filestring = String(format: "%@%@", kfilePath,filepath!)
        let fileUrl = NSURL(string: filestring)
        let path = appDelegate.getFolderPath().appendingPathComponent((fileUrl?.lastPathComponent)!)
        
        print("filestring =>\(filestring)")
        print("path =>\(path)")
        
        var fileextension = String(format: "%@", (fileUrl?.pathExtension)!) as NSString
        fileextension = fileextension.lowercased as NSString
        
        if (fileextension.isEqual(to: "mp3") || fileextension.isEqual(to: "amr") || fileextension.isEqual(to: "wav") || fileextension.isEqual(to: "m4a") || fileextension.isEqual(to: "mp4") || fileextension.isEqual(to: "avi") || fileextension.isEqual(to: "mov"))
        {
            let player = AVPlayer(url: path)
            let playerViewController = AVPlayerViewController()
            playerViewController.player = player
            self.present(playerViewController, animated: true) {
                playerViewController.player!.play()
            }
        }
        else
        {
            let documentInteractionController = UIDocumentInteractionController(url: path)
            documentInteractionController.delegate = self
            documentInteractionController.presentPreview(animated: true)
        }
    }
    
    // MARK: UIDocumentInteractionController Delegate
    
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController
    {
        return self
    }
    
    func documentInteractionControllerDidEndPreview(_ controller: UIDocumentInteractionController)
    {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    deinit
    {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "Details_Update"), object: nil)
    }
    
    func orientationDidChange(_ note: Notification)
    {
        self.theImageView.frame = self.centered(onScreenImage: self.theImageView.image!)
        let newFrame: CGRect? = self.rootViewController().view?.bounds
        self.tempViewContainer.frame = newFrame!
        self.view.frame = newFrame!
        self.adjustScrollInsetsToCenterImage()
    }
    
    func onBackgroundTap()
    {
        if filtype == "File"
        {
            self.animate(topView, withAnimationType: kCATransitionFromTop)
            self.animate(bottomView, withAnimationType: kCATransitionFromBottom)
            
            UIView.animate(withDuration: 0.3, animations: {() -> Void in
                
                for view : UIView in self.view.subviews
                {
                    if let btn = view as? UIButton
                    {
                        btn.isHidden = true
                    }
                }
                
                self.view.backgroundColor = UIColor.clear
                self.tempViewContainer.layer.transform = CATransform3DIdentity
                
            }, completion: {(_ finished: Bool) -> Void in
                
                self.controller.view.backgroundColor = self.tempViewContainer.backgroundColor
                for subView: UIView in self.tempViewContainer.subviews
                {
                    self.controller.view.addSubview(subView)
                }
                self.view.removeFromSuperview()
                self.tempViewContainer.removeFromSuperview()
                
            })
            
            self.selfController = nil
        }
        else
        {
            let absoluteCGRect: CGRect = self.view.convert(self.theImageView.frame, from: self.theImageView.superview)
            self.zoomeableScrollView.contentOffset = CGPoint.zero
            self.zoomeableScrollView.contentInset = .zero
            self.theImageView.frame = absoluteCGRect
            
            var originalImageRect: CGRect = self.originalImage.convert(self.originalImage.frame, to: self.view)
            //originalImageRect is now scaled down, need to adjust
            let scaleBack: CGFloat = 1.0 / s_backgroundScale
            var x: CGFloat = originalImageRect.origin.x
            var y: CGFloat = originalImageRect.origin.y
            let maxX: CGFloat = self.view.frame.size.width
            let maxY: CGFloat = self.view.frame.size.height
            
            y = (y - (maxY / 2.0)) * scaleBack + (maxY / 2.0)
            x = (x - (maxX / 2.0)) * scaleBack + (maxX / 2.0)
            originalImageRect.origin.x = x
            originalImageRect.origin.y = y
            originalImageRect.size.width *= 1.0 / s_backgroundScale
            originalImageRect.size.height *= 1.0 / s_backgroundScale//done scaling }
            
            self.animate(topView, withAnimationType: kCATransitionFromTop)
            self.animate(bottomView, withAnimationType: kCATransitionFromBottom)
            
            UIView.animate(withDuration: 0.3, animations: {() -> Void in
                
                //self.theImageView.frame = originalImageRect;
                if originalImageRect.origin.x == 10
                {
                    self.theImageView.frame = CGRect(x: CGFloat(originalImageRect.origin.x), y: CGFloat(originalImageRect.origin.y - 35), width: CGFloat(originalImageRect.size.width), height: CGFloat(originalImageRect.size.height))
                }
                else
                {
                    self.theImageView.layer.cornerRadius = 10
                    self.theImageView.frame = CGRect(x: CGFloat(originalImageRect.origin.x), y: CGFloat(originalImageRect.origin.y), width: CGFloat(originalImageRect.size.width), height: CGFloat(originalImageRect.size.height))
                }
                self.view.backgroundColor = UIColor.clear
                self.tempViewContainer.layer.transform = CATransform3DIdentity
                
            }, completion: {(_ finished: Bool) -> Void in
                
                self.originalImage.image = self.theImageView.image
                self.controller.view.backgroundColor = self.tempViewContainer.backgroundColor
                self.commonmethodClass.delayWithSeconds(0.4, completion: {
                    for subView: UIView in self.tempViewContainer.subviews
                    {
                        self.controller.view.addSubview(subView)
                    }
                    self.view.removeFromSuperview()
                    self.tempViewContainer.removeFromSuperview()
                })
                
            })
            
            self.selfController = nil
        }
    }
    
    func centered(onScreenImage image: UIImage) -> CGRect
    {
        let imageSize: CGSize = self.imageSizesizeThatFits(for: self.theImageView.image!)
        let imageOrigin = CGPoint(x: CGFloat(self.view.frame.size.width / 2.0 - imageSize.width / 2.0), y: CGFloat(self.view.frame.size.height / 2.0 - imageSize.height / 2.0))
        return CGRect(x: CGFloat(imageOrigin.x), y: CGFloat(imageOrigin.y), width: CGFloat(imageSize.width), height: CGFloat(imageSize.height))
    }
    
    func imageSizesizeThatFits(for image: UIImage) -> CGSize
    {
        let imageSize: CGSize = image.size
        var ratio: CGFloat = min(self.view.frame.size.width / imageSize.width, self.view.frame.size.height / imageSize.height)
        ratio = min(ratio, 1.0)
        //If the image is smaller than the screen let's not make it bigger
        return CGSize(width: CGFloat(imageSize.width * ratio), height: CGFloat(imageSize.height * ratio))
    }
    
    func scrollToBottom()
    {
        if (self.commentMessages.count) > 0
        {
            let lastRowIndexPath = IndexPath(row: self.commentMessages.count - 1, section: 0)
            self.cmttblView.scrollToRow(at: lastRowIndexPath, at: UITableViewScrollPosition.bottom, animated: true)
        }
    }
    
    // MARK: - UITextView Delegate
    
    func textViewDidChange(_ textView: UITextView)
    {
        if textView.text.characters.count == 0
        {
            UIView.animate(withDuration: 0.25, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                
                var frame = self.cmtMsgEditor.frame
                frame.size.width = CGFloat(self.commentMsgView.frame.size.width-20.0)
                self.cmtMsgEditor.frame  = frame
                
                var sendframe = self.sendbutton.frame
                sendframe.origin.x = CGFloat(self.cmtMsgEditor.frame.maxX+5)
                self.sendbutton.frame = sendframe
                
            }, completion: nil)
            
            sendbutton.isHidden = true
        }
        else
        {
            UIView.animate(withDuration: 0.25, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                
                var frame = self.cmtMsgEditor.frame
                frame.size.width = CGFloat(self.commentMsgView.frame.size.width-54.0)
                self.cmtMsgEditor.frame  = frame
                
                var sendframe = self.sendbutton.frame
                sendframe.origin.x = CGFloat(self.cmtMsgEditor.frame.maxX+5)
                self.sendbutton.frame = sendframe
                
            }, completion: nil)
            
            sendbutton.isHidden = false
        }
        
        var height : CGFloat
        height = textView.contentSize.height + 10
        
        if commentView.frame.size.height > height
        {
            commentMsgView.frame = CGRect(x: CGFloat(0.0), y: CGFloat(commentView.frame.size.height-height), width: CGFloat(commentView.frame.size.width), height: height)
            borderView.frame = CGRect(x: CGFloat(0.0), y: CGFloat(0.0), width: CGFloat(commentMsgView.frame.size.width), height: 0.5)
            
            var frame = self.cmtMsgEditor.frame
            frame.size.height = CGFloat(textView.contentSize.height)
            self.cmtMsgEditor.frame  = frame
            
            sendbutton.frame = CGRect(x: CGFloat(cmtMsgEditor.frame.maxX+5), y: CGFloat((commentMsgView.frame.size.height-34.0)/2.0), width: CGFloat(34.0), height: CGFloat(34.0))
        }
    }
    
    // MARK: - ZOOM
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView?
    {
        return self.theImageView
    }
    
    func adjustScrollInsetsToCenterImage()
    {
        let imageSize: CGSize = self.imageSizesizeThatFits(for: self.theImageView.image!)
        self.zoomeableScrollView.zoomScale = 1.0
        self.theImageView.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(imageSize.width), height: CGFloat(imageSize.height))
        self.zoomeableScrollView.contentSize = self.theImageView.frame.size
        let innerFrame: CGRect = self.theImageView.frame
        let scrollerBounds: CGRect = self.zoomeableScrollView.bounds
        var myScrollViewOffset: CGPoint = self.zoomeableScrollView.contentOffset
        if (innerFrame.size.width < scrollerBounds.size.width) || (innerFrame.size.height < scrollerBounds.size.height)
        {
            let tempx: CGFloat = self.theImageView.center.x - (scrollerBounds.size.width / 2)
            let tempy: CGFloat = self.theImageView.center.y - (scrollerBounds.size.height / 2)
            myScrollViewOffset = CGPoint(x: tempx, y: tempy)
        }
        
        var anEdgeInset: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        if scrollerBounds.size.width > innerFrame.size.width
        {
            anEdgeInset.left = (scrollerBounds.size.width - innerFrame.size.width) / 2
            anEdgeInset.right = -anEdgeInset.left
        }
        if scrollerBounds.size.height > innerFrame.size.height
        {
            anEdgeInset.top = (scrollerBounds.size.height - innerFrame.size.height) / 2
            anEdgeInset.bottom = -anEdgeInset.top
        }
        self.zoomeableScrollView.contentOffset = myScrollViewOffset
        self.zoomeableScrollView.contentInset = anEdgeInset
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView)
    {
        let view: UIView? = self.theImageView
        let innerFrame: CGRect? = view?.frame
        let scrollerBounds: CGRect = scrollView.bounds
        var myScrollViewOffset: CGPoint = scrollView.contentOffset
        if ((innerFrame?.size.width)! < scrollerBounds.size.width) || ((innerFrame?.size.height)! < scrollerBounds.size.height)
        {
            let tempx: CGFloat? = (view?.center.x)! - (scrollerBounds.size.width / 2)
            let tempy: CGFloat? = (view?.center.y)! - (scrollerBounds.size.height / 2)
            myScrollViewOffset = CGPoint(x: CGFloat(tempx!), y: CGFloat(tempy!))
        }
        
        var anEdgeInset: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        if scrollerBounds.size.width > (innerFrame?.size.width)!
        {
            anEdgeInset.left = (scrollerBounds.size.width - (innerFrame?.size.width)!) / 2
            anEdgeInset.right = -anEdgeInset.left
        }
        if scrollerBounds.size.height > (innerFrame?.size.height)!
        {
            anEdgeInset.top = (scrollerBounds.size.height - (innerFrame?.size.height)!) / 2
            anEdgeInset.bottom = -anEdgeInset.top
        }
        UIView.animate(withDuration: 0.3, animations: {() -> Void in
            scrollView.contentOffset = myScrollViewOffset
            scrollView.contentInset = anEdgeInset
        })
    }
    
    class func showImage(from imageView: UIImageView, chatdetails : NSManagedObject, groupId : NSString, msgId : NSString, userName : NSString, filetype : String, chttype : String, grouplog : String, groupdictionary : NSDictionary)
    {
        if (imageView.image != nil)
        {
            let viewer = PhotoViewController()
            viewer.showImage(from: imageView, chatdetails: chatdetails, groupId: groupId, msgId: msgId, userName: userName, filetype: filetype,chttype: chttype, grouplog: grouplog, groupdictionary : groupdictionary)
        }
    }
    
    class func showFile(chatdetails : NSManagedObject, groupId : NSString, msgId : NSString, userName : NSString, filetype : String, chttype : String, grouplog : String, groupdictionary : NSDictionary)
    {
        let viewer = PhotoViewController()
        viewer.showFile(chatdetails: chatdetails, groupId: groupId, msgId: msgId, userName: userName, filetype: filetype, chttype: chttype, grouplog: grouplog, groupdictionary : groupdictionary)
    }
    
    // MARK: UITableView Delegate and Datasource Methods
    
    private func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return commentMessages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! CmtCell
        
        //cell.backgroundColor = UIColor.orange
        
        let currentcmtMessage = commentMessages[indexPath.row]
        let senderNickname = currentcmtMessage.value(forKey: "username") as? String
        let message = currentcmtMessage.value(forKey: "cmtmsg") as? String
        let favstring = String(format: "%@", currentcmtMessage.value(forKey: "starmsg") as! CVarArg)

        cell.lblChatMessage.text = message
        cell.lblSenderDetails.text = String(format: "%@", (senderNickname?.uppercased())!)
        cell.lblSenderDetails.adjustsFontSizeToFitWidth = true
        
        cell.lblSenderDetails.textColor = UIColor.yellow
        
        if favstring == "0"
        {
            cell.starimage?.isHidden = true
        }
        else
        {
            cell.starimage?.isHidden = false
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        let currentcmtMessage = commentMessages[indexPath.row]
        let message = currentcmtMessage.value(forKey: "cmtmsg") as? String

        var height = commonmethodClass.dynamicHeight(width: screenWidth-20, font: UIFont(name: LatoRegular, size: CGFloat(14))!, string: message!)
        height = ceil(height)
        return height+50.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let currentcmtMessage = commentMessages[indexPath.row]
        let userId = currentcmtMessage.value(forKey: "userid") as? NSString
        let msgId = currentcmtMessage.value(forKey: "msgid") as? String
        let message = currentcmtMessage.value(forKey: "cmtmsg") as? String
        let cmtId = currentcmtMessage.value(forKey: "cmtid") as? String
        let favstring = String(format: "%@", currentcmtMessage.value(forKey: "starmsg") as! CVarArg)

        var starmsg = "Star Comment"
        if favstring == "1"
        {
            starmsg = "Remove Star"
        }
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: starmsg, style: .default , handler:{ (UIAlertAction)in
            if favstring == "1"
            {
                self.RemoveStarMessage(cmtId: cmtId! as String)
            }
            else
            {
                self.StarMessage(cmtId: cmtId! as String)
            }
        }))
        
        if (userId?.isEqual(to: commonmethodClass.retrieveuserid() as String))!
        {
            alert.addAction(UIAlertAction(title: "Edit Comment", style: .default , handler:{ (UIAlertAction)in
                print("User click Edit button =>\(String(describing: message))")
                self.EditMessage(message: message!, msgId: msgId!, cmtId: cmtId!)
            }))
            alert.addAction(UIAlertAction(title: "Delete Comment", style: .destructive , handler:{ (UIAlertAction)in
                print("User click Delete button")
                self.DeleteMessage(msgId: msgId!, cmtId: cmtId!)
            }))
        }
        else
        {
            if chattype == "GroupChat"
            {
                let adminString = String(format: "%@", dictionary.value(forKey: "admin") as! CVarArg)
                if(commonmethodClass.retrieveteamadmin()=="1" || adminString=="1")
                {
                    alert.addAction(UIAlertAction(title: "Delete Comment", style: .destructive , handler:{ (UIAlertAction)in
                        print("User click Delete button")
                        self.DeleteMessage(msgId: msgId!, cmtId: cmtId!)
                    }))
                }
            }
            else if chattype == "CafeChat"
            {
                if(commonmethodClass.retrieveteamadmin()=="1")
                {
                    alert.addAction(UIAlertAction(title: "Delete Comment", style: .destructive , handler:{ (UIAlertAction)in
                        print("User click Delete button")
                        self.DeleteMessage(msgId: msgId!, cmtId: cmtId!)
                    }))
                }
            }
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler:{ (UIAlertAction)in
            print("User click Dismiss button")
        }))
        rootViewController().present(alert, animated: true, completion: {
            print("completion block")
        })
    }
    
    func StarMessage(cmtId : String)
    {
        if chattype == "OneToOneChat"
        {
            SocketIOManager.sharedInstance.directstarMessage(msgId: cmtId as String, uid: self.groupId as String) { (messageInfo) -> Void in
                
                print("Send messageInfo =>\(messageInfo)")
                
                if let getreponse = messageInfo.value(forKey: "apiResponse") as? NSDictionary
                {
                    if let statuscode = getreponse.value(forKey: "status") as? NSInteger
                    {
                        if statuscode==1
                        {
                            do {
                                let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "OneToOneComment")
                                fetchRequest.returnsObjectsAsFaults = false
                                
                                let predicate = NSPredicate(format: "cmtid = %@", cmtId)
                                fetchRequest.predicate = predicate
                                
                                let results =
                                    try managedContext.fetch(fetchRequest)
                                let messages = results as! [NSManagedObject]
                                if messages.count>0
                                {
                                    let getmanageObj = messages[0]
                                    getmanageObj.setValue("1", forKey: "starmsg")
                                    
                                    do {
                                        try managedContext.save()
                                        self.cmttblView.reloadData()
                                        self.updatecommentstarmessage(msgId: self.msgId as String, cmtId: cmtId, starmsg: "1")
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
        else if chattype == "CafeChat"
        {
            SocketIOManager.sharedInstance.cafestarMessage(msgId: cmtId as String) { (messageInfo) -> Void in
                
                print("Send messageInfo =>\(messageInfo)")
                
                if let getreponse = messageInfo.value(forKey: "apiResponse") as? NSDictionary
                {
                    if let statuscode = getreponse.value(forKey: "status") as? NSInteger
                    {
                        if statuscode==1
                        {
                            do {
                                let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "CafeComment")
                                fetchRequest.returnsObjectsAsFaults = false
                                
                                let predicate = NSPredicate(format: "cmtid = %@", cmtId)
                                fetchRequest.predicate = predicate
                                
                                let results =
                                    try managedContext.fetch(fetchRequest)
                                let messages = results as! [NSManagedObject]
                                if messages.count>0
                                {
                                    let getmanageObj = messages[0]
                                    getmanageObj.setValue("1", forKey: "starmsg")
                                    
                                    do {
                                        try managedContext.save()
                                        self.cmttblView.reloadData()
                                        self.updatecommentstarmessage(msgId: self.msgId as String, cmtId: cmtId, starmsg: "1")
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
        else
        {
            SocketIOManager.sharedInstance.starMessage(msgId: cmtId as String, groupid: self.groupId as String) { (messageInfo) -> Void in
                
                print("Send messageInfo =>\(messageInfo)")
                
                if let getreponse = messageInfo.value(forKey: "apiResponse") as? NSDictionary
                {
                    if let statuscode = getreponse.value(forKey: "status") as? NSInteger
                    {
                        if statuscode==1
                        {
                            do {
                                let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "GroupComment")
                                fetchRequest.returnsObjectsAsFaults = false
                                
                                let predicate = NSPredicate(format: "cmtid = %@", cmtId)
                                fetchRequest.predicate = predicate
                                
                                let results =
                                    try managedContext.fetch(fetchRequest)
                                let messages = results as! [NSManagedObject]
                                if messages.count>0
                                {
                                    let getmanageObj = messages[0]
                                    getmanageObj.setValue("1", forKey: "starmsg")
                                    
                                    do {
                                        try managedContext.save()
                                        self.cmttblView.reloadData()
                                        self.updatecommentstarmessage(msgId: self.msgId as String, cmtId: cmtId, starmsg: "1")
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
    }
    
    func RemoveStarMessage(cmtId : String)
    {
        if chattype == "OneToOneChat"
        {
            SocketIOManager.sharedInstance.directRemoveFav(idstring: cmtId as String, uid: self.groupId as String) { (messageInfo) -> Void in
                
                print("Send messageInfo =>\(messageInfo)")
                
                if let getreponse = messageInfo.value(forKey: "apiResponse") as? NSDictionary
                {
                    if let statuscode = getreponse.value(forKey: "status") as? NSInteger
                    {
                        if statuscode==1
                        {
                            do {
                                let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "OneToOneComment")
                                fetchRequest.returnsObjectsAsFaults = false
                                
                                let predicate = NSPredicate(format: "cmtid = %@", cmtId)
                                fetchRequest.predicate = predicate
                                
                                let results =
                                    try managedContext.fetch(fetchRequest)
                                let messages = results as! [NSManagedObject]
                                if messages.count>0
                                {
                                    let getmanageObj = messages[0]
                                    getmanageObj.setValue("0", forKey: "starmsg")
                                    
                                    do {
                                        try managedContext.save()
                                        self.cmttblView.reloadData()
                                        self.updatecommentstarmessage(msgId: self.msgId as String, cmtId: cmtId, starmsg: "0")
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
        else if chattype == "CafeChat"
        {
            SocketIOManager.sharedInstance.cafeRemoveFav(idstring: cmtId as String) { (messageInfo) -> Void in
                
                print("Send messageInfo =>\(messageInfo)")
                
                if let getreponse = messageInfo.value(forKey: "apiResponse") as? NSDictionary
                {
                    if let statuscode = getreponse.value(forKey: "status") as? NSInteger
                    {
                        if statuscode==1
                        {
                            do {
                                let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "CafeComment")
                                fetchRequest.returnsObjectsAsFaults = false
                                
                                let predicate = NSPredicate(format: "cmtid = %@", cmtId)
                                fetchRequest.predicate = predicate
                                
                                let results =
                                    try managedContext.fetch(fetchRequest)
                                let messages = results as! [NSManagedObject]
                                if messages.count>0
                                {
                                    let getmanageObj = messages[0]
                                    getmanageObj.setValue("0", forKey: "starmsg")
                                    
                                    do {
                                        try managedContext.save()
                                        self.cmttblView.reloadData()
                                        self.updatecommentstarmessage(msgId: self.msgId as String, cmtId: cmtId, starmsg: "0")
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
        else
        {
            SocketIOManager.sharedInstance.groupRemoveFav(idstring: cmtId as String, groupid: self.groupId as String) { (messageInfo) -> Void in
                
                print("Send messageInfo =>\(messageInfo)")
                
                if let getreponse = messageInfo.value(forKey: "apiResponse") as? NSDictionary
                {
                    if let statuscode = getreponse.value(forKey: "status") as? NSInteger
                    {
                        if statuscode==1
                        {
                            do {
                                let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "GroupComment")
                                fetchRequest.returnsObjectsAsFaults = false
                                
                                let predicate = NSPredicate(format: "cmtid = %@", cmtId)
                                fetchRequest.predicate = predicate
                                
                                let results =
                                    try managedContext.fetch(fetchRequest)
                                let messages = results as! [NSManagedObject]
                                if messages.count>0
                                {
                                    let getmanageObj = messages[0]
                                    getmanageObj.setValue("0", forKey: "starmsg")
                                    
                                    do {
                                        try managedContext.save()
                                        self.cmttblView.reloadData()
                                        self.updatecommentstarmessage(msgId: self.msgId as String, cmtId: cmtId, starmsg: "0")
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
    }
    
    func updatecommentstarmessage(msgId : String, cmtId : String, starmsg : String)
    {
        if chattype == "OneToOneChat"
        {
            do {
                let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "OneToOne")
                fetchRequest.returnsObjectsAsFaults = false
                
                let msgid = NSPredicate(format: "msgid = %@", msgId)
                fetchRequest.predicate = msgid
                
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
                            let cmtid = cmtDetails.value(forKey: "cmtid") as? String
                            if cmtid==cmtId
                            {
                                let commentdetails = cmtDetails.mutableCopy() as? NSMutableDictionary
                                commentdetails?.setValue(starmsg, forKey: "starmsg")
                                getmanageObj.setValue(commentdetails, forKey: "commentdetails")
                                do {
                                    
                                    try managedContext.save()
                                    
                                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DirectChat_Refresh"), object: nil)
                                    
                                } catch let error as NSError  {
                                    print("Could not save \(error), \(error.userInfo)")
                                }
                                break
                            }
                        }
                    }
                }
            } catch let error as NSError {
                print("Could not fetch \(error), \(error.userInfo)")
            }
        }
        else if chattype == "CafeChat"
        {
            do {
                let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "CafeChat")
                fetchRequest.returnsObjectsAsFaults = false
                
                let msgid = NSPredicate(format: "msgid = %@", msgId)
                fetchRequest.predicate = msgid
                
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
                            let cmtid = cmtDetails.value(forKey: "cmtid") as? String
                            if cmtid==cmtId
                            {
                                let commentdetails = cmtDetails.mutableCopy() as? NSMutableDictionary
                                commentdetails?.setValue(starmsg, forKey: "starmsg")
                                getmanageObj.setValue(commentdetails, forKey: "commentdetails")
                                do {
                                    
                                    try managedContext.save()
                                    
                                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "CafeChat_Refresh"), object: nil)
                                    
                                } catch let error as NSError  {
                                    print("Could not save \(error), \(error.userInfo)")
                                }
                                break
                            }
                        }
                    }
                }
            } catch let error as NSError {
                print("Could not fetch \(error), \(error.userInfo)")
            }
        }
        else
        {
            do {
                let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "GroupChat")
                fetchRequest.returnsObjectsAsFaults = false
                
                let msgid = NSPredicate(format: "msgid = %@", msgId)
                fetchRequest.predicate = msgid
                
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
                            let cmtid = cmtDetails.value(forKey: "cmtid") as? String
                            if cmtid==cmtId
                            {
                                let commentdetails = cmtDetails.mutableCopy() as? NSMutableDictionary
                                commentdetails?.setValue(starmsg, forKey: "starmsg")
                                getmanageObj.setValue(commentdetails, forKey: "commentdetails")
                                do {
                                    
                                    try managedContext.save()
                                    
                                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "GroupChat_Refresh"), object: nil)
                                    
                                } catch let error as NSError  {
                                    print("Could not save \(error), \(error.userInfo)")
                                }
                                break
                            }
                        }
                    }
                }
            } catch let error as NSError {
                print("Could not fetch \(error), \(error.userInfo)")
            }
        }
    }

    func EditMessage(message : String, msgId : String, cmtId : String)
    {
        editView = Bundle.main.loadNibNamed("EditCommentView", owner: nil, options: nil)?[0] as! EditCommentView
        editView.frame = CGRect(x: 0.0, y: 0.0, width: screenWidth, height: screenHeight)
        editView.loadEditView(message: message, msgId: msgId, cmtId: cmtId, groupId: self.groupId as String, chattype: chattype)
        appDelegate.window?.addSubview(editView)
    }
    
    func DeleteMessage(msgId : String, cmtId : String)
    {
        let alert = UIAlertController(title: "Are you sure you want to delete this comment? This cannot be undone.", message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Yes, Delete the Message", style: .destructive , handler:{ (UIAlertAction)in
            
            if self.chattype == "OneToOneChat"
            {
               SocketIOManager.sharedInstance.commentOneToOnedeleteMessage(userid: self.groupId as String, cmtId: cmtId) { (messageInfo) -> Void in
                    
                    print("Delete messageInfo =>\(messageInfo)")
                    
                    if let getreponse = messageInfo.value(forKey: "apiResponse") as? NSDictionary
                    {
                        if let statuscode = getreponse.value(forKey: "status") as? NSInteger
                        {
                            if statuscode==1
                            {
                                do {
                                    let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "OneToOneComment")
                                    fetchRequest.returnsObjectsAsFaults = false
                                    
                                    let predicate = NSPredicate(format: "cmtid = %@", cmtId)
                                    fetchRequest.predicate = predicate
                                    
                                    let results =
                                        try managedContext.fetch(fetchRequest)
                                    let deleteComment = results as! [NSManagedObject]
                                    if deleteComment.count>0
                                    {
                                        let getmanageObj = deleteComment[0]
                                        managedContext.delete(getmanageObj)
                                        
                                        do {
                                            try managedContext.save()
                                            self.getcommentDetails()
                                        } catch let error as NSError  {
                                            print("Could not save \(error), \(error.userInfo)")
                                        }
                                        
                                        appDelegate.deleteOneToOnecommentmessage(msgId: msgId, cmtId: cmtId)
                                    }
                                    
                                } catch let error as NSError {
                                    print("Could not fetch \(error), \(error.userInfo)")
                                }
                            }
                        }
                    }
                }
            }
            else if self.chattype == "CafeChat"
            {
                SocketIOManager.sharedInstance.commentCafedeleteMessage(cmtId: cmtId) { (messageInfo) -> Void in
                    
                    print("Delete messageInfo =>\(messageInfo)")
                    
                    if let getreponse = messageInfo.value(forKey: "apiResponse") as? NSDictionary
                    {
                        if let statuscode = getreponse.value(forKey: "status") as? NSInteger
                        {
                            if statuscode==1
                            {
                                do {
                                    let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "CafeComment")
                                    fetchRequest.returnsObjectsAsFaults = false
                                    
                                    let predicate = NSPredicate(format: "cmtid = %@", cmtId)
                                    fetchRequest.predicate = predicate
                                    
                                    let results =
                                        try managedContext.fetch(fetchRequest)
                                    let deleteComment = results as! [NSManagedObject]
                                    if deleteComment.count>0
                                    {
                                        let getmanageObj = deleteComment[0]
                                        managedContext.delete(getmanageObj)
                                        
                                        do {
                                            try managedContext.save()
                                            self.getcommentDetails()
                                        } catch let error as NSError  {
                                            print("Could not save \(error), \(error.userInfo)")
                                        }
                                        
                                        appDelegate.deleteCafecommentmessage(msgId: msgId, cmtId: cmtId)
                                    }
                                    
                                } catch let error as NSError {
                                    print("Could not fetch \(error), \(error.userInfo)")
                                }
                            }
                        }
                    }
                }
            }
            else
            {
                SocketIOManager.sharedInstance.commentdeleteMessage(groupid: self.groupId as String, cmtId: cmtId) { (messageInfo) -> Void in
                    
                    print("Delete messageInfo =>\(messageInfo)")
                    
                    if let getreponse = messageInfo.value(forKey: "apiResponse") as? NSDictionary
                    {
                        if let statuscode = getreponse.value(forKey: "status") as? NSInteger
                        {
                            if statuscode==1
                            {
                                do {
                                    let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "GroupComment")
                                    fetchRequest.returnsObjectsAsFaults = false
                                    
                                    let predicate = NSPredicate(format: "cmtid = %@", cmtId)
                                    fetchRequest.predicate = predicate
                                    
                                    let results =
                                        try managedContext.fetch(fetchRequest)
                                    let deleteComment = results as! [NSManagedObject]
                                    if deleteComment.count>0
                                    {
                                        let getmanageObj = deleteComment[0]
                                        managedContext.delete(getmanageObj)
                                        
                                        do {
                                            try managedContext.save()
                                            self.getcommentDetails()
                                        } catch let error as NSError  {
                                            print("Could not save \(error), \(error.userInfo)")
                                        }
                                        
                                        appDelegate.deletecommentmessage(msgId: msgId, cmtId: cmtId)
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
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler:{ (UIAlertAction)in
            print("User click Dismiss button")
        }))
        
        rootViewController().present(alert, animated: true, completion: {
            print("completion block")
        })
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
