//
//  AppDelegate.swift
//  Workaa
//
//  Created by IN1947 on 1/31/16.
//  Copyright © 2016 IN1947. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, ConnectionProtocol, CLLocationManagerDelegate
{
    var window: UIWindow?
    var mediadata : NSData!
    var connectionClass = ConnectionClass()
    var commonmethodClass = CommonMethodClass()
    var userdictionary = NSDictionary()
    var checkInString = String()
    var locationManager = CLLocationManager()
    var latitudeString = String()
    var longitudeString = String()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool
    {        
        UIApplication.shared.statusBarStyle = .lightContent
        
        self.connectionClass.delegate = self
        
        self.commonmethodClass.delayWithSeconds(0.0, completion: {
            navigation().interactivePopGestureRecognizer?.isEnabled = false;
            if(!self.commonmethodClass.retrieveteamdomain().isEqual(to: ""))
            {
                self.getAppLabel()
            }
            navigation().navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: LatoRegular, size: CGFloat(18.0))!, NSForegroundColorAttributeName : UIColor.white];
        })
        
        // iOS 10 support
        if #available(iOS 10, *) {
            UNUserNotificationCenter.current().requestAuthorization(options:[.badge, .alert, .sound]){ (granted, error) in }
            application.registerForRemoteNotifications()
        }
            // iOS 9 support
        else if #available(iOS 9, *) {
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil))
            UIApplication.shared.registerForRemoteNotifications()
        }
        
        let notificationSettings = UIUserNotificationSettings(types: [.alert, .sound, .badge], categories: nil)
        UIApplication.shared.registerUserNotificationSettings(notificationSettings)
        
        self.getMyCurrentLocation()
        
        if launchOptions != nil
        {
            let notification: [AnyHashable: Any]? = (launchOptions?[UIApplicationLaunchOptionsKey.remoteNotification] as? [AnyHashable: Any])
            if notification != nil
            {
                self.application(application, didReceiveRemoteNotification: notification!)
            }
        }        
        
        application.applicationIconBadgeNumber = 0
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication)
    {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication)
    {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        print("applicationDidEnterBackground")
        SocketIOManager.sharedInstance.closeConnection()
    }

    func applicationWillEnterForeground(_ application: UIApplication)
    {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication)
    {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        if kChatBaseURL != ""
        {
            SocketIOManager.sharedInstance.establishConnection()
        }
    }

    func applicationWillTerminate(_ application: UIApplication)
    {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        
        print("applicationWillTerminate")
        SocketIOManager.sharedInstance.closeConnection()
    }
    
    func getMyCurrentLocation()
    {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled()
        {
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        if(locations.count>0)
        {
            let userLocation:CLLocation = locations[0] as CLLocation
            
            // manager.stopUpdatingLocation()
            
            latitudeString = String(format: "%.6f", userLocation.coordinate.latitude)
            longitudeString = String(format: "%.6f", userLocation.coordinate.longitude)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error \(error)")
    }
    
    func getAppLabel()
    {
        self.connectionClass.getAppLabel()
    }
    
    // MARK: - Connection Delegate
    
    func GetReponseMethod(reponse : NSDictionary)
    {
        print("reponse => \(reponse)")
        
        if let datareponse = reponse.value(forKey: "data") as? NSDictionary
        {
            if let urlreponse = datareponse.value(forKey: "domainUrl") as? NSDictionary
            {
                if let baseURL = urlreponse.value(forKey: "url") as? String
                {
                    kBaseURL = baseURL
                }
                if let imageURL = urlreponse.value(forKey: "imageUrl") as? String
                {
                    kfilePath = imageURL
                }
                if let chatUrl = urlreponse.value(forKey: "chatUrl") as? String
                {
                    kChatBaseURL = chatUrl
                }
                
                if kChatBaseURL != ""
                {
                    SocketIOManager.sharedInstance.establishConnection()
                    self.socketMethod()
                    self.oneToonesocketMethod()
                    self.notificationSocketMethod()
                    self.cafesocketMethod()
                }
            }
            if let signUpreponse = datareponse.value(forKey: "signUpPage") as? NSDictionary
            {
                signUpReponse = signUpreponse
            }
            if let signInreponse = datareponse.value(forKey: "signInPage") as? NSDictionary
            {
                signInReponse = signInreponse
            }
            if let checkInreponse = datareponse.value(forKey: "checkIn") as? NSDictionary
            {
                checkInReponse = checkInreponse
                
                checkInString = String(format: "%@", checkInReponse.value(forKey: "checkInOutCurrent") as! CVarArg)
                
                for aviewcontroller : UIViewController in navigation().viewControllers
                {
                    if let homedetailView = aviewcontroller as? HomeDetailViewController
                    {
                        homedetailView.loadCheckInView()
                        break
                    }
                }
            }
            if let teamCreatePage = datareponse.value(forKey: "teamCreatePage") as? NSDictionary
            {
                print("teamCreatePage =>\(teamCreatePage)")
            }
            if let groupCreatePage = datareponse.value(forKey: "groupCreatePage") as? NSDictionary
            {
                groupCreateReponse = groupCreatePage
            }
            if let teamInvitepage = datareponse.value(forKey: "teamInvitePage") as? NSDictionary
            {
                teamInviteReponse = teamInvitepage
            }
            if let groupInvitePage = datareponse.value(forKey: "groupInvitePage") as? NSDictionary
            {
                groupInviteReponse = groupInvitePage
            }
            if let taskAddPage = datareponse.value(forKey: "taskAddPage") as? NSDictionary
            {
                taskAddReponse = taskAddPage
            }
            if let taskStatusPage = datareponse.value(forKey: "taskStatusPage") as? NSDictionary
            {
                taskStatusReponse = taskStatusPage
            }
            if let queueToTaskPage = datareponse.value(forKey: "queueToTaskPage") as? NSDictionary
            {
                queueToTaskReponse = queueToTaskPage
            }
            if let errormsg = datareponse.value(forKey: "commonErrorMessage") as? String
            {
                servererrormsg = errormsg
            }
            if let socketreponse = datareponse.value(forKey: "socketOn") as? NSDictionary
            {
                socketOnReponse = socketreponse
            }
            if let directUnread = datareponse.value(forKey: "directUnreadCount") as? NSInteger
            {
                directunreadcount = directUnread
            }
            if let groupUnread = datareponse.value(forKey: "groupUnreadCount") as? NSInteger
            {
                groupunreadcount = groupUnread
            }
        }
    }
    
    func GetFailureReponseMethod(errorreponse: String)
    {
        print("errorreponse =>\(errorreponse)")
    }
    
    // MARK: - Local Notification
    
    func application(_ application: UIApplication, didReceive notification: UILocalNotification)
    {
        print("Print entire notification message for preview:  \(notification)")
        
        // Extract message alertBody
        let messageToDisplay = notification.alertBody
        
        // Display message alert body in a alert dialog window
        let alertController = UIAlertController(title: "Notification", message: messageToDisplay, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction!) in
            print("Ok button tapped");
        }
        alertController.addAction(OKAction)
        
        // Present dialog window to user
        window?.rootViewController?.present(alertController, animated: true, completion:nil)
    }

    // MARK: - Push Notification
    
    // Called when APNs has assigned the device a unique token
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // Convert token to string
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        
        // Print it to console
        print("APNs device token: \(deviceTokenString)")
        
        kDeviceToken = deviceTokenString
        
        // Persist it in your backend in case it's new
    }
    
    // Called when APNs failed to register the device for push notifications
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        // Print the error to console (you should alert the user that registration failed)
        print("APNs registration failed: \(error)")
        kDeviceToken = "123"
    }
    
    // Push notification received
    func application(_ application: UIApplication, didReceiveRemoteNotification data: [AnyHashable : Any])
    {
        // Print notification payload data
        print("Push notification received: \(data)")
        
        if(data.count>0)
        {
            let reponse = data as NSDictionary
            
            if let notifidictionary = reponse.value(forKey: "notificationResponse") as? NSDictionary
            {
                let tag = String(format: "%@", notifidictionary.value(forKey: "tag") as! CVarArg)
                
                if tag == "chat"
                {
                    if let datadictionary = notifidictionary.value(forKey: "data") as? NSDictionary
                    {
                        let key = String(format: "%@", notifidictionary.value(forKey: "key") as! CVarArg)
                        
                        if key == "groupMessage"
                        {
                            self.groupmsg(messageInfo: datadictionary)
                        }
                        else if key == "groupMessageEdit"
                        {
                            self.groupeditmsg(messageInfo: datadictionary)
                        }
                        else if key == "groupMessageDelete"
                        {
                            self.groupdeletemsg(messageInfo: datadictionary)
                        }
                        else if key == "groupImage"
                        {
                            self.groupfile(messageInfo: datadictionary)
                        }
                        else if key == "groupComment"
                        {
                            self.groupcomment(messageInfo: datadictionary)
                        }
                        else if key == "groupCommentEdit"
                        {
                            self.groupeditcomment(messageInfo: datadictionary)
                        }
                        else if key == "groupCommentDelete"
                        {
                            self.groupdeletecomment(messageInfo: datadictionary)
                        }
                        else if key == "groupShare"
                        {
                            self.groupsharemsg(messageInfo: datadictionary)
                        }
                        else if key == "DirectMessage"
                        {
                            self.directmsg(messageInfo: datadictionary)
                        }
                        else if key == "DirectMessageEdit"
                        {
                            self.directeditmsg(messageInfo: datadictionary)
                        }
                        else if key == "DirectMessageDelete"
                        {
                            self.directdeletemsg(messageInfo: datadictionary)
                        }
                        else if key == "DirectImage"
                        {
                            self.directfile(messageInfo: datadictionary)
                        }
                        else if key == "DirectComment"
                        {
                            self.directcomment(messageInfo: datadictionary)
                        }
                        else if key == "DirectCommentEdit"
                        {
                            self.directeditcomment(messageInfo: datadictionary)
                        }
                        else if key == "DirectCommentDelete"
                        {
                            self.directdeletecomment(messageInfo: datadictionary)
                        }
                        else if key == "DirectShare"
                        {
                            self.directsharemsg(messageInfo: datadictionary)
                        }
                        else if key == "CafeMessage"
                        {
                            self.cafemsg(messageInfo: datadictionary)
                        }
                        else if key == "CafeMessageEdit"
                        {
                            self.cafeeditmsg(messageInfo: datadictionary)
                        }
                        else if key == "CafeMessageDelete"
                        {
                            self.cafedeletemsg(messageInfo: datadictionary)
                        }
                        else if key == "CafeImage"
                        {
                            self.cafefile(messageInfo: datadictionary)
                        }
                        else if key == "CafeComment"
                        {
                            self.cafecomment(messageInfo: datadictionary)
                        }
                        else if key == "CafeCommentEdit"
                        {
                            self.cafeeditcomment(messageInfo: datadictionary)
                        }
                        else if key == "CafeCommentDelete"
                        {
                            self.cafedeletecomment(messageInfo: datadictionary)
                        }
                        else if key == "CafeShare"
                        {
                            self.cafesharemsg(messageInfo: datadictionary)
                        }
                    }
                }
            }
        }
    }
    
    func getCheckInSeconds(tag:String) -> String
    {
        if let checkInlist = checkInReponse.value(forKey: "checkInlist") as? NSArray
        {
            let predicate = NSPredicate(format: "tag like %@",tag);
            let filteredArray = checkInlist.filter { predicate.evaluate(with: $0) };
            if filteredArray.count > 0
            {
                let dictionary = filteredArray[0] as! NSDictionary
                return String(format: "%@", dictionary.value(forKey: "seconds") as! CVarArg)
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

    func notificationSocketMethod()
    {
        SocketIOManager.sharedInstance.getNotificationMessage { (messageInfo) -> Void in
            
            print("getNotificationMessage =>\(messageInfo)")
            
            if(messageInfo.count>0)
            {
                if let key = messageInfo.value(forKey: "key") as? String
                {
                    if key == "reminder"
                    {
                        print("getCheckInSeconds =>\(self.getCheckInSeconds(tag: key))")
                        
                        if self.getCheckInSeconds(tag: key) != ""
                        {
                            UIApplication.shared.cancelAllLocalNotifications()
                            
                            let notification = UILocalNotification()
                            notification.fireDate = NSDate(timeIntervalSinceNow: TimeInterval((self.getCheckInSeconds(tag: key) as NSString).integerValue)) as Date
                            notification.alertBody = "You have a new message. Tap here to read it."
                            notification.alertAction = "Ok"
                            notification.soundName = UILocalNotificationDefaultSoundName
                            //notification.applicationIconBadgeNumber = 1
                            UIApplication.shared.scheduleLocalNotification(notification)
                        }
                    }
                }
            }
        }
    }
    
    func socketMethod()
    {
        SocketIOManager.sharedInstance.getChatMessage { (messageInfo) -> Void in
            print("Appdelegate New messageInfo =>\(messageInfo)")
            self.groupmsg(messageInfo: messageInfo)
        }
        
        SocketIOManager.sharedInstance.getChatImage { (messageInfo) -> Void in
            print("Appdelegate New getChatImage =>\(messageInfo)")
            self.groupfile(messageInfo: messageInfo)
        }
        
        SocketIOManager.sharedInstance.getEditMessage { (messageInfo) -> Void in
            print("Appdelegate Edit messageInfo =>\(messageInfo)")
            self.groupeditmsg(messageInfo: messageInfo)
        }
        
        SocketIOManager.sharedInstance.getDeleteMessage { (messageInfo) -> Void in
            print("Delete messageInfo =>\(messageInfo)")
            self.groupdeletemsg(messageInfo: messageInfo)
        }
        
        SocketIOManager.sharedInstance.getShareMessage { (messageInfo) -> Void in
            print("getShareMessage =>\(messageInfo)")
            self.groupsharemsg(messageInfo: messageInfo)
        }
        
        SocketIOManager.sharedInstance.getChatComment { (messageInfo) -> Void in
            print("New getChatComment =>\(messageInfo)")
            self.groupcomment(messageInfo: messageInfo)
        }
        
        SocketIOManager.sharedInstance.getCommentEditMessage { (messageInfo) -> Void in
            print("CommentEdit messageInfo =>\(messageInfo)")
            self.groupeditcomment(messageInfo: messageInfo)
        }
        
        SocketIOManager.sharedInstance.getCommentDeleteMessage { (messageInfo) -> Void in
            print("CommentDelete messageInfo =>\(messageInfo)")
            self.groupdeletecomment(messageInfo: messageInfo)
        }
        
        SocketIOManager.sharedInstance.getChatTyping { (messageInfo) -> Void in
            print("New getChatTyping =>\(messageInfo)")
        }
        
        SocketIOManager.sharedInstance.getGroupUrlPreview { (messageInfo) -> Void in
            print("New getGroupUrlPreview =>\(messageInfo)")
            self.grouplinkmsg(messageInfo: messageInfo)
        }
    }
    
    func oneToonesocketMethod()
    {
        SocketIOManager.sharedInstance.getOneToOneChatMessage { (messageInfo) -> Void in
            print("Appdelegate New messageInfo =>\(messageInfo)")
            self.directmsg(messageInfo: messageInfo)
        }
        
        SocketIOManager.sharedInstance.getOneToOneChatImage { (messageInfo) -> Void in
            print("Appdelegate New getChatImage =>\(messageInfo)")
            self.directfile(messageInfo: messageInfo)
        }
        
        SocketIOManager.sharedInstance.getOneToOneEditMessage { (messageInfo) -> Void in
            print("Appdelegate Edit messageInfo =>\(messageInfo)")
            self.directeditmsg(messageInfo: messageInfo)
        }
        
        SocketIOManager.sharedInstance.getOneToOneDeleteMessage { (messageInfo) -> Void in
            print("Delete messageInfo =>\(messageInfo)")
            self.directdeletemsg(messageInfo: messageInfo)
        }
        
        SocketIOManager.sharedInstance.getOneToOneShareMessage { (messageInfo) -> Void in
            print("getShareMessage =>\(messageInfo)")
            self.directsharemsg(messageInfo: messageInfo)
        }
        
        SocketIOManager.sharedInstance.getOneToOneChatComment { (messageInfo) -> Void in
            print("New getChatComment =>\(messageInfo)")
            self.directcomment(messageInfo: messageInfo)
        }
        
        SocketIOManager.sharedInstance.getCommentOneToOneEditMessage { (messageInfo) -> Void in
            print("CommentEdit messageInfo =>\(messageInfo)")
            self.directeditcomment(messageInfo: messageInfo)
        }
        
        SocketIOManager.sharedInstance.getOneToOneCommentDeleteMessage { (messageInfo) -> Void in
            print("CommentDelete messageInfo =>\(messageInfo)")
            self.directdeletecomment(messageInfo: messageInfo)
        }
        
        SocketIOManager.sharedInstance.getChatTyping { (messageInfo) -> Void in
            print("New getChatTyping =>\(messageInfo)")
        }
        
//        SocketIOManager.sharedInstance.getGroupUrlPreview { (messageInfo) -> Void in
//            print("New getGroupUrlPreview =>\(messageInfo)")
//            self.grouplinkmsg(messageInfo: messageInfo)
//        }
    }
    
    func cafesocketMethod()
    {
        SocketIOManager.sharedInstance.getCafeChatMessage { (messageInfo) -> Void in
            print("Appdelegate New messageInfo =>\(messageInfo)")
            self.cafemsg(messageInfo: messageInfo)
        }
        
        SocketIOManager.sharedInstance.getCafeChatImage { (messageInfo) -> Void in
            print("Appdelegate New getChatImage =>\(messageInfo)")
            self.cafefile(messageInfo: messageInfo)
        }
        
        SocketIOManager.sharedInstance.getCafeEditMessage { (messageInfo) -> Void in
            print("Appdelegate Edit messageInfo =>\(messageInfo)")
            self.cafeeditmsg(messageInfo: messageInfo)
        }
        
        SocketIOManager.sharedInstance.getCafeDeleteMessage { (messageInfo) -> Void in
            print("Delete messageInfo =>\(messageInfo)")
            self.cafedeletemsg(messageInfo: messageInfo)
        }
        
        SocketIOManager.sharedInstance.getCafeShareMessage { (messageInfo) -> Void in
            print("getShareMessage =>\(messageInfo)")
            self.cafesharemsg(messageInfo: messageInfo)
        }
        
        SocketIOManager.sharedInstance.getCafeChatComment { (messageInfo) -> Void in
            print("New getChatComment =>\(messageInfo)")
            self.cafecomment(messageInfo: messageInfo)
        }
        
        SocketIOManager.sharedInstance.getCommentCafeEditMessage { (messageInfo) -> Void in
            print("CommentEdit messageInfo =>\(messageInfo)")
            self.cafeeditcomment(messageInfo: messageInfo)
        }
        
        SocketIOManager.sharedInstance.getCommentCafeDeleteMessage { (messageInfo) -> Void in
            print("CommentDelete messageInfo =>\(messageInfo)")
            self.cafedeletecomment(messageInfo: messageInfo)
        }
        
        SocketIOManager.sharedInstance.getChatTyping { (messageInfo) -> Void in
            
            print("New getChatTyping =>\(messageInfo)")
        }
    }
    
    // MARK: - Banner Show
    
    func showbanner(title : String, subtitle: String, chattype: String)
    {
        let banner = Banner(title: title, subtitle: subtitle, image: UIImage(named: "yellowstar.png")!, backgroundColor: greenColor)
        banner.didTapBlock = {
            print("Banner was tapped on")
        }
        banner.show(duration: 3.0)
    }
    
    // MARK: - Socket Method
    
    func cafemsg(messageInfo : NSDictionary)
    {
        let userid = String(format: "%@", messageInfo.value(forKey: "sendId") as! CVarArg)
        let teamid = String(format: "%@", messageInfo.value(forKey: "teamId") as! CVarArg)
        let date = String(format: "%@", messageInfo.value(forKey: "sendTime") as! CVarArg)
        let username = String(format: "%@ %@", messageInfo.value(forKey: "sendFirstName") as! CVarArg,messageInfo.value(forKey: "sendLastName") as! CVarArg)
        let msg = String(format: "%@", messageInfo.value(forKey: "message") as! CVarArg)
        let msgid = String(format: "%@", messageInfo.value(forKey: "messageId") as! CVarArg)
        
        let chatdetails = ["userid":userid, "username":username, "message":msg, "date":date, "teamid":teamid, "imagepath":"", "msgid":msgid, "imagetitle":"", "filesize":"", "filecaption":"", "starmsg":"0"] as [String : Any]
        
        self.saveCafeChatDetails(chatdetails: chatdetails as NSDictionary)
    }
    
    func cafefile(messageInfo : NSDictionary)
    {
        if let filedictionary = messageInfo.value(forKey: "file") as? NSDictionary
        {
            let userid = String(format: "%@", messageInfo.value(forKey: "sendId") as! CVarArg)
            let teamid = String(format: "%@", messageInfo.value(forKey: "teamId") as! CVarArg)
            let imagepath = String(format: "%@", filedictionary.value(forKey: "path") as! CVarArg)
            let date = String(format: "%@", messageInfo.value(forKey: "sendTime") as! CVarArg)
            let title = String(format: "%@", filedictionary.value(forKey: "title") as! CVarArg)
            let caption = String(format: "%@", filedictionary.value(forKey: "caption") as! CVarArg)
            let username = String(format: "%@ %@", messageInfo.value(forKey: "sendFirstName") as! CVarArg,messageInfo.value(forKey: "sendLastName") as! CVarArg)
            
            var data : NSData!
            
            do {
                
                let imagestring = String(format: "%@%@", kfilePath,imagepath)
                let fileUrl = NSURL(string: imagestring)
                data = try NSData(contentsOf: fileUrl! as URL, options: NSData.ReadingOptions())
                
                if let image = UIImage(data: data as Data)
                {
                    let resizeimage : UIImage
                    
                    if (image.size.width)>screenWidth
                    {
                        resizeimage = image.resizeWith(width: screenWidth)!
                    }
                    else
                    {
                        resizeimage = image
                    }
                    
                    print("resizeimage => \(resizeimage)")
                    
                    self.createfilefolder(imageData: (resizeimage.lowestQualityJPEGNSData), imagepath: (fileUrl?.lastPathComponent)!)
                }
                else
                {
                    if data.length > 0
                    {
                        self.createfilefolder(imageData: data, imagepath: (fileUrl?.lastPathComponent)!)
                    }
                }
                
            } catch {
                print(error)
            }
            
            let formatter = ByteCountFormatter()
            formatter.allowedUnits = ByteCountFormatter.Units.useAll
            let filesize = formatter.string(fromByteCount: Int64((data?.length)!))
            print("filesize =>\(filesize)")
            
            let chatdetails = ["userid":userid, "username":username, "message":"", "date":date, "teamid":teamid, "imagepath":imagepath, "msgid":String(format: "%@", messageInfo.value(forKey: "messageId") as! CVarArg), "imagetitle":title, "filesize":filesize, "filecaption":caption, "starmsg":"0"] as [String : Any]
            
            self.saveCafeChatDetails(chatdetails: chatdetails as NSDictionary)
        }
    }
    
    func cafeeditmsg(messageInfo : NSDictionary)
    {
        let msgId = String(format: "%@", messageInfo.value(forKey: "messageId") as! CVarArg)
        let message = String(format: "%@", messageInfo.value(forKey: "message") as! CVarArg)
        
        let editmessage = String(format: "%@ (edited)", message)
        
        do {
            let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "CafeChat")
            fetchRequest.returnsObjectsAsFaults = false
            
            let predicate = NSPredicate(format: "msgid = %@", msgId)
            fetchRequest.predicate = predicate
            
            let results =
                try managedContext.fetch(fetchRequest)
            let editMessages = results as! [NSManagedObject]
            if editMessages.count>0
            {
                let getmanageObj = editMessages[0]
                print("getmanageObj =>\(getmanageObj)")
                
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
                    
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "CafeChat_Refresh"), object: nil)
                    
                } catch let error as NSError  {
                    print("Could not save \(error), \(error.userInfo)")
                }
            }
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    func cafedeletemsg(messageInfo : NSDictionary)
    {
        let msgId = String(format: "%@", messageInfo.value(forKey: "messageId") as! CVarArg)
        
        do {
            let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "CafeChat")
            fetchRequest.returnsObjectsAsFaults = false
            
            let predicate = NSPredicate(format: "msgid = %@", msgId)
            fetchRequest.predicate = predicate
            
            let results =
                try managedContext.fetch(fetchRequest)
            let deleteMessages = results as! [NSManagedObject]
            if deleteMessages.count>0
            {
                for i in 0 ..< deleteMessages.count
                {
                    let getmanageObj = deleteMessages[i]
                    managedContext.delete(getmanageObj);
                }
                
                do {
                    
                    try managedContext.save()
                    
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "CafeChat_Update"), object: nil)
                    
                } catch let error as NSError  {
                    print("Could not save \(error), \(error.userInfo)")
                }
            }
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    func cafesharemsg(messageInfo : NSDictionary)
    {
        if let shareDetails = messageInfo.value(forKey: "shareInfo") as? NSDictionary
        {
            let msgId = messageInfo.value(forKey: "messageId") as? String
            let sharemsg = messageInfo.value(forKey: "message") as? String
            let sharename = String(format: "%@ %@", shareDetails.value(forKey: "firstName") as! CVarArg,shareDetails.value(forKey: "lastName") as! CVarArg)
            let sharedate = shareDetails.value(forKey: "time") as? String
            let shareuserid = shareDetails.value(forKey: "userId") as? String
            let shareteamid = messageInfo.value(forKey: "teamId") as? String
            let userid = messageInfo.value(forKey: "sendId") as? String
            let username = String(format: "%@ %@", messageInfo.value(forKey: "sendFirstName") as! CVarArg,messageInfo.value(forKey: "sendLastName") as! CVarArg)
            
            let infostring = shareDetails.value(forKey: "info") as? String
            var message = ""
            if infostring == "message" || infostring == "share"
            {
                message = String(format: "%@", shareDetails.value(forKey: "message") as! CVarArg)
            }
            var imagepath = ""
            var imagetitle = ""
            var filesize = ""
            var filecaption = ""
            if infostring == "file"
            {
                imagepath = String(format: "%@", shareDetails.value(forKey: "path") as! CVarArg)
                imagetitle = String(format: "%@", shareDetails.value(forKey: "title") as! CVarArg)
                filecaption = String(format: "%@", shareDetails.value(forKey: "caption") as! CVarArg)
                
                let filestring = String(format: "%@%@", kfilePath,imagepath)
                let fileUrl = NSURL(string: filestring)
                let data = NSData(contentsOf: fileUrl as! URL)
                
                let formatter = ByteCountFormatter()
                formatter.allowedUnits = ByteCountFormatter.Units.useAll
                filesize = formatter.string(fromByteCount: Int64((data?.length)!))
                print("filesize =>\(filesize)")
            }
            var cmtid = ""
            if infostring == "comment"
            {
                cmtid = String(format: "%@", shareDetails.value(forKey: "messageId") as! CVarArg)
                imagetitle = String(format: "%@", shareDetails.value(forKey: "title") as! CVarArg)
            }
            let date = messageInfo.value(forKey: "sendTime") as? String
            let teamid = messageInfo.value(forKey: "teamId") as? String
            let shareid = shareDetails.value(forKey: "messageId") as? String
            
            let sharedetails = ["shareid":shareid!, "sharemessage":sharemsg!, "sharename":sharename, "sharedate":sharedate!, "shareuserid":shareuserid!, "shareteamid":shareteamid!] as [String : Any]
            
            if cmtid == ""
            {
                let chatdetails = ["userid":userid!, "username":username, "message":message, "date":date!, "teamid":teamid!, "imagepath":imagepath, "msgid": msgId!, "type": "Share", "commentdetails":"", "sharedetails":sharedetails, "imagetitle":imagetitle, "filesize":filesize, "filecaption":filecaption, "starmsg":"0"] as [String : Any]
                
                self.saveCafeChatDetails(chatdetails: chatdetails as NSDictionary)
            }
            else
            {
                let cmtusername = sharename
                let cmtsenderusername = sharename
                let cmtmsg = String(format: "%@", shareDetails.value(forKey: "comment") as! CVarArg)
                
                let cmtdetails = ["username":cmtusername, "userid":"", "cmtmsg":cmtmsg, "senderusername":cmtsenderusername, "senderuserid":userid!, "cmtid":cmtid] as [String : Any]
                
                let chatdetails = ["userid":userid!, "username":username, "message":message, "date":date!, "teamid":teamid!, "imagepath":imagepath, "msgid": msgId!, "type": "Share", "commentdetails":cmtdetails, "sharedetails":sharedetails, "imagetitle":imagetitle, "filesize":filesize, "filecaption":filecaption, "starmsg":"0"] as [String : Any]
                
                self.saveCafeChatDetails(chatdetails: chatdetails as NSDictionary)
            }
        }
    }
    
    func cafecomment(messageInfo : NSDictionary)
    {
        if let filedictionary = messageInfo.value(forKey: "file") as? NSDictionary
        {
            let userid = String(format: "%@", messageInfo.value(forKey: "sendId") as! CVarArg)
            let teamid = String(format: "%@", messageInfo.value(forKey: "teamId") as! CVarArg)
            let msgid = String(format: "%@", filedictionary.value(forKey: "fileId") as! CVarArg)
            let cmtId = String(format: "%@", messageInfo.value(forKey: "messageId") as! CVarArg)
            let username = String(format: "%@ %@", messageInfo.value(forKey: "sendFirstName") as! CVarArg, messageInfo.value(forKey: "sendLastName") as! CVarArg)
            let cmtmsg = String(format: "%@", messageInfo.value(forKey: "comment") as! CVarArg)
            let date = String(format: "%@", messageInfo.value(forKey: "sendTime") as! CVarArg)
            
            let cmtdetails = ["userid":userid, "username":username, "cmtmsg":cmtmsg, "date":date, "teamid":teamid, "msgid": msgid, "cmtid": cmtId, "starmsg":"0"] as [String : Any]
            
            self.saveCafeCommentDetails(chatdetails: cmtdetails as NSDictionary)
            
            //                let userdictionary = messageInfo.value(forKey: "sself") as? NSDictionary
            //                let selfstring = String(format: "%@", userdictionary?.value(forKey: "SELF") as! CVarArg)
            //                if selfstring=="0"
            //                {
            //                    username = String(format: "%@", userdictionary?.value(forKey: "NAME") as! CVarArg)
            //                    userid = String(format: "%@", userdictionary?.value(forKey: "SUSERID") as! CVarArg)
            //                }
            
            let chatcmtdetails = ["username":username, "userid":userid, "cmtmsg":cmtmsg, "senderusername":username, "senderuserid":userid, "cmtid":cmtId, "starmsg":"0"] as [String : Any]
            print("chatcmtdetails =>\(chatcmtdetails)")
            
            self.saveCafeChatCmtDetails(cmtdetails: chatcmtdetails as NSDictionary, msgId: msgid)
        }
    }
    
    func cafeeditcomment(messageInfo : NSDictionary)
    {
        let message = String(format: "%@ (edited)", messageInfo.value(forKey: "comment") as! CVarArg)
        let msgid = String(format: "%@", messageInfo.value(forKey: "fileId") as! CVarArg)
        let cmtId = String(format: "%@", messageInfo.value(forKey: "messageId") as! CVarArg)
        
        do {
            let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "CafeComment")
            fetchRequest.returnsObjectsAsFaults = false
            
            let predicate = NSPredicate(format: "cmtid = %@", cmtId)
            fetchRequest.predicate = predicate
            
            let results =
                try managedContext.fetch(fetchRequest)
            let editMessages = results as! [NSManagedObject]
            if editMessages.count>0
            {
                let getmanageObj = editMessages[0]
                getmanageObj.setValue(message, forKey: "cmtmsg")
                
                do {
                    
                    try managedContext.save()
                    
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Details_Update"), object: nil)
                    
                } catch let error as NSError  {
                    print("Could not save \(error), \(error.userInfo)")
                }
            }
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        self.updateCafecommentmessage(msgId: msgid, cmtId: cmtId, message: message)
    }
    
    func cafedeletecomment(messageInfo : NSDictionary)
    {
        let msgid = String(format: "%@", messageInfo.value(forKey: "fileId") as! CVarArg)
        let cmtId = String(format: "%@", messageInfo.value(forKey: "messageId") as! CVarArg)
        
        do {
            let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "CafeComment")
            fetchRequest.returnsObjectsAsFaults = false
            
            let predicate = NSPredicate(format: "cmtid= %@", cmtId)
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
                    
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Details_Update"), object: nil)
                    
                } catch let error as NSError  {
                    print("Could not save \(error), \(error.userInfo)")
                }
                
                self.deleteCafecommentmessage(msgId: msgid, cmtId: cmtId)
            }
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    func directmsg(messageInfo : NSDictionary)
    {
        let userid = String(format: "%@", messageInfo.value(forKey: "sendId") as! CVarArg)
        let teamid = String(format: "%@", messageInfo.value(forKey: "teamId") as! CVarArg)
        let date = String(format: "%@", messageInfo.value(forKey: "sendTime") as! CVarArg)
        let username = String(format: "%@ %@", messageInfo.value(forKey: "sendFirstName") as! CVarArg,messageInfo.value(forKey: "sendLastName") as! CVarArg)
        let msg = String(format: "%@", messageInfo.value(forKey: "message") as! CVarArg)
        let msgid = String(format: "%@", messageInfo.value(forKey: "messageId") as! CVarArg)
        
        let chatdetails = ["userid":userid, "username":username, "message":msg, "date":date, "teamid":teamid, "imagepath":"", "msgid":msgid, "imagetitle":"", "filesize":"", "filecaption":"", "type":"message", "sendertype":"left", "senderuserid":userid, "starmsg":"0"] as [String : Any]
        
        self.saveOneToOneChatDetails(chatdetails: chatdetails as NSDictionary)
    }
    
    func directfile(messageInfo : NSDictionary)
    {
        if let filedictionary = messageInfo.value(forKey: "file") as? NSDictionary
        {
            let userid = String(format: "%@", messageInfo.value(forKey: "sendId") as! CVarArg)
            let teamid = String(format: "%@", messageInfo.value(forKey: "teamId") as! CVarArg)
            let imagepath = String(format: "%@", filedictionary.value(forKey: "path") as! CVarArg)
            let date = String(format: "%@", messageInfo.value(forKey: "sendTime") as! CVarArg)
            let title = String(format: "%@", filedictionary.value(forKey: "title") as! CVarArg)
            let caption = String(format: "%@", filedictionary.value(forKey: "caption") as! CVarArg)
            let username = String(format: "%@ %@", messageInfo.value(forKey: "sendFirstName") as! CVarArg,messageInfo.value(forKey: "sendLastName") as! CVarArg)
            
            var data : NSData!
            var filetype : String!
            
            do {
                
                let imagestring = String(format: "%@%@", kfilePath,imagepath)
                let fileUrl = NSURL(string: imagestring)
                data = try NSData(contentsOf: fileUrl! as URL, options: NSData.ReadingOptions())
                
                if let image = UIImage(data: data as Data)
                {
                    filetype = "image"
                    
                    let resizeimage : UIImage
                    
                    if (image.size.width)>screenWidth
                    {
                        resizeimage = image.resizeWith(width: screenWidth)!
                    }
                    else
                    {
                        resizeimage = image
                    }
                    
                    print("resizeimage => \(resizeimage)")
                    
                    self.createfilefolder(imageData: (resizeimage.lowestQualityJPEGNSData), imagepath: (fileUrl?.lastPathComponent)!)
                }
                else
                {
                    if data.length > 0
                    {
                        filetype = "file"
                        
                        self.createfilefolder(imageData: data, imagepath: (fileUrl?.lastPathComponent)!)
                    }
                }
                
            } catch {
                print(error)
            }
            
            let formatter = ByteCountFormatter()
            formatter.allowedUnits = ByteCountFormatter.Units.useAll
            let filesize = formatter.string(fromByteCount: Int64((data?.length)!))
            print("filesize =>\(filesize)")
            
            let chatdetails = ["userid":userid, "username":username, "message":"", "date":date, "teamid":teamid, "imagepath":imagepath, "msgid":String(format: "%@", messageInfo.value(forKey: "messageId") as! CVarArg), "imagetitle":title, "filesize":filesize, "filecaption":caption, "type":filetype, "sendertype":"left", "senderuserid":userid, "starmsg":"0"] as [String : Any]
            
            self.saveOneToOneChatDetails(chatdetails: chatdetails as NSDictionary)
        }
    }
    
    func directeditmsg(messageInfo : NSDictionary)
    {
        let msgId = String(format: "%@", messageInfo.value(forKey: "messageId") as! CVarArg)
        let message = String(format: "%@", messageInfo.value(forKey: "message") as! CVarArg)
        
        let editmessage = String(format: "%@ (edited)", message)
        
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
                print("getmanageObj =>\(getmanageObj)")
                
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
                    
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DirectChat_Refresh"), object: nil)
                    
                } catch let error as NSError  {
                    print("Could not save \(error), \(error.userInfo)")
                }
            }
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    func directdeletemsg(messageInfo : NSDictionary)
    {
        let msgId = String(format: "%@", messageInfo.value(forKey: "messageId") as! CVarArg)
        
        do {
            let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "OneToOne")
            fetchRequest.returnsObjectsAsFaults = false
            
            let predicate = NSPredicate(format: "msgid = %@", msgId)
            fetchRequest.predicate = predicate
            
            let results =
                try managedContext.fetch(fetchRequest)
            let deleteMessages = results as! [NSManagedObject]
            if deleteMessages.count>0
            {
                for i in 0 ..< deleteMessages.count
                {
                    let getmanageObj = deleteMessages[i]
                    managedContext.delete(getmanageObj);
                }
                
                do {
                    
                    try managedContext.save()
                    
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DirectChat_Update"), object: nil)
                    
                } catch let error as NSError  {
                    print("Could not save \(error), \(error.userInfo)")
                }
            }
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    func directsharemsg(messageInfo : NSDictionary)
    {
        if let shareDetails = messageInfo.value(forKey: "shareInfo") as? NSDictionary
        {
            let msgId = messageInfo.value(forKey: "messageId") as? String
            let sharemsg = messageInfo.value(forKey: "message") as? String
            let sharename = String(format: "%@ %@", shareDetails.value(forKey: "recFirstName") as! CVarArg,shareDetails.value(forKey: "recLastName") as! CVarArg)
            let sharedate = shareDetails.value(forKey: "time") as? String
            let shareuserid = messageInfo.value(forKey: "recUserId") as? String
            let shareteamid = messageInfo.value(forKey: "teamId") as? String
            let userid = messageInfo.value(forKey: "sendId") as? String
            let username = String(format: "%@ %@", messageInfo.value(forKey: "sendFirstName") as! CVarArg,messageInfo.value(forKey: "sendLastName") as! CVarArg)
            
            let infostring = shareDetails.value(forKey: "info") as? String
            var message = ""
            if infostring == "message" || infostring == "share"
            {
                message = String(format: "%@", shareDetails.value(forKey: "message") as! CVarArg)
            }
            var imagepath = ""
            var imagetitle = ""
            var filesize = ""
            var filecaption = ""
            if infostring == "file"
            {
                imagepath = String(format: "%@", shareDetails.value(forKey: "path") as! CVarArg)
                imagetitle = String(format: "%@", shareDetails.value(forKey: "title") as! CVarArg)
                filecaption = String(format: "%@", shareDetails.value(forKey: "caption") as! CVarArg)
                
                let filestring = String(format: "%@%@", kfilePath,imagepath)
                let fileUrl = NSURL(string: filestring)
                let data = NSData(contentsOf: fileUrl! as URL)
                
                let formatter = ByteCountFormatter()
                formatter.allowedUnits = ByteCountFormatter.Units.useAll
                filesize = formatter.string(fromByteCount: Int64((data?.length)!))
                print("filesize =>\(filesize)")
            }
            var cmtid = ""
            if infostring == "comment"
            {
                cmtid = String(format: "%@", shareDetails.value(forKey: "messageId") as! CVarArg)
                imagetitle = String(format: "%@", shareDetails.value(forKey: "title") as! CVarArg)
            }
            let date = messageInfo.value(forKey: "sendTime") as? String
            let teamid = messageInfo.value(forKey: "teamId") as? String
            let shareid = shareDetails.value(forKey: "messageId") as? String
            
            let sharedetails = ["shareid":shareid!, "sharemessage":sharemsg!, "sharename":sharename, "sharedate":sharedate!, "shareuserid":shareuserid!, "shareteamid":shareteamid!] as [String : Any]
            
            if cmtid == ""
            {
                let chatdetails = ["userid":userid!, "username":username, "message":message, "date":date!, "teamid":teamid!, "imagepath":imagepath, "msgid": msgId!, "type": "share", "commentdetails":"", "sharedetails":sharedetails, "imagetitle":imagetitle, "filesize":filesize, "filecaption":filecaption, "sendertype":"left", "senderuserid":userid!, "starmsg":"0"] as [String : Any]
                
                self.saveOneToOneChatDetails(chatdetails: chatdetails as NSDictionary)
            }
            else
            {
                let cmtusername = sharename
                let cmtsenderusername = sharename
                let cmtmsg = String(format: "%@", shareDetails.value(forKey: "comment") as! CVarArg)
                
                let cmtdetails = ["username":cmtusername, "userid":"", "cmtmsg":cmtmsg, "senderusername":cmtsenderusername, "senderuserid":userid!, "cmtid":cmtid] as [String : Any]
                
                let chatdetails = ["userid":userid!, "username":username, "message":message, "date":date!, "teamid":teamid!, "imagepath":imagepath, "msgid": msgId!, "type": "share", "commentdetails":cmtdetails, "sharedetails":sharedetails, "imagetitle":imagetitle, "filesize":filesize, "filecaption":filecaption, "sendertype":"left", "senderuserid":userid!, "starmsg":"0"] as [String : Any]
                
                self.saveOneToOneChatDetails(chatdetails: chatdetails as NSDictionary)
            }
        }
    }
    
    func directcomment(messageInfo : NSDictionary)
    {
        if let filedictionary = messageInfo.value(forKey: "file") as? NSDictionary
        {
            let userid = String(format: "%@", messageInfo.value(forKey: "sendId") as! CVarArg)
            let teamid = String(format: "%@", messageInfo.value(forKey: "teamId") as! CVarArg)
            let msgid = String(format: "%@", filedictionary.value(forKey: "fileId") as! CVarArg)
            let cmtId = String(format: "%@", messageInfo.value(forKey: "messageId") as! CVarArg)
            let username = String(format: "%@ %@", messageInfo.value(forKey: "sendFirstName") as! CVarArg, messageInfo.value(forKey: "sendLastName") as! CVarArg)
            let cmtmsg = String(format: "%@", messageInfo.value(forKey: "comment") as! CVarArg)
            let date = String(format: "%@", messageInfo.value(forKey: "sendTime") as! CVarArg)
            
            let cmtdetails = ["userid":userid, "username":username, "cmtmsg":cmtmsg, "date":date, "teamid":teamid, "msgid": msgid, "cmtid": cmtId, "starmsg":"0"] as [String : Any]
            
            self.saveOneToOneCommentDetails(chatdetails: cmtdetails as NSDictionary)
            
            let chatcmtdetails = ["username":username, "userid":userid, "cmtmsg":cmtmsg, "senderusername":username, "senderuserid":userid, "cmtid":cmtId, "starmsg":"0"] as [String : Any]
            print("chatcmtdetails =>\(chatcmtdetails)")
            
            self.saveOneToOneChatCmtDetails(cmtdetails: chatcmtdetails as NSDictionary, msgId: msgid, sendertype: "left")
        }
    }
    
    func directeditcomment(messageInfo : NSDictionary)
    {
        let message = String(format: "%@ (edited)", messageInfo.value(forKey: "comment") as! CVarArg)
        let msgid = String(format: "%@", messageInfo.value(forKey: "fileId") as! CVarArg)
        let cmtId = String(format: "%@", messageInfo.value(forKey: "messageId") as! CVarArg)
        
        do {
            let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "OneToOneComment")
            fetchRequest.returnsObjectsAsFaults = false
            
            let predicate = NSPredicate(format: "cmtid = %@", cmtId)
            fetchRequest.predicate = predicate
            
            let results =
                try managedContext.fetch(fetchRequest)
            let editMessages = results as! [NSManagedObject]
            if editMessages.count>0
            {
                let getmanageObj = editMessages[0]
                getmanageObj.setValue(message, forKey: "cmtmsg")
                
                do {
                    
                    try managedContext.save()
                    
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Details_Update"), object: nil)
                    
                } catch let error as NSError  {
                    print("Could not save \(error), \(error.userInfo)")
                }
            }
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        self.updateOneToOnecommentmessage(msgId: msgid, cmtId: cmtId, message: message)
    }
    
    func directdeletecomment(messageInfo : NSDictionary)
    {
        let msgid = String(format: "%@", messageInfo.value(forKey: "fileId") as! CVarArg)
        let cmtId = String(format: "%@", messageInfo.value(forKey: "messageId") as! CVarArg)
        
        do {
            let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "OneToOneComment")
            fetchRequest.returnsObjectsAsFaults = false
            
            let predicate = NSPredicate(format: "cmtid= %@", cmtId)
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
                    
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Details_Update"), object: nil)
                    
                } catch let error as NSError  {
                    print("Could not save \(error), \(error.userInfo)")
                }
                
                self.deleteOneToOnecommentmessage(msgId: msgid, cmtId: cmtId)
            }
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    func directlinkmsg(messageInfo : NSDictionary)
    {
        let msgid = String(format: "%@", messageInfo.value(forKey: "messageId") as! CVarArg)
        let title = String(format: "%@", messageInfo.value(forKey: "title") as! CVarArg)
        let description = String(format: "%@", messageInfo.value(forKey: "description") as! CVarArg)
        let url = String(format: "%@", messageInfo.value(forKey: "url") as! CVarArg)
        let favicon = String(format: "%@", messageInfo.value(forKey: "favicon") as! CVarArg)
        
        let linkdetails = ["title":title, "description":description, "url":url, "favicon":favicon] as [String : Any]
        
        do {
            let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "OneToOne")
            fetchRequest.returnsObjectsAsFaults = false
            
            let msgid = NSPredicate(format: "msgid = %@", msgid)
            fetchRequest.predicate = msgid
            
            let results =
                try managedContext.fetch(fetchRequest)
            let messages = results as! [NSManagedObject]
            if messages.count>0
            {
                let getmanageObj = messages[0]
                
                getmanageObj.setValue(linkdetails, forKey: "linkdetails")
                getmanageObj.setValue("link", forKey: "type")
                
                do {
                    
                    try managedContext.save()
                    
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DirectChat_Update"), object: nil)
                    
                } catch let error as NSError  {
                    print("Could not save \(error), \(error.userInfo)")
                }
            }
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }

    func groupmsg(messageInfo : NSDictionary)
    {
        let userid = String(format: "%@", messageInfo.value(forKey: "sendId") as! CVarArg)
        let groupid = String(format: "%@", messageInfo.value(forKey: "groupId") as! CVarArg)
        let teamid = String(format: "%@", messageInfo.value(forKey: "teamId") as! CVarArg)
        let date = String(format: "%@", messageInfo.value(forKey: "sendTime") as! CVarArg)
        let username = String(format: "%@ %@", messageInfo.value(forKey: "sendFirstName") as! CVarArg,messageInfo.value(forKey: "sendLastName") as! CVarArg)
        let msg = String(format: "%@", messageInfo.value(forKey: "message") as! CVarArg)
        let msgid = String(format: "%@", messageInfo.value(forKey: "messageId") as! CVarArg)
        
        let chatdetails = ["userid":userid, "username":username, "message":msg, "date":date, "groupid":groupid, "teamid":teamid, "imagepath":"", "msgid":msgid, "imagetitle":"", "filesize":"", "filecaption":"",  "starmsg":"0"] as [String : Any]
        
        self.saveChatDetails(chatdetails: chatdetails as NSDictionary)
        
        if(!commonmethodClass.getGroupChatVisibleViewcontroller())
        {
            self.showbanner(title: username, subtitle: msg, chattype: "groupChat")
        }
    }
    
    func groupfile(messageInfo : NSDictionary)
    {
        if let filedictionary = messageInfo.value(forKey: "file") as? NSDictionary
        {
            let userid = String(format: "%@", messageInfo.value(forKey: "sendId") as! CVarArg)
            let groupid = String(format: "%@", messageInfo.value(forKey: "groupId") as! CVarArg)
            let teamid = String(format: "%@", messageInfo.value(forKey: "teamId") as! CVarArg)
            let imagepath = String(format: "%@", filedictionary.value(forKey: "path") as! CVarArg)
            let date = String(format: "%@", messageInfo.value(forKey: "sendTime") as! CVarArg)
            let title = String(format: "%@", filedictionary.value(forKey: "title") as! CVarArg)
            let caption = String(format: "%@", filedictionary.value(forKey: "caption") as! CVarArg)
            let username = String(format: "%@ %@", messageInfo.value(forKey: "sendFirstName") as! CVarArg,messageInfo.value(forKey: "sendLastName") as! CVarArg)
            
            let imagestring = String(format: "%@%@", kfilePath,imagepath)
            let fileUrl = NSURL(string: imagestring)
            
            let queue = DispatchQueue.global(qos: .default)
            queue.async(execute: {() -> Void in
                do {
                    
                    let data = try NSData(contentsOf: fileUrl! as URL, options: NSData.ReadingOptions())
                    if let image = UIImage(data: data as Data)
                    {
                        let resizeimage : UIImage
                        if (image.size.width)>screenWidth
                        {
                            resizeimage = image.resizeWith(width: screenWidth)!
                        }
                        else
                        {
                            resizeimage = image
                        }
                        self.createfilefolder(imageData: (resizeimage.lowestQualityJPEGNSData), imagepath: (fileUrl?.lastPathComponent)!)
                    }
                    else
                    {
                        if data.length > 0
                        {
                            self.createfilefolder(imageData: data, imagepath: (fileUrl?.lastPathComponent)!)
                        }
                    }
                    let formatter = ByteCountFormatter()
                    formatter.allowedUnits = ByteCountFormatter.Units.useAll
                    let filesize = formatter.string(fromByteCount: Int64((data.length)))
                    print("filesize =>\(filesize)")
                    
                    let chatdetails = ["userid":userid, "username":username, "message":"", "date":date, "groupid":groupid, "teamid":teamid, "imagepath":imagepath, "msgid":String(format: "%@", messageInfo.value(forKey: "messageId") as! CVarArg), "imagetitle":title, "filesize":filesize, "filecaption":caption, "starmsg":"0"] as [String : Any]
                    
                    DispatchQueue.main.async(execute: {() -> Void in
                        self.saveChatDetails(chatdetails: chatdetails as NSDictionary)
                        if(!self.commonmethodClass.getGroupChatVisibleViewcontroller())
                        {
                            self.showbanner(title: username, subtitle: String(format: "%@ : %@", socketOnReponse.value(forKey: "fileReceive") as! CVarArg, title), chattype: "groupChat")
                        }
                    })
                    
                } catch {
                    print(error)
                }
            })
        }
    }
    
    func groupeditmsg(messageInfo : NSDictionary)
    {
        let msgId = String(format: "%@", messageInfo.value(forKey: "messageId") as! CVarArg)
        let message = String(format: "%@", messageInfo.value(forKey: "message") as! CVarArg)
        
        let editmessage = String(format: "%@ (edited)", message)
        
        do {
            let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "GroupChat")
            fetchRequest.returnsObjectsAsFaults = false
            
            let predicate = NSPredicate(format: "msgid = %@", msgId)
            fetchRequest.predicate = predicate
            
            let results =
                try managedContext.fetch(fetchRequest)
            let editMessages = results as! [NSManagedObject]
            if editMessages.count>0
            {
                let getmanageObj = editMessages[0]
                print("getmanageObj =>\(getmanageObj)")
                
                if let shareDetails = getmanageObj.value(forKey: "sharedetails") as? NSDictionary
                {
                    let shareid = shareDetails.value(forKey: "shareid") as? String
                    let sharename = shareDetails.value(forKey: "sharename") as? String
                    let sharedate = shareDetails.value(forKey: "sharedate") as? String
                    let shareuserid = shareDetails.value(forKey: "shareuserid") as? String
                    let sharegroupid = shareDetails.value(forKey: "sharegroupid") as? String
                    let shareteamid = shareDetails.value(forKey: "shareteamid") as? String
                    
                    let sharedetails = ["shareid":shareid!, "sharemessage":editmessage, "sharename":sharename!, "sharedate":sharedate!, "shareuserid":shareuserid!, "sharegroupid":sharegroupid!, "shareteamid":shareteamid!] as [String : Any]
                    
                    getmanageObj.setValue(sharedetails, forKey: "sharedetails")
                }
                else
                {
                    getmanageObj.setValue(editmessage, forKey: "message")
                }
                
                do {
                    try managedContext.save()
                    
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "GroupChat_Refresh"), object: nil)
                    
                    if(!self.commonmethodClass.getGroupChatVisibleViewcontroller())
                    {
                        let username = getmanageObj.value(forKey: "username") as? String
                        self.showbanner(title: username!, subtitle: String(format: "%@ : %@", "Edit a Message", message), chattype: "groupChat")
                    }
                    
                } catch let error as NSError  {
                    print("Could not save \(error), \(error.userInfo)")
                }
            }
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    func groupdeletemsg(messageInfo : NSDictionary)
    {
        let msgId = String(format: "%@", messageInfo.value(forKey: "messageId") as! CVarArg)
        
        do {
            let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "GroupChat")
            fetchRequest.returnsObjectsAsFaults = false
            
            let predicate = NSPredicate(format: "msgid = %@", msgId)
            fetchRequest.predicate = predicate
            
            let results =
                try managedContext.fetch(fetchRequest)
            let deleteMessages = results as! [NSManagedObject]
            if deleteMessages.count>0
            {
                for i in 0 ..< deleteMessages.count
                {
                    let getmanageObj = deleteMessages[i]
                    managedContext.delete(getmanageObj);
                }
                
                do {
                    
                    try managedContext.save()
                    
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "GroupChat_Update"), object: nil)
                    
                    if(!self.commonmethodClass.getGroupChatVisibleViewcontroller())
                    {
                        self.showbanner(title: "", subtitle: String(format: "%@", "Delete a Message"), chattype: "groupChat")
                    }
                    
                } catch let error as NSError  {
                    print("Could not save \(error), \(error.userInfo)")
                }
            }
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    func groupsharemsg(messageInfo : NSDictionary)
    {
        if let shareDetails = messageInfo.value(forKey: "shareInfo") as? NSDictionary
        {
            let msgId = messageInfo.value(forKey: "messageId") as? String
            let sharemsg = messageInfo.value(forKey: "message") as? String
            let sharename = String(format: "%@ %@", shareDetails.value(forKey: "firstName") as! CVarArg,shareDetails.value(forKey: "lastName") as! CVarArg)
            let sharedate = shareDetails.value(forKey: "time") as? String
            let shareuserid = shareDetails.value(forKey: "userId") as? String
            let sharegroupid = messageInfo.value(forKey: "groupId") as? String
            let shareteamid = messageInfo.value(forKey: "teamId") as? String
            let userid = messageInfo.value(forKey: "sendId") as? String
            let username = String(format: "%@ %@", messageInfo.value(forKey: "sendFirstName") as! CVarArg,messageInfo.value(forKey: "sendLastName") as! CVarArg)
            
            let infostring = shareDetails.value(forKey: "info") as? String
            var message = ""
            if infostring == "message" || infostring == "share"
            {
                message = String(format: "%@", shareDetails.value(forKey: "message") as! CVarArg)
            }
            var imagepath = ""
            var imagetitle = ""
            var filesize = ""
            var filecaption = ""
            if infostring == "file"
            {
                imagepath = String(format: "%@", shareDetails.value(forKey: "path") as! CVarArg)
                imagetitle = String(format: "%@", shareDetails.value(forKey: "title") as! CVarArg)
                filecaption = String(format: "%@", shareDetails.value(forKey: "caption") as! CVarArg)
                
                let filestring = String(format: "%@%@", kfilePath,imagepath)
                let fileUrl = NSURL(string: filestring)
                let data = NSData(contentsOf: fileUrl! as URL)
                
                let formatter = ByteCountFormatter()
                formatter.allowedUnits = ByteCountFormatter.Units.useAll
                filesize = formatter.string(fromByteCount: Int64((data?.length)!))
                print("filesize =>\(filesize)")
            }
            var cmtid = ""
            if infostring == "comment"
            {
                cmtid = String(format: "%@", shareDetails.value(forKey: "messageId") as! CVarArg)
                imagetitle = String(format: "%@", shareDetails.value(forKey: "title") as! CVarArg)
            }
            let date = messageInfo.value(forKey: "sendTime") as? String
            let teamid = messageInfo.value(forKey: "teamId") as? String
            let groupid = messageInfo.value(forKey: "groupId") as? String
            let shareid = shareDetails.value(forKey: "messageId") as? String
            
            let sharedetails = ["shareid":shareid!, "sharemessage":sharemsg!, "sharename":sharename, "sharedate":sharedate!, "shareuserid":shareuserid!, "sharegroupid":sharegroupid!, "shareteamid":shareteamid!] as [String : Any]
            
            if cmtid == ""
            {
                let chatdetails = ["userid":userid!, "username":username, "message":message, "date":date!, "teamid":teamid!, "groupid":groupid!, "imagepath":imagepath, "msgid": msgId!, "type": "Share", "commentdetails":"", "sharedetails":sharedetails, "imagetitle":imagetitle, "filesize":filesize, "filecaption":filecaption, "starmsg":"0"] as [String : Any]
                
                self.saveChatDetails(chatdetails: chatdetails as NSDictionary)
            }
            else
            {
                let cmtusername = sharename
                let cmtsenderusername = sharename
                let cmtmsg = String(format: "%@", shareDetails.value(forKey: "comment") as! CVarArg)
                
                let cmtdetails = ["username":cmtusername, "userid":"", "cmtmsg":cmtmsg, "senderusername":cmtsenderusername, "senderuserid":userid!, "cmtid":cmtid] as [String : Any]
                
                let chatdetails = ["userid":userid!, "username":username, "message":message, "date":date!, "teamid":teamid!, "groupid":groupid!, "imagepath":imagepath, "msgid": msgId!, "type": "Share", "commentdetails":cmtdetails, "sharedetails":sharedetails, "imagetitle":imagetitle, "filesize":filesize, "filecaption":filecaption, "starmsg":"0"] as [String : Any]
                
                self.saveChatDetails(chatdetails: chatdetails as NSDictionary)
            }
            
            if(!self.commonmethodClass.getGroupChatVisibleViewcontroller())
            {
                if infostring == "message" || infostring == "share"
                {
                    self.showbanner(title: username, subtitle: String(format: "%@ : %@", socketOnReponse.value(forKey: "shareMessageReceive") as! CVarArg, message), chattype: "groupChat")
                }
                if infostring == "file"
                {
                    self.showbanner(title: username, subtitle: String(format: "%@ : %@", socketOnReponse.value(forKey: "shareFileReceive") as! CVarArg, imagetitle), chattype: "groupChat")
                }
                if infostring == "comment"
                {
                    let cmtmsg = String(format: "%@", shareDetails.value(forKey: "comment") as! CVarArg)

                    self.showbanner(title: username, subtitle: String(format: "%@ : %@", socketOnReponse.value(forKey: "shareCommentReceive") as! CVarArg, cmtmsg), chattype: "groupChat")
                }
            }
        }
    }
    
    func groupcomment(messageInfo : NSDictionary)
    {
        if let filedictionary = messageInfo.value(forKey: "file") as? NSDictionary
        {
            let userid = String(format: "%@", messageInfo.value(forKey: "sendId") as! CVarArg)
            let groupid = String(format: "%@", messageInfo.value(forKey: "groupId") as! CVarArg)
            let teamid = String(format: "%@", messageInfo.value(forKey: "teamId") as! CVarArg)
            let msgid = String(format: "%@", filedictionary.value(forKey: "fileId") as! CVarArg)
            let cmtId = String(format: "%@", messageInfo.value(forKey: "messageId") as! CVarArg)
            let username = String(format: "%@ %@", messageInfo.value(forKey: "sendFirstName") as! CVarArg, messageInfo.value(forKey: "sendLastName") as! CVarArg)
            let cmtmsg = String(format: "%@", messageInfo.value(forKey: "comment") as! CVarArg)
            let date = String(format: "%@", messageInfo.value(forKey: "sendTime") as! CVarArg)
            
            let cmtdetails = ["userid":userid, "username":username, "cmtmsg":cmtmsg, "date":date, "teamid":teamid, "groupid":groupid, "msgid": msgid, "cmtid": cmtId, "starmsg":"0"] as [String : Any]
            
            self.saveCommentDetails(chatdetails: cmtdetails as NSDictionary)
            
            //                let userdictionary = messageInfo.value(forKey: "sself") as? NSDictionary
            //                let selfstring = String(format: "%@", userdictionary?.value(forKey: "SELF") as! CVarArg)
            //                if selfstring=="0"
            //                {
            //                    username = String(format: "%@", userdictionary?.value(forKey: "NAME") as! CVarArg)
            //                    userid = String(format: "%@", userdictionary?.value(forKey: "SUSERID") as! CVarArg)
            //                }
            
            let chatcmtdetails = ["username":username, "userid":userid, "cmtmsg":cmtmsg, "senderusername":username, "senderuserid":userid, "cmtid":cmtId, "starmsg":"0"] as [String : Any]
            print("chatcmtdetails =>\(chatcmtdetails)")
            
            self.saveChatCmtDetails(cmtdetails: chatcmtdetails as NSDictionary, msgId: msgid, date: date)
            
            if(!self.commonmethodClass.getGroupChatVisibleViewcontroller())
            {
                self.showbanner(title: "", subtitle: String(format: "%@", "Add a Comment"), chattype: "groupChat")
            }
        }
    }
    
    func groupeditcomment(messageInfo : NSDictionary)
    {
        let message = String(format: "%@ (edited)", messageInfo.value(forKey: "comment") as! CVarArg)
        let msgid = String(format: "%@", messageInfo.value(forKey: "fileId") as! CVarArg)
        let cmtId = String(format: "%@", messageInfo.value(forKey: "messageId") as! CVarArg)
        
        do {
            let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "GroupComment")
            fetchRequest.returnsObjectsAsFaults = false
            
            let predicate = NSPredicate(format: "cmtid = %@", cmtId)
            fetchRequest.predicate = predicate
            
            let results =
                try managedContext.fetch(fetchRequest)
            let editMessages = results as! [NSManagedObject]
            if editMessages.count>0
            {
                let getmanageObj = editMessages[0]
                getmanageObj.setValue(message, forKey: "cmtmsg")
                
                do {
                    
                    try managedContext.save()
                    
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Details_Update"), object: nil)
                    
                    if(!self.commonmethodClass.getGroupChatVisibleViewcontroller())
                    {
                        self.showbanner(title: "", subtitle: String(format: "%@", "Edit a Comment"), chattype: "groupChat")
                    }
                    
                } catch let error as NSError  {
                    print("Could not save \(error), \(error.userInfo)")
                }
            }
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        self.updatecommentmessage(msgId: msgid, cmtId: cmtId, message: message)
    }
    
    func groupdeletecomment(messageInfo : NSDictionary)
    {
        let msgid = String(format: "%@", messageInfo.value(forKey: "fileId") as! CVarArg)
        let cmtId = String(format: "%@", messageInfo.value(forKey: "messageId") as! CVarArg)
        
        do {
            let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "GroupComment")
            fetchRequest.returnsObjectsAsFaults = false
            
            let predicate = NSPredicate(format: "cmtid= %@", cmtId)
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
                    
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Details_Update"), object: nil)
                    
                    if(!self.commonmethodClass.getGroupChatVisibleViewcontroller())
                    {
                        self.showbanner(title: "", subtitle: String(format: "%@", "Delete a Comment"), chattype: "groupChat")
                    }
                    
                } catch let error as NSError  {
                    print("Could not save \(error), \(error.userInfo)")
                }
                
                self.deletecommentmessage(msgId: msgid, cmtId: cmtId)
            }
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    func grouplinkmsg(messageInfo : NSDictionary)
    {
        let msgid = String(format: "%@", messageInfo.value(forKey: "messageId") as! CVarArg)
        let title = String(format: "%@", messageInfo.value(forKey: "title") as! CVarArg)
        let description = String(format: "%@", messageInfo.value(forKey: "description") as! CVarArg)
        let url = String(format: "%@", messageInfo.value(forKey: "url") as! CVarArg)
        let favicon = String(format: "%@", messageInfo.value(forKey: "favicon") as! CVarArg)
        
        let linkdetails = ["title":title, "description":description, "url":url, "favicon":favicon] as [String : Any]
        
        do {
            let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "GroupChat")
            fetchRequest.returnsObjectsAsFaults = false
            
            let msgid = NSPredicate(format: "msgid = %@", msgid)
            fetchRequest.predicate = msgid
            
            let results =
                try managedContext.fetch(fetchRequest)
            let messages = results as! [NSManagedObject]
            if messages.count>0
            {
                let getmanageObj = messages[0]
                
                getmanageObj.setValue(linkdetails, forKey: "linkdetails")
                getmanageObj.setValue("link", forKey: "type")

                do {
                    
                    try managedContext.save()
                    
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "GroupChat_Update"), object: nil)
                    
                    if(!self.commonmethodClass.getGroupChatVisibleViewcontroller())
                    {
                        self.showbanner(title: "", subtitle: String(format: "%@", "Add a link preview"), chattype: "groupChat")
                    }
                    
                } catch let error as NSError  {
                    print("Could not save \(error), \(error.userInfo)")
                }
            }
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    func deletecommentmessage(msgId : String, cmtId : String)
    {
        do {
            let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "GroupChat")
            fetchRequest.returnsObjectsAsFaults = false
            
            let msgid = NSPredicate(format: "msgid = %@", msgId)
            fetchRequest.predicate = msgid
            
            let results =
                try managedContext.fetch(fetchRequest)
            let deleteMessages = results as! [NSManagedObject]
            if deleteMessages.count>0
            {
                for i in 0 ..< deleteMessages.count
                {
                    let getmanageObj = deleteMessages[i]
                    if let cmtDetails = getmanageObj.value(forKey: "commentdetails") as? NSDictionary
                    {
                        let cmtid = cmtDetails.value(forKey: "cmtid") as? String
                        if cmtid==cmtId
                        {
                            managedContext.delete(getmanageObj)
                            
                            do {
                                
                                try managedContext.save()
                                
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "GroupChat_Update"), object: nil)
                                
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
    
    func deleteCafecommentmessage(msgId : String, cmtId : String)
    {
        do {
            let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "CafeChat")
            fetchRequest.returnsObjectsAsFaults = false
            
            let msgid = NSPredicate(format: "msgid = %@", msgId)
            fetchRequest.predicate = msgid
            
            let results =
                try managedContext.fetch(fetchRequest)
            let deleteMessages = results as! [NSManagedObject]
            if deleteMessages.count>0
            {
                for i in 0 ..< deleteMessages.count
                {
                    let getmanageObj = deleteMessages[i]
                    if let cmtDetails = getmanageObj.value(forKey: "commentdetails") as? NSDictionary
                    {
                        let cmtid = cmtDetails.value(forKey: "cmtid") as? String
                        if cmtid==cmtId
                        {
                            managedContext.delete(getmanageObj)
                            
                            do {
                                
                                try managedContext.save()
                                
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "CafeChat_Update"), object: nil)
                                
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
    
    func deleteOneToOnecommentmessage(msgId : String, cmtId : String)
    {
        do {
            let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "OneToOne")
            fetchRequest.returnsObjectsAsFaults = false
            
            let msgid = NSPredicate(format: "msgid = %@", msgId)
            fetchRequest.predicate = msgid
            
            let results =
                try managedContext.fetch(fetchRequest)
            let deleteMessages = results as! [NSManagedObject]
            if deleteMessages.count>0
            {
                for i in 0 ..< deleteMessages.count
                {
                    let getmanageObj = deleteMessages[i]
                    if let cmtDetails = getmanageObj.value(forKey: "commentdetails") as? NSDictionary
                    {
                        let cmtid = cmtDetails.value(forKey: "cmtid") as? String
                        if cmtid==cmtId
                        {
                            managedContext.delete(getmanageObj)
                            
                            do {
                                
                                try managedContext.save()
                                
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DirectChat_Update"), object: nil)
                                
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
    
    func updatecommentmessage(msgId : String, cmtId : String, message : String)
    {
        do {
            let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "GroupChat")
            fetchRequest.returnsObjectsAsFaults = false
            
            let msgid = NSPredicate(format: "msgid = %@", msgId)
            fetchRequest.predicate = msgid
            
            let results =
                try managedContext.fetch(fetchRequest)
            let editMessages = results as! [NSManagedObject]
            if editMessages.count>0
            {
                for i in 0 ..< editMessages.count
                {
                    let getmanageObj = editMessages[i]
                    if let cmtDetails = getmanageObj.value(forKey: "commentdetails") as? NSDictionary
                    {
                        let cmtid = cmtDetails.value(forKey: "cmtid") as? String
                        if cmtid==cmtId
                        {
                            let commentdetails = cmtDetails.mutableCopy() as? NSMutableDictionary
                            commentdetails?.setValue(message, forKey: "cmtmsg")
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
    
    func updateCafecommentmessage(msgId : String, cmtId : String, message : String)
    {
        do {
            let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "CafeChat")
            fetchRequest.returnsObjectsAsFaults = false
            
            let msgid = NSPredicate(format: "msgid = %@", msgId)
            fetchRequest.predicate = msgid
            
            let results =
                try managedContext.fetch(fetchRequest)
            let editMessages = results as! [NSManagedObject]
            if editMessages.count>0
            {
                for i in 0 ..< editMessages.count
                {
                    let getmanageObj = editMessages[i]
                    if let cmtDetails = getmanageObj.value(forKey: "commentdetails") as? NSDictionary
                    {
                        let cmtid = cmtDetails.value(forKey: "cmtid") as? String
                        if cmtid==cmtId
                        {
                            let commentdetails = cmtDetails.mutableCopy() as? NSMutableDictionary
                            commentdetails?.setValue(message, forKey: "cmtmsg")
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
    
    func updateOneToOnecommentmessage(msgId : String, cmtId : String, message : String)
    {
        do {
            let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "OneToOne")
            fetchRequest.returnsObjectsAsFaults = false
            
            let msgid = NSPredicate(format: "msgid = %@", msgId)
            fetchRequest.predicate = msgid
            
            let results =
                try managedContext.fetch(fetchRequest)
            let editMessages = results as! [NSManagedObject]
            if editMessages.count>0
            {
                for i in 0 ..< editMessages.count
                {
                    let getmanageObj = editMessages[i]
                    if let cmtDetails = getmanageObj.value(forKey: "commentdetails") as? NSDictionary
                    {
                        let cmtid = cmtDetails.value(forKey: "cmtid") as? String
                        if cmtid==cmtId
                        {
                            let commentdetails = cmtDetails.mutableCopy() as? NSMutableDictionary
                            commentdetails?.setValue(message, forKey: "cmtmsg")
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
    
    func saveCommentDetails(chatdetails : NSDictionary)
    {
        print("COMMENT chatdetails=>\(chatdetails)")
        
        let cmtid = String(format: "%@", chatdetails.value(forKey: "cmtid") as! CVarArg)
        if(commonmethodClass.groupChatCmtMsgExist(cmtId: cmtid))
        {
            return
        }
        
        let entity =  NSEntityDescription.entity(forEntityName: "GroupComment",
                                                 in:managedContext)
        let chatdetail = NSManagedObject(entity: entity!,
                                         insertInto: managedContext)
        chatdetail.setValue(chatdetails.value(forKey: "userid"), forKey: "userid")
        chatdetail.setValue(chatdetails.value(forKey: "username"), forKey: "username")
        chatdetail.setValue(chatdetails.value(forKey: "cmtid"), forKey: "cmtid")
        chatdetail.setValue(chatdetails.value(forKey: "cmtmsg"), forKey: "cmtmsg")
        chatdetail.setValue(chatdetails.value(forKey: "date"), forKey: "date")
        chatdetail.setValue(chatdetails.value(forKey: "groupid"), forKey: "groupid")
        chatdetail.setValue(chatdetails.value(forKey: "teamid"), forKey: "teamid")
        chatdetail.setValue(chatdetails.value(forKey: "msgid"), forKey: "msgid")
        chatdetail.setValue(chatdetails.value(forKey: "starmsg"), forKey: "starmsg")

        do {
            
            try managedContext.save()
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Details_Update"), object: nil)
                        
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    func saveCafeCommentDetails(chatdetails : NSDictionary)
    {
        print("COMMENT chatdetails=>\(chatdetails)")
        
        let entity =  NSEntityDescription.entity(forEntityName: "CafeComment",
                                                 in:managedContext)
        let chatdetail = NSManagedObject(entity: entity!,
                                         insertInto: managedContext)
        chatdetail.setValue(chatdetails.value(forKey: "userid"), forKey: "userid")
        chatdetail.setValue(chatdetails.value(forKey: "username"), forKey: "username")
        chatdetail.setValue(chatdetails.value(forKey: "cmtid"), forKey: "cmtid")
        chatdetail.setValue(chatdetails.value(forKey: "cmtmsg"), forKey: "cmtmsg")
        chatdetail.setValue(chatdetails.value(forKey: "date"), forKey: "date")
        chatdetail.setValue(chatdetails.value(forKey: "groupid"), forKey: "groupid")
        chatdetail.setValue(chatdetails.value(forKey: "teamid"), forKey: "teamid")
        chatdetail.setValue(chatdetails.value(forKey: "msgid"), forKey: "msgid")
        chatdetail.setValue(chatdetails.value(forKey: "starmsg"), forKey: "starmsg")

        do {
            
            try managedContext.save()
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Details_Update"), object: nil)
            
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    func saveOneToOneCommentDetails(chatdetails : NSDictionary)
    {
        print("COMMENT chatdetails=>\(chatdetails)")
        
        let entity =  NSEntityDescription.entity(forEntityName: "OneToOneComment",
                                                 in:managedContext)
        let chatdetail = NSManagedObject(entity: entity!,
                                         insertInto: managedContext)
        chatdetail.setValue(chatdetails.value(forKey: "userid"), forKey: "userid")
        chatdetail.setValue(chatdetails.value(forKey: "username"), forKey: "username")
        chatdetail.setValue(chatdetails.value(forKey: "cmtid"), forKey: "cmtid")
        chatdetail.setValue(chatdetails.value(forKey: "cmtmsg"), forKey: "cmtmsg")
        chatdetail.setValue(chatdetails.value(forKey: "date"), forKey: "date")
        chatdetail.setValue(chatdetails.value(forKey: "teamid"), forKey: "teamid")
        chatdetail.setValue(chatdetails.value(forKey: "msgid"), forKey: "msgid")
        chatdetail.setValue(chatdetails.value(forKey: "starmsg"), forKey: "starmsg")

        do {
            
            try managedContext.save()
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Details_Update"), object: nil)
            
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    func saveChatCmtDetails(cmtdetails : NSDictionary, msgId : String, date : String)
    {
        print("cmtdetails=>\(cmtdetails)")
        
        if(commonmethodClass.groupChatCmtDetailsExist(msgId: msgId))
        {
            return
        }
        
        do {
            
            let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "GroupChat")
            fetchRequest.returnsObjectsAsFaults = false
            
            let predicate = NSPredicate(format: "msgid = %@", msgId)
            fetchRequest.predicate = predicate
            
            let results = try managedContext.fetch(fetchRequest) as! [NSManagedObject]
            
            if results.count > 0
            {
                let currentChatMessage = results[0]
                
                let entity =  NSEntityDescription.entity(forEntityName: "GroupChat",
                                                         in:managedContext)
                let chatdetail = NSManagedObject(entity: entity!,
                                                 insertInto: managedContext)
                chatdetail.setValue(currentChatMessage.value(forKey: "loginuserid"), forKey: "loginuserid")
                chatdetail.setValue(currentChatMessage.value(forKey: "userid"), forKey: "userid")
                chatdetail.setValue(currentChatMessage.value(forKey: "username"), forKey: "username")
                chatdetail.setValue(currentChatMessage.value(forKey: "message"), forKey: "message")
                chatdetail.setValue(date, forKey: "date")
                chatdetail.setValue(currentChatMessage.value(forKey: "groupid"), forKey: "groupid")
                chatdetail.setValue(currentChatMessage.value(forKey: "teamid"), forKey: "teamid")
                chatdetail.setValue(currentChatMessage.value(forKey: "imagepath"), forKey: "imagepath")
                chatdetail.setValue(currentChatMessage.value(forKey: "imagetitle"), forKey: "imagetitle")
                chatdetail.setValue(currentChatMessage.value(forKey: "filesize"), forKey: "filesize")
                chatdetail.setValue(currentChatMessage.value(forKey: "filecaption"), forKey: "filecaption")
                chatdetail.setValue(currentChatMessage.value(forKey: "msgid"), forKey: "msgid")
                chatdetail.setValue(currentChatMessage.value(forKey: "starmsg"), forKey: "starmsg")
                chatdetail.setValue(cmtdetails, forKey: "commentdetails")
                
                do {
                    
                    try managedContext.save()
                    
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "GroupChat_Update"), object: nil)
                    
                } catch let error as NSError  {
                    print("Could not save \(error), \(error.userInfo)")
                }
            }
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    func saveCafeChatCmtDetails(cmtdetails : NSDictionary, msgId : String)
    {
        print("cmtdetails=>\(cmtdetails)")
        
        do {
            
            let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "CafeChat")
            fetchRequest.returnsObjectsAsFaults = false
            
            let predicate = NSPredicate(format: "msgid = %@", msgId)
            fetchRequest.predicate = predicate
            
            let results = try managedContext.fetch(fetchRequest) as! [NSManagedObject]
            
            if results.count > 0
            {
                let currentChatMessage = results[0]
                
                let entity =  NSEntityDescription.entity(forEntityName: "CafeChat",
                                                         in:managedContext)
                let chatdetail = NSManagedObject(entity: entity!,
                                                 insertInto: managedContext)
                chatdetail.setValue(currentChatMessage.value(forKey: "loginuserid"), forKey: "loginuserid")
                chatdetail.setValue(currentChatMessage.value(forKey: "userid"), forKey: "userid")
                chatdetail.setValue(currentChatMessage.value(forKey: "username"), forKey: "username")
                chatdetail.setValue(currentChatMessage.value(forKey: "message"), forKey: "message")
                chatdetail.setValue(currentChatMessage.value(forKey: "date"), forKey: "date")
                chatdetail.setValue(currentChatMessage.value(forKey: "teamid"), forKey: "teamid")
                chatdetail.setValue(currentChatMessage.value(forKey: "imagepath"), forKey: "imagepath")
                chatdetail.setValue(currentChatMessage.value(forKey: "imagetitle"), forKey: "imagetitle")
                chatdetail.setValue(currentChatMessage.value(forKey: "filesize"), forKey: "filesize")
                chatdetail.setValue(currentChatMessage.value(forKey: "filecaption"), forKey: "filecaption")
                chatdetail.setValue(currentChatMessage.value(forKey: "msgid"), forKey: "msgid")
                chatdetail.setValue(currentChatMessage.value(forKey: "starmsg"), forKey: "starmsg")
                chatdetail.setValue(cmtdetails, forKey: "commentdetails")
                
                do {
                    
                    try managedContext.save()
                    
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "CafeChat_Update"), object: nil)
                    
                } catch let error as NSError  {
                    print("Could not save \(error), \(error.userInfo)")
                }
            }
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    func saveOneToOneChatCmtDetails(cmtdetails : NSDictionary, msgId : String, sendertype : String)
    {
        print("cmtdetails=>\(cmtdetails)")
        
        do {
            
            let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "OneToOne")
            fetchRequest.returnsObjectsAsFaults = false
            
            let predicate = NSPredicate(format: "msgid = %@", msgId)
            fetchRequest.predicate = predicate
            
            let results = try managedContext.fetch(fetchRequest) as! [NSManagedObject]
            
            if results.count > 0
            {
                let currentChatMessage = results[0]
                
                let entity =  NSEntityDescription.entity(forEntityName: "OneToOne",
                                                         in:managedContext)
                let chatdetail = NSManagedObject(entity: entity!,
                                                 insertInto: managedContext)
                chatdetail.setValue(currentChatMessage.value(forKey: "loginuserid"), forKey: "loginuserid")
                chatdetail.setValue(currentChatMessage.value(forKey: "userid"), forKey: "userid")
                chatdetail.setValue(currentChatMessage.value(forKey: "username"), forKey: "username")
                chatdetail.setValue(currentChatMessage.value(forKey: "message"), forKey: "message")
                chatdetail.setValue(currentChatMessage.value(forKey: "date"), forKey: "date")
                chatdetail.setValue(currentChatMessage.value(forKey: "teamid"), forKey: "teamid")
                chatdetail.setValue(currentChatMessage.value(forKey: "imagepath"), forKey: "imagepath")
                chatdetail.setValue(currentChatMessage.value(forKey: "imagetitle"), forKey: "imagetitle")
                chatdetail.setValue(currentChatMessage.value(forKey: "filesize"), forKey: "filesize")
                chatdetail.setValue(currentChatMessage.value(forKey: "filecaption"), forKey: "filecaption")
                chatdetail.setValue(currentChatMessage.value(forKey: "msgid"), forKey: "msgid")
                chatdetail.setValue("comment", forKey: "type")
                chatdetail.setValue(sendertype, forKey: "sendertype")
                chatdetail.setValue(cmtdetails, forKey: "commentdetails")
                chatdetail.setValue(currentChatMessage.value(forKey: "senderuserid"), forKey: "senderuserid")
                chatdetail.setValue(currentChatMessage.value(forKey: "starmsg"), forKey: "starmsg")

                do {
                    
                    try managedContext.save()
                    
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DirectChat_Update"), object: nil)
                    
                } catch let error as NSError  {
                    print("Could not save \(error), \(error.userInfo)")
                }
            }
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    func saveChatDetails(chatdetails : NSDictionary)
    {
//        print("chatdetails=>\(chatdetails)")
        
        let msgid = String(format: "%@", chatdetails.value(forKey: "msgid") as! CVarArg)
        if(commonmethodClass.groupChatMsgExist(msgId: msgid))
        {
            return
        }
        
        let entity =  NSEntityDescription.entity(forEntityName: "GroupChat",
                                                 in:managedContext)
        let chatdetail = NSManagedObject(entity: entity!,
                                         insertInto: managedContext)
        
        chatdetail.setValue(commonmethodClass.retrieveuserid(), forKey: "loginuserid")
        chatdetail.setValue(chatdetails.value(forKey: "userid"), forKey: "userid")
        chatdetail.setValue(chatdetails.value(forKey: "username"), forKey: "username")
        chatdetail.setValue(chatdetails.value(forKey: "message"), forKey: "message")
        chatdetail.setValue(chatdetails.value(forKey: "date"), forKey: "date")
        chatdetail.setValue(chatdetails.value(forKey: "groupid"), forKey: "groupid")
        chatdetail.setValue(chatdetails.value(forKey: "teamid"), forKey: "teamid")
        chatdetail.setValue(chatdetails.value(forKey: "imagepath"), forKey: "imagepath")
        chatdetail.setValue(chatdetails.value(forKey: "imagetitle"), forKey: "imagetitle")
        chatdetail.setValue(chatdetails.value(forKey: "filesize"), forKey: "filesize")
        chatdetail.setValue(chatdetails.value(forKey: "filecaption"), forKey: "filecaption")
        chatdetail.setValue(chatdetails.value(forKey: "msgid"), forKey: "msgid")
        if let cmtDetails = chatdetails.value(forKey: "commentdetails") as? NSDictionary
        {
            chatdetail.setValue(cmtDetails, forKey: "commentdetails")
        }
        else
        {
            chatdetail.setValue("", forKey: "commentdetails")
        }
        if let shareDetails = chatdetails.value(forKey: "sharedetails") as? NSDictionary
        {
            chatdetail.setValue(shareDetails, forKey: "sharedetails")
        }
        else
        {
            chatdetail.setValue("", forKey: "sharedetails")
        }
        if let linkDetails = chatdetails.value(forKey: "linkdetails") as? NSDictionary
        {
            chatdetail.setValue(linkDetails, forKey: "linkdetails")
        }
        else
        {
            chatdetail.setValue("", forKey: "linkdetails")
        }
        chatdetail.setValue(chatdetails.value(forKey: "type"), forKey: "type")
        chatdetail.setValue(chatdetails.value(forKey: "starmsg"), forKey: "starmsg")
        
        do {
            
            try managedContext.save()
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "GroupChat_Update"), object: nil)
            
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    func saveCafeChatDetails(chatdetails : NSDictionary)
    {
        print("chatdetails=>\(chatdetails)")
        
        let entity =  NSEntityDescription.entity(forEntityName: "CafeChat",
                                                 in:managedContext)
        let chatdetail = NSManagedObject(entity: entity!,
                                         insertInto: managedContext)
        chatdetail.setValue(commonmethodClass.retrieveuserid(), forKey: "loginuserid")
        chatdetail.setValue(chatdetails.value(forKey: "userid"), forKey: "userid")
        chatdetail.setValue(chatdetails.value(forKey: "username"), forKey: "username")
        chatdetail.setValue(chatdetails.value(forKey: "message"), forKey: "message")
        chatdetail.setValue(chatdetails.value(forKey: "date"), forKey: "date")
        chatdetail.setValue(chatdetails.value(forKey: "teamid"), forKey: "teamid")
        chatdetail.setValue(chatdetails.value(forKey: "imagepath"), forKey: "imagepath")
        chatdetail.setValue(chatdetails.value(forKey: "imagetitle"), forKey: "imagetitle")
        chatdetail.setValue(chatdetails.value(forKey: "filesize"), forKey: "filesize")
        chatdetail.setValue(chatdetails.value(forKey: "filecaption"), forKey: "filecaption")
        chatdetail.setValue(chatdetails.value(forKey: "msgid"), forKey: "msgid")
        if let cmtDetails = chatdetails.value(forKey: "commentdetails") as? NSDictionary
        {
            chatdetail.setValue(cmtDetails, forKey: "commentdetails")
        }
        else
        {
            chatdetail.setValue("", forKey: "commentdetails")
        }
        if let shareDetails = chatdetails.value(forKey: "sharedetails") as? NSDictionary
        {
            chatdetail.setValue(shareDetails, forKey: "sharedetails")
        }
        else
        {
            chatdetail.setValue("", forKey: "sharedetails")
        }
        chatdetail.setValue(chatdetails.value(forKey: "type"), forKey: "type")
        chatdetail.setValue(chatdetails.value(forKey: "starmsg"), forKey: "starmsg")

        do {
            
            try managedContext.save()
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "CafeChat_Update"), object: nil)
            
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    func saveOneToOneChatDetails(chatdetails : NSDictionary)
    {
        print("chatdetails=>\(chatdetails)")
        
        let entity =  NSEntityDescription.entity(forEntityName: "OneToOne",
                                                 in:managedContext)
        let chatdetail = NSManagedObject(entity: entity!,
                                         insertInto: managedContext)
        chatdetail.setValue(commonmethodClass.retrieveuserid(), forKey: "loginuserid")
        chatdetail.setValue(chatdetails.value(forKey: "userid"), forKey: "userid")
        chatdetail.setValue(chatdetails.value(forKey: "username"), forKey: "username")
        chatdetail.setValue(chatdetails.value(forKey: "message"), forKey: "message")
        chatdetail.setValue(chatdetails.value(forKey: "date"), forKey: "date")
        chatdetail.setValue(chatdetails.value(forKey: "teamid"), forKey: "teamid")
        chatdetail.setValue(chatdetails.value(forKey: "imagepath"), forKey: "imagepath")
        chatdetail.setValue(chatdetails.value(forKey: "imagetitle"), forKey: "imagetitle")
        chatdetail.setValue(chatdetails.value(forKey: "filesize"), forKey: "filesize")
        chatdetail.setValue(chatdetails.value(forKey: "filecaption"), forKey: "filecaption")
        chatdetail.setValue(chatdetails.value(forKey: "msgid"), forKey: "msgid")
        if let cmtDetails = chatdetails.value(forKey: "commentdetails") as? NSDictionary
        {
            chatdetail.setValue(cmtDetails, forKey: "commentdetails")
        }
        else
        {
            chatdetail.setValue("", forKey: "commentdetails")
        }
        if let shareDetails = chatdetails.value(forKey: "sharedetails") as? NSDictionary
        {
            chatdetail.setValue(shareDetails, forKey: "sharedetails")
        }
        else
        {
            chatdetail.setValue("", forKey: "sharedetails")
        }
        chatdetail.setValue(chatdetails.value(forKey: "type"), forKey: "type")
        chatdetail.setValue(chatdetails.value(forKey: "sendertype"), forKey: "sendertype")
        chatdetail.setValue(chatdetails.value(forKey: "senderuserid"), forKey: "senderuserid")
        chatdetail.setValue(chatdetails.value(forKey: "starmsg"), forKey: "starmsg")

        do {
            
            try managedContext.save()
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DirectChat_Update"), object: nil)
            
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    func createfilefolder(imageData : NSData, imagepath : String)
    {
        print("imagepath => \(imagepath)")
        
        do {
            try FileManager.default.createDirectory(at: self.getFolderPath(), withIntermediateDirectories: true, attributes: nil)
            
            let path = self.getFolderPath().appendingPathComponent(imagepath)
            
            //writing
            do {
                try imageData.write(to: path)
            }
            catch {
                print("File Error => \(error)")
            }
            
        } catch let error as NSError {
            NSLog("Unable to create directory \(error.debugDescription)")
        }
    }
    
    func getFolderPath() -> URL
    {
        let documentsPath = NSURL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])
        let dirPath = documentsPath.appendingPathComponent("ChatFolder")
        return dirPath!
    }
    
    func application(_ application: UIApplication, handleOpen url: URL) -> Bool
    {
        print("Open URL "+url.path)
        let data: NSData? = NSData(contentsOfFile: url.path)
        print("data*** =>\(String(describing: data?.length))")
        print("lastPathComponent "+url.lastPathComponent)
        print("pathExtension "+url.pathExtension)

        for aviewcontroller : UIViewController in navigation().viewControllers
        {
            if let groupView = aviewcontroller as? GroupViewController
            {
                appDelegate.mediadata = data
                groupView.sendfile(imagedata: data! as Data, filename: url.lastPathComponent)
                break
            }
        }
        
        for aviewcontroller : UIViewController in navigation().viewControllers
        {
            if let onetooneView = aviewcontroller as? OneToOneChatViewController
            {
                appDelegate.mediadata = data
                onetooneView.sendfile(imagedata: data! as Data, filename: url.lastPathComponent)
                break
            }
        }
        
        for aviewcontroller : UIViewController in navigation().viewControllers
        {
            if let cafeView = aviewcontroller as? CafeViewController
            {
                appDelegate.mediadata = data
                cafeView.sendfile(imagedata: data! as Data, filename: url.lastPathComponent)
                break
            }
        }

        return true
    }
    
    // MARK: - Core Data stack
    
    lazy var applicationDocumentsDirectory: NSURL = {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1] as NSURL
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = Bundle.main.url(forResource: "ChatDetails", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent("workaa.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject?
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject?
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
}

