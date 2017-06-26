//
//  EditCommentView.swift
//  Workaa
//
//  Created by IN1947 on 01/02/17.
//  Copyright © 2017 IN1947. All rights reserved.
//

import UIKit
import CoreData

class EditCommentView: UIView, UITextViewDelegate
{
    @IBOutlet weak var editView : UIView!
    @IBOutlet weak var editTextView : UITextView!
    @IBOutlet weak var savebtn : UIButton!
    @IBOutlet weak var editplaceholderlbl : UILabel!
    @IBOutlet weak var editViewheight: NSLayoutConstraint!
    @IBOutlet weak var editTextViewheight: NSLayoutConstraint!
    @IBOutlet weak var closebtn : UIButton!

    var viewheight : CGFloat!
    var textheight : CGFloat!
    var keyboardheight : CGFloat!
    var msgId : String!
    var groupId : String!
    var cmtId : String!
    var chattype : String!

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    func loadEditView(message : String, msgId : String, cmtId : String, groupId : String, chattype : String)
    {
        self.msgId = msgId
        self.cmtId = cmtId
        self.groupId = groupId
        self.chattype = chattype
        
        editView.layer.cornerRadius = 10;
        
        editTextView.layer.cornerRadius = 5.0
        editTextView.layer.borderColor = UIColor.lightGray.cgColor
        editTextView.layer.borderWidth = 0.5
        
        editTextView.text = message
        editTextView.text = editTextView.text?.replacingOccurrences(of: "(edited)", with: "", options: NSString.CompareOptions.literal, range:nil)
        
        savebtn.layer.cornerRadius = savebtn.frame.size.height/2.0
        
        editView.layer.opacity = 0.5
        editView.layer.transform = CATransform3DMakeScale(1.3, 1.3, 1.0)
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseInOut, animations: {() -> Void in
            self.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
            self.editView.layer.opacity = 1.0
            self.editView.layer.transform = CATransform3DMakeScale(1, 1, 1)
        }, completion: { _ in })
        
        viewheight = editViewheight.constant
        textheight = editTextViewheight.constant
        
        editTextView.becomeFirstResponder()
        
