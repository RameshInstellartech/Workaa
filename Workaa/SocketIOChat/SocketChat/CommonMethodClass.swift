//
//  CommonMethodClass.swift
//  Workaa
//
//  Created by IN1947 on 08/11/16.
//  Copyright © 2016 IN1947. All rights reserved.
//

import UIKit
import CoreData

class CommonMethodClass: NSObject
{
    func saveuserdetails(reponse : NSDictionary)
    {
        let userEncodedObject = NSKeyedArchiver.archivedData(withRootObject: reponse)
        UserDefaults.standard.setValue(userEncodedObject, forKey: "user_details")
        UserDefaults.standard.synchronize()
        
        let userDecodedObject = UserDefaults.standard.value(forKey: "user_details") as! Data
        let userdetails = NSKeyedUnarchiver.unarchiveObject(with: userDecodedObject) as! NSDictionary
        let userdata = userdetails.value(forKey: "userData") as! NSDictionary
        let adminstring = String(format: "%@", userdata.value(forKey: "admin") as! CVarArg)
        self.saveteamadmin(admin: adminstring)
    }
    
    func saveteamdetails(reponse : NSDictionary)
    {
        let teamEncodedObject = NSKeyedArchiver.archivedData(withRootObject: reponse)
        UserDefaults.standard.setValue(teamEncodedObject, forKey: "team_details")
        UserDefaults.standard.synchronize()
    }
    
    func removeallkey()
    {
        UserDefaults.standard.removeObject(forKey: "user_details")
        UserDefaults.standard.removeObject(forKey: "team_details")
        UserDefaults.standard.synchronize()
    }
    
    func AlreadyExist(Key: String) -> Bool {
        return UserDefaults.standard.value(forKey: Key) != nil
    }
    
    func createAttributedString(fullString: String, fullStringColor: UIColor, subString: String, subStringColor: UIColor, fullfont: UIFont, subfont: UIFont) -> NSMutableAttributedString
    {
        let range = (fullString as NSString).range(of: subString)
        let attributedString = NSMutableAttributedString(string:fullString)
        attributedString.addAttribute(NSForegroundColorAttributeName, value: fullStringColor, range: NSRange(location: 0, length: fullString.characters.count))
        attributedString.addAttribute(NSFontAttributeName, value: fullfont, range: NSRange(location: 0, length: fullString.characters.count))
        attributedString.addAttribute(NSForegroundColorAttributeName, value: subStringColor, range: range)
        attributedString.addAttribute(NSFontAttributeName, value: subfont, range: range)
        return attributedString
    }
    
