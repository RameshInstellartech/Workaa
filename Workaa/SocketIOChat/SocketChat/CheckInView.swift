//
//  CheckInView.swift
//  Workaa
//
//  Created by IN1947 on 05/04/17.
//  Copyright © 2017 IN1947. All rights reserved.
//

import UIKit

class CheckInView: UIView, ConnectionProtocol
{
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    var selectTag = NSInteger()
    var connectionClass = ConnectionClass()
    var alertClass = AlertClass()

    func loadCheckInView()
    {
        connectionClass.delegate = self

        self.backgroundColor = UIColor(white: 1.0, alpha: 0.8)
        
        for view : UIView in self.subviews
        {
            view.layer.shadowOpacity = 0.5
            view.layer.shadowColor = UIColor.lightGray.cgColor
            view.layer.shadowOffset = CGSize(width: 0, height: 0)
            view.layer.shadowRadius = 5
            
            for view1 : UIView in view.subviews
            {
                for view2 : UIView in view1.subviews
                {
                    if let lbl = view2 as? UILabel
                    {
                        if(view1.tag==0)
                        {
                            lbl.text = String(format: "%@", checkInReponse.value(forKey: "title") as! CVarArg)
                        }
                        if(view1.tag==1)
                        {
                            if(lbl.tag==1)
                            {
                                lbl.text = String(format: "%@", checkInNowIcon)
                            }
                            if(lbl.tag==2)
                            {
                                lbl.text = String(format: "%@", getCheckInTitle(tag: "checkIn"))
                            }
                        }
                        if(view1.tag==2)
                        {
                            if(lbl.tag==1)
                            {
                                lbl.text = String(format: "%@", checkInLaterIcon)
                            }
                            if(lbl.tag==2)
                            {
                                lbl.text = String(format: "%@", getCheckInTitle(tag: "checkInLater"))
                            }
                        }
                        if(view1.tag==3)
                        {
                            if(lbl.tag==1)
                            {
                                lbl.text = String(format: "%@", remindMeIcon)
                            }
                            if(lbl.tag==2)
                            {
                                lbl.text = String(format: "%@", getCheckInTitle(tag: "reminder"))
                            }
                        }
                        if(view1.tag==4)
                        {
                            if(lbl.tag==1)
                            {
                                lbl.text = String(format: "%@", leaveIcon)
                            }
                            if(lbl.tag==2)
                            {
                                lbl.text = String(format: "%@", getCheckInTitle(tag: "leave"))
                            }
                        }
                    }
                    if let btn = view2 as? UIButton
                    {
                        if(view1.tag==0)
                        {
                            btn.setTitle(closeIcon, for: .normal)
                        }
                    }
                    if(view2.frame.size.height==26.0)
                    {
                        view2.layer.borderWidth = 1.0
                        view2.layer.borderColor = UIColor.lightGray.cgColor
                    }
                }
            }
        }
    }
    
    func getCheckInTitle(tag:String) -> String
    {
        if let checkInlist = checkInReponse.value(forKey: "checkInlist") as? NSArray
        {
            let predicate = NSPredicate(format: "tag like %@",tag);
            let filteredArray = checkInlist.filter { predicate.evaluate(with: $0) };
            if filteredArray.count > 0
            {
                let dictionary = filteredArray[0] as! NSDictionary
                return String(format: "%@", dictionary.value(forKey: "title") as! CVarArg)
            }
            else
            {
                return ""
            }
        }
        else
        {
            return ""
        }
    }
    
    func getCheckInId(tag:String) -> String
    {
        if let checkInlist = checkInReponse.value(forKey: "checkInlist") as? NSArray
        {
            let predicate = NSPredicate(format: "tag like %@",tag);
            let filteredArray = checkInlist.filter { predicate.evaluate(with: $0) };
            if filteredArray.count > 0
            {
                let dictionary = filteredArray[0] as! NSDictionary
                return String(format: "%@", dictionary.value(forKey: "id") as! CVarArg)
            }
            else
            {
                return ""
            }
        }
        else
        {
            return ""
        }
    }
    