        closebtn.setTitle(closeIcon, for: .normal)
        closebtn.contentEdgeInsets = UIEdgeInsets(top: 0, left: 28, bottom: 0, right: 0)
    }
    
    @IBAction func saveaction(sender: UIButton)
    {
        if editTextView.text.characters.count > 0
        {
            if chattype == "OneToOneChat"
            {
                SocketIOManager.sharedInstance.commentOneToOneeditMessage(message: editTextView.text!, cmtId: self.cmtId, userid: self.groupId as String) { (messageInfo) -> Void in
                    
                    print("Comment messageInfo =>\(messageInfo)")
                    
                    if let getreponse = messageInfo.value(forKey: "apiResponse") as? NSDictionary
                    {
                        if let statuscode = getreponse.value(forKey: "status") as? NSInteger
                        {
                            if statuscode==1
                            {
                                let editmessage = String(format: "%@ (edited)", self.editTextView.text!)
                                print("editmessage =>\(editmessage)")
                                
                                do {
                                    let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "OneToOneComment")
                                    fetchRequest.returnsObjectsAsFaults = false
                                    
                                    let predicate = NSPredicate(format: "cmtid = %@", self.cmtId)
                                    fetchRequest.predicate = predicate
                                    
                                    let results =
                                        try managedContext.fetch(fetchRequest)
                                    let editMessages = results as! [NSManagedObject]
                                    if editMessages.count>0
                                    {
                                        let getmanageObj = editMessages[0]
                                        getmanageObj.setValue(editmessage, forKey: "cmtmsg")
                                        
                                        do {
                                            
                                            try managedContext.save()
                                            
                                            self.closeaction(sender: sender)
                                            
                                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Details_Update"), object: nil)
                                            
                                        } catch let error as NSError  {
                                            print("Could not save \(error), \(error.userInfo)")
                                        }
                                    }
                                    
                                } catch let error as NSError {
                                    print("Could not fetch \(error), \(error.userInfo)")
                                }
                                
                                appDelegate.updateOneToOnecommentmessage(msgId: self.msgId, cmtId: self.cmtId, message: editmessage)
                            }
                        }
                    }
                    
                }
            }
            else if chattype == "CafeChat"
            {
                SocketIOManager.sharedInstance.commentCafeeditMessage(message: editTextView.text!, cmtId: self.cmtId) { (messageInfo) -> Void in
                    
                    print("Comment messageInfo =>\(messageInfo)")
                    
                    if let getreponse = messageInfo.value(forKey: "apiResponse") as? NSDictionary
                    {
                        if let statuscode = getreponse.value(forKey: "status") as? NSInteger
                        {
                            if statuscode==1
                            {
                                let editmessage = String(format: "%@ (edited)", self.editTextView.text!)
                                print("editmessage =>\(editmessage)")
                                
                                do {
                                    let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "CafeComment")
                                    fetchRequest.returnsObjectsAsFaults = false
                                    
                                    let predicate = NSPredicate(format: "cmtid = %@", self.cmtId)
                                    fetchRequest.predicate = predicate
                                    
                                    let results =
                                        try managedContext.fetch(fetchRequest)
                                    let editMessages = results as! [NSManagedObject]
                                    if editMessages.count>0
                                    {
                                        let getmanageObj = editMessages[0]
                                        getmanageObj.setValue(editmessage, forKey: "cmtmsg")
                                        
                                        do {
                                            
                                            try managedContext.save()
                                            
                                            self.closeaction(sender: sender)
                                            
                                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Details_Update"), object: nil)
                                            
                                        } catch let error as NSError  {
                                            print("Could not save \(error), \(error.userInfo)")
                                        }
                                    }
                                    
                                } catch let error as NSError {
                                    print("Could not fetch \(error), \(error.userInfo)")
                                }
                                
                                appDelegate.updateCafecommentmessage(msgId: self.msgId, cmtId: self.cmtId, message: editmessage)
                            }
                        }
                    }
                    
                }
            }
            else
            {
                SocketIOManager.sharedInstance.commenteditMessage(message: editTextView.text!, cmtId: self.cmtId, groupid: self.groupId as String) { (messageInfo) -> Void in
                    
                    print("Comment messageInfo =>\(messageInfo)")
                    
                    if let getreponse = messageInfo.value(forKey: "apiResponse") as? NSDictionary
                    {
                        if let statuscode = getreponse.value(forKey: "status") as? NSInteger
                        {
                            if statuscode==1
                            {
                                let editmessage = String(format: "%@ (edited)", self.editTextView.text!)
                                print("editmessage =>\(editmessage)")
                                
                                do {
                                    let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "GroupComment")
                                    fetchRequest.returnsObjectsAsFaults = false
                                    
                                    let predicate = NSPredicate(format: "cmtid = %@", self.cmtId)
                                    fetchRequest.predicate = predicate
                                    
                                    let results =
                                        try managedContext.fetch(fetchRequest)
                                    let editMessages = results as! [NSManagedObject]
                                    if editMessages.count>0
                                    {
                                        let getmanageObj = editMessages[0]
                                        getmanageObj.setValue(editmessage, forKey: "cmtmsg")
                                        
                                        do {
                                            
                                            try managedContext.save()
                                            
                                            self.closeaction(sender: sender)
                                            
                                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Details_Update"), object: nil)
                                            
                                        } catch let error as NSError  {
                                            print("Could not save \(error), \(error.userInfo)")
                                        }
                                    }
                                    
                                } catch let error as NSError {
                                    print("Could not fetch \(error), \(error.userInfo)")
                                }
                                
                                appDelegate.updatecommentmessage(msgId: self.msgId, cmtId: self.cmtId, message: editmessage)
                            }
                        }
                    }
                    
                }
            }
        }
    }
    
    @IBAction func closeaction(sender: UIButton)
    {
        let currentTransform: CATransform3D = editView.layer.transform

        editView.layer.opacity = 1.0
        UIView.animate(withDuration: 0.2, delay: 0.0, options: [], animations: {() -> Void in
            self.backgroundColor = UIColor(red: CGFloat(0.0), green: CGFloat(0.0), blue: CGFloat(0.0), alpha: CGFloat(0.0))
            self.editView.layer.transform = CATransform3DConcat(currentTransform, CATransform3DMakeScale(0.6, 0.6, 1.0))
            self.editView.layer.opacity = 0.0
        }, completion: {(_ finished: Bool) -> Void in
            for v: UIView in self.subviews {
                v.removeFromSuperview()
            }
            self.removeFromSuperview()
        })
    }
    
    // MARK: - UITextView Delegate
    
    func textViewDidBeginEditing(_ textView: UITextView)
    {
        var totalheight : CGFloat!
        totalheight = screenHeight-keyboardheight-70.0
        
        if totalheight > (textView.contentSize.height+136.0)
        {
            UIView.animate(withDuration: 0.25, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                
                self.editTextViewheight.constant = textView.contentSize.height
                self.editViewheight.constant = self.viewheight + (textView.contentSize.height - self.textheight)
                self.layoutIfNeeded()
                
            }, completion: nil)
        }
        else
        {
            UIView.animate(withDuration: 0.25, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                
                self.editTextViewheight.constant = totalheight-136
                self.editViewheight.constant = totalheight-5
                self.layoutIfNeeded()
                
            }, completion: nil)
        }
    }
    
    func textViewDidChange(_ textView: UITextView)
    {
        if textView.text.characters.count == 0
        {
            editplaceholderlbl.isHidden = false
        }
        else
        {
            editplaceholderlbl.isHidden = true
        }
        
        var totalheight : CGFloat!
        totalheight = screenHeight-keyboardheight-70.0
        
        if totalheight > (textView.contentSize.height+136.0)
        {
            UIView.animate(withDuration: 0.25, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                
                self.editTextViewheight.constant = textView.contentSize.height
                self.editViewheight.constant = self.viewheight + (textView.contentSize.height - self.textheight)
                self.layoutIfNeeded()
                
            }, completion: nil)
        }
    }
}