    func ovalAnimation(_ view: UIView, center: CGPoint, colorFrom: UIColor, colorTo: UIColor, withradius radius: CGFloat)
    {
        let ripple = UIView(frame: CGRect(x: CGFloat(0.0), y: CGFloat(0.0), width: radius, height: radius))
        ripple.layer.cornerRadius = radius * 0.5
        ripple.backgroundColor = colorFrom
        ripple.alpha = 1.0
        view.insertSubview(ripple, at: 0)
        ripple.center = center
        let scale: CGFloat = 8.0
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseOut, animations: {() -> Void in
            ripple.transform = CGAffineTransform(scaleX: scale, y: scale)
            ripple.backgroundColor = colorTo
        }, completion: {(_ finished: Bool) -> Void in
        })
    }
    
    func directChatMsgExist(msgId : String) -> Bool
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
                return true
            }
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        return false
    }
    
    func groupChatMsgExist(msgId : String) -> Bool
    {
        do {
            let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "GroupChat")
            fetchRequest.returnsObjectsAsFaults = false
            
            let predicate = NSPredicate(format: "msgid = %@", msgId)
            fetchRequest.predicate = predicate
            
            let results =
                try managedContext.fetch(fetchRequest)
            let messages = results as! [NSManagedObject]
            if messages.count>0
            {
                return true
            }
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        return false
    }
    
    func groupChatCmtMsgExist(cmtId : String) -> Bool
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
                return true
            }
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        return false
    }
    
    func groupChatCmtDetailsExist(msgId : String, cmtId : String) -> Bool
    {
        do {
            let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "GroupChat")
            fetchRequest.returnsObjectsAsFaults = false
            
            let predicate = NSPredicate(format: "msgid = %@", msgId)
            fetchRequest.predicate = predicate
            
            let results = try managedContext.fetch(fetchRequest) as! [NSManagedObject]
            if results.count > 0
            {
                for i in 0 ..< results.count
                {
                    let getmanageObj = results[i]
                    if let cmtDetails = getmanageObj.value(forKey: "commentdetails") as? NSDictionary
                    {
                        let cmtid = cmtDetails.value(forKey: "cmtid") as? String
                        if cmtid==cmtId
                        {
                            return true
                        }
                    }
                }
            }
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        return false
    }
    
    func cafeChatMsgExist(msgId : String) -> Bool
    {
        do {
            let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "CafeChat")
            fetchRequest.returnsObjectsAsFaults = false
            
            let predicate = NSPredicate(format: "msgid = %@", msgId)
            fetchRequest.predicate = predicate
            
            let results =
                try managedContext.fetch(fetchRequest)
            let messages = results as! [NSManagedObject]
            if messages.count>0
            {
                return true
            }
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        return false
    }
    
    func cafeChatCmtMsgExist(cmtId : String) -> Bool
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
                return true
            }
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        return false
    }
    
    func cafeChatCmtDetailsExist(msgId : String, cmtId : String) -> Bool
    {
        do {
            let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "CafeChat")
            fetchRequest.returnsObjectsAsFaults = false
            
            let predicate = NSPredicate(format: "msgid = %@", msgId)
            fetchRequest.predicate = predicate
            
            let results = try managedContext.fetch(fetchRequest) as! [NSManagedObject]
            if results.count > 0
            {
                for i in 0 ..< results.count
                {
                    let getmanageObj = results[i]
                    if let cmtDetails = getmanageObj.value(forKey: "commentdetails") as? NSDictionary
                    {
                        let cmtid = cmtDetails.value(forKey: "cmtid") as? String
                        if cmtid==cmtId
                        {
                            return true
                        }
                    }
                }
            }
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        return false
    }
    
    func getGroupChatVisibleViewcontroller() -> Bool
    {
        if let visibleController = navigation().visibleViewController
        {
            if visibleController is GroupViewController
            {
                return true
            }
        }
        
        return false
    }
    
    func getDirectChatVisibleViewcontroller() -> Bool
    {
        if let visibleController = navigation().visibleViewController
        {
            if visibleController is OneToOneChatViewController
            {
                return true
            }
        }
        
        return false
    }
    
    func getCafeChatVisibleViewcontroller() -> Bool
    {
        if let visibleController = navigation().visibleViewController
        {
            if visibleController is CafeViewController
            {
                return true
            }
        }
        
        return false
    }
    
    func retrieveteamid() -> NSString
    {
        if AlreadyExist(Key: "team_details")
        {
            let teamDecodedObject = UserDefaults.standard.value(forKey: "team_details") as! Data
            let teamdetails = NSKeyedUnarchiver.unarchiveObject(with: teamDecodedObject) as! NSDictionary
            if let teamid = teamdetails.value(forKey: "uniqueId") as? NSString
            {
                return teamid
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
    
    func retrieveteamadmin() -> String
    {
//        let userDecodedObject = UserDefaults.standard.value(forKey: "user_details") as! Data
//        let userdetails = NSKeyedUnarchiver.unarchiveObject(with: userDecodedObject) as! NSDictionary
//        let userdata = userdetails.value(forKey: "userData") as! NSDictionary
//        let adminstring = String(format: "%@", userdata.value(forKey: "admin") as! CVarArg)
//        return adminstring as String
        
        let adminObject = UserDefaults.standard.value(forKey: "team_admin") as! Data
        let adminstring = NSKeyedUnarchiver.unarchiveObject(with: adminObject) as! String
        return adminstring as String
    }
    
    func saveteamadmin(admin : String)
    {
        let adminObject = NSKeyedArchiver.archivedData(withRootObject: admin)
        UserDefaults.standard.setValue(adminObject, forKey: "team_admin")
        UserDefaults.standard.synchronize()
    }
    
    func retrieveteamdomain() -> NSString
    {
        if let teamDecodedObject = UserDefaults.standard.value(forKey: "team_details") as? Data
        {
            if let teamdetails = NSKeyedUnarchiver.unarchiveObject(with: teamDecodedObject) as? NSDictionary
            {
                if let domain = teamdetails.value(forKey: "domain") as? NSString
                {
                    return domain
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
        else
        {
            return ""
        }
    }
    
    func retrieveteamUrl() -> NSString
    {
        if let teamDecodedObject = UserDefaults.standard.value(forKey: "team_details") as? Data
        {
            if let teamdetails = NSKeyedUnarchiver.unarchiveObject(with: teamDecodedObject) as? NSDictionary
            {
                if let urlstring = teamdetails.value(forKey: "url") as? NSString
                {
                    return urlstring
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
        else
        {
            return ""
        }
    }
    
    func retrieveuserdetails() -> NSDictionary
    {
        let userDecodedObject = UserDefaults.standard.value(forKey: "user_details") as! Data
        let userdetails = NSKeyedUnarchiver.unarchiveObject(with: userDecodedObject) as! NSDictionary
        return userdetails
    }
    
    func retrieveuserid() -> NSString
    {
        if AlreadyExist(Key: "user_details")
        {
            let userDecodedObject = UserDefaults.standard.value(forKey: "user_details") as! Data
            let userdetails = NSKeyedUnarchiver.unarchiveObject(with: userDecodedObject) as! NSDictionary
            let userid = userdetails.value(forKey: "userId") as! NSString
            return userid
        }
        else
        {
            return ""
        }
    }
    
    func retrieveusername() -> NSString
    {
        if AlreadyExist(Key: "user_details")
        {
            let userDecodedObject = UserDefaults.standard.value(forKey: "user_details") as! Data
            let userdetails = NSKeyedUnarchiver.unarchiveObject(with: userDecodedObject) as! NSDictionary
            let userdata = userdetails.value(forKey: "userData") as! NSDictionary
            let username = String(format: "%@", userdata.value(forKey: "username") as! CVarArg)
//            let username = String(format: "%@ %@", userdata.value(forKey: "firstName") as! CVarArg,userdata.value(forKey: "lastName") as! CVarArg)
            return username as NSString
        }
        else
        {
            return ""
        }
    }
    
    func retrievename() -> NSString
    {
        if AlreadyExist(Key: "user_details")
        {
            let userDecodedObject = UserDefaults.standard.value(forKey: "user_details") as! Data
            let userdetails = NSKeyedUnarchiver.unarchiveObject(with: userDecodedObject) as! NSDictionary
            let userdata = userdetails.value(forKey: "userData") as! NSDictionary
            //        let username = userdata.value(forKey: "username") as! NSString
            let name = String(format: "%@ %@", userdata.value(forKey: "firstName") as! CVarArg,userdata.value(forKey: "lastName") as! CVarArg)
            return name as NSString
        }
        else
        {
            return ""
        }
    }
    
    func retrieveemail() -> NSString
    {
        let userDecodedObject = UserDefaults.standard.value(forKey: "user_details") as! Data
        let userdetails = NSKeyedUnarchiver.unarchiveObject(with: userDecodedObject) as! NSDictionary
        let userdata = userdetails.value(forKey: "userData") as! NSDictionary
        let email = userdata.value(forKey: "email") as! NSString
        return email
    }
    
//    func saveprofileimg(profileImg : NSString)
//    {
//        let encodedObject = NSKeyedArchiver.archivedData(withRootObject: profileImg)
//        UserDefaults.standard.setValue(encodedObject, forKey: "Profile_Pic")
//        UserDefaults.standard.synchronize()
//    }
//    
//    func retrieveprofileimg() -> NSString
//    {
//        if AlreadyExist(Key: "Profile_Pic")
//        {
//            let decodedObject = UserDefaults.standard.value(forKey: "Profile_Pic") as! Data
//            let profileImg = NSKeyedUnarchiver.unarchiveObject(with: decodedObject) as! NSString
//            return profileImg
//        }
//        else
//        {
//            return ""
//        }
//    }
    
    func retrieveUsernameToken() -> NSString
    {
        if AlreadyExist(Key: "user_details")
        {
            let userDecodedObject = UserDefaults.standard.value(forKey: "user_details") as! Data
            let userdetails = NSKeyedUnarchiver.unarchiveObject(with: userDecodedObject) as! NSDictionary
            if let token = userdetails.value(forKey: "token") as? NSString
            {
                return token
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
        
    func retrievesessionid() -> NSString
    {
        let userDecodedObject = UserDefaults.standard.value(forKey: "user_details") as! Data
        let userdetails = NSKeyedUnarchiver.unarchiveObject(with: userDecodedObject) as! NSDictionary
        let sessionid = userdetails.value(forKey: "SESSID") as! NSString
        return sessionid
    }
    
    func delayWithSeconds(_ seconds: Double, completion: @escaping () -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            completion()
        }
    }
    
    func convertDateFormatter(date: String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = NSTimeZone(abbreviation: "GMT")! as TimeZone
        let date = dateFormatter.date(from: date)
        
        if let dateformat = date
        {
            let outputDatedateFormatter = DateFormatter()
            outputDatedateFormatter.timeStyle = .short
            let timeStamp = outputDatedateFormatter.string(from: dateformat)
            return timeStamp
        }
        else
        {
            return ""
        }
    }
    
    func convertDateFormatterOnly(date: String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: date)
        
        if let dateformat = date
        {
            dateFormatter.dateFormat = "dd-MMM-yyyy"
            let datestring = dateFormatter.string(from: dateformat)
            return datestring
        }
        else
        {
            return ""
        }
    }
    
    func convertDateInCell(date: String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: date)
        
        if let dateformat = date
        {
            dateFormatter.dateFormat = "dd-MMM-yyyy"
            let datestring = dateFormatter.string(from: dateformat)
            return datestring
        }
        else
        {
            return ""
        }
    }
    
    func convertDateSection(date: String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: date)
        
        if let dateformat = date
        {
            dateFormatter.dateFormat = "dd MMMM yyyy"
            let datestring = dateFormatter.string(from: dateformat)
            return datestring
        }
        else
        {
            return ""
        }
    }
    
    func dateConvertString(date: Date) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
    
    func convertDate(date: String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let date = dateFormatter.date(from: date)
        
        if let dateformat = date
        {
            dateFormatter.dateFormat = "dd-MMM-yyyy"
            let datestring = dateFormatter.string(from: dateformat)
            return datestring
        }
        else
        {
            return ""
        }
    }
    
    func isBlank (optionalString :String?) -> Bool {
        if let string = optionalString {
            return string.isEmpty
        } else {
            return true
        }
    }
    
    func dynamicHeight(width: CGFloat, font: UIFont, string: String) -> CGFloat
    {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = string.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        
        return boundingBox.height
    }
    
    func widthOfString(usingFont font: UIFont, text : NSString) -> CGFloat
    {
        let fontAttributes = [NSFontAttributeName: font]
        let size = text.size(attributes: fontAttributes)
        return size.width
    }
    
    func heightOfString(usingFont font: UIFont, text : NSString) -> CGFloat
    {
        let fontAttributes = [NSFontAttributeName: font]
        let size = text.size(attributes: fontAttributes)
        return size.height
    }
    
    func imageIsNullOrNot(imageName : UIImage)-> Bool
    {
        let size = CGSize(width: 0, height: 0)
        if (imageName.size.width == size.width)
        {
            return false
        }
        else
        {
            return true
        }
    }
}