    @IBAction func checkInAction(sender: UIButton)
    {
        selectTag = sender.tag
        
        for view : UIView in self.subviews
        {
            for view1 : UIView in view.subviews
            {
                if(view1.tag != 0)
                {
                    if(sender.tag==view1.tag)
                    {
                        for view2 : UIView in view1.subviews
                        {
                            if let lbl = view2 as? UILabel
                            {
                                lbl.textColor = UIColor.black
                            }
                            if(view2.frame.size.height==26.0)
                            {
                                view2.layer.borderWidth = 1.0
                                view2.layer.borderColor = UIColor.darkGray.cgColor
                            }
                            for view3 : UIView in view2.subviews
                            {
                                view3.isHidden = false
                            }
                        }
                    }
                    else
                    {
                        for view2 : UIView in view1.subviews
                        {
                            if let lbl = view2 as? UILabel
                            {
                                lbl.textColor = UIColor.lightGray
                            }
                            if(view2.frame.size.height==26.0)
                            {
                                view2.layer.borderWidth = 1.0
                                view2.layer.borderColor = UIColor.lightGray.cgColor
                            }
                            for view3 : UIView in view2.subviews
                            {
                                view3.isHidden = true
                            }
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func doneAction(sender: UIButton)
    {
        print("selectTag =>\(selectTag)")
        
        if(selectTag==1)
        {
            connectionClass.checkInOut(process: String(format: "%@", getCheckInId(tag: "checkIn")))
        }
        else if(selectTag==2)
        {
            connectionClass.checkInOut(process: String(format: "%@", getCheckInId(tag: "checkInLater")))
        }
        else if(selectTag==3)
        {
            connectionClass.checkInOut(process: String(format: "%@", getCheckInId(tag: "reminder")))
        }
        else if(selectTag==4)
        {
            connectionClass.checkInOut(process: String(format: "%@", getCheckInId(tag: "leave")))
        }
    }
    
    @IBAction func closeAction(sender: UIButton)
    {
        for v: UIView in self.subviews {
            v.removeFromSuperview()
        }
        self.removeFromSuperview()
    }
    
    func GetFailureReponseMethod(errorreponse: String)
    {
        print("GetFailureReponseMethod")
    }
    
    func GetReponseMethod(reponse : NSDictionary)
    {
        print("reponse => \(reponse)")
        
        if(selectTag==1)
        {
            UIApplication.shared.cancelAllLocalNotifications()

            alertClass.showAlert(alerttitle: "Info", alertmsg: checkInReponse.value(forKey: "checkInDone") as! String)
            appDelegate.checkInString = "1"
            
            let side: SWRevealViewController? = (rootViewController as? SWRevealViewController)
            for viewcontroller: UIViewController in (side?.childViewControllers)!
            {
                if let menuView = viewcontroller as? MenuTableViewController
                {
                    menuView.loadArray()
                }
            }
        }
        else if(selectTag==2)
        {
            alertClass.showAlert(alerttitle: "Info", alertmsg: checkInReponse.value(forKey: "checkInLater") as! String)
        }
        else if(selectTag==3)
        {
            alertClass.showAlert(alerttitle: "Info", alertmsg: checkInReponse.value(forKey: "checkInReminder") as! String)
            
            if appDelegate.getCheckInSeconds(tag: "reminder") != ""
            {
                UIApplication.shared.cancelAllLocalNotifications()
                
                let notification = UILocalNotification()
                notification.fireDate = NSDate(timeIntervalSinceNow: TimeInterval((appDelegate.getCheckInSeconds(tag: "reminder") as NSString).integerValue)) as Date
                notification.alertBody = "You have a new message. Tap here to read it."
                notification.alertAction = "Ok"
                notification.soundName = UILocalNotificationDefaultSoundName
                //notification.applicationIconBadgeNumber = 1
                UIApplication.shared.scheduleLocalNotification(notification)
            }
        }
        else if(selectTag==4)
        {
            UIApplication.shared.cancelAllLocalNotifications()

            alertClass.showAlert(alerttitle: "Info", alertmsg: checkInReponse.value(forKey: "leave") as! String)
            appDelegate.checkInString = "3"
        }
        
        for v: UIView in self.subviews {
            v.removeFromSuperview()
        }
        self.removeFromSuperview()
        
        UserDefaults.standard.set(Date(), forKey: "CheckInSavedDate")
        UserDefaults.standard.synchronize()
    }
}
