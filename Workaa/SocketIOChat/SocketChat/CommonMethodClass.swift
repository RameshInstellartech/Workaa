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
    
    func groupChatCmtDetailsExist(msgId : String) -> Bool
    {
        do {
            let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "GroupChat")
            fetchRequest.returnsObjectsAsFaults = false
            
            let predicate = NSPredicate(format: "msgid = %@", msgId)
            fetchRequest.predicate = predicate
            
            let results = try managedContext.fetch(fetchRequest) as! [NSManagedObject]
            
            if results.count > 0
            {
                let currentChatMessage = results[0]
                if let cmtDetails = currentChatMessage.value(forKey: "commentdetails") as? NSDictionary
                {
                    print("cmtDetails CMT =>\(cmtDetails)")
                    return true
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
        let teamDecodedObject = UserDefaults.standard.value(forKey: "team_details") as! Data
        let teamdetails = NSKeyedUnarchiver.unarchiveObject(with: teamDecodedObject) as! NSDictionary
        let teamid = teamdetails.value(forKey: "uniqueId") as! NSString
        return teamid
    }
    
    func retrieveteamadmin() -> String
    {
        let userDecodedObject = UserDefaults.standard.value(forKey: "user_details") as! Data
        let userdetails = NSKeyedUnarchiver.unarchiveObject(with: userDecodedObject) as! NSDictionary
        let userdata = userdetails.value(forKey: "userData") as! NSDictionary
        let adminstring = String(format: "%@", userdata.value(forKey: "admin") as! CVarArg)
        return adminstring as String
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
    
    func saveprofileimg(profileImg : NSString)
    {
        let encodedObject = NSKeyedArchiver.archivedData(withRootObject: profileImg)
        UserDefaults.standard.setValue(encodedObject, forKey: "Profile_Pic")
        UserDefaults.standard.synchronize()
    }
    
    func retrieveprofileimg() -> NSString
    {
        if AlreadyExist(Key: "Profile_Pic")
        {
            let decodedObject = UserDefaults.standard.value(forKey: "Profile_Pic") as! Data
            let profileImg = NSKeyedUnarchiver.unarchiveObject(with: decodedObject) as! NSString
            return profileImg
        }
        else
        {
            return ""
        }
    }
    
    func retrieveUsernameToken() -> NSString
    {
        let userDecodedObject = UserDefaults.standard.value(forKey: "user_details") as! Data
        let userdetails = NSKeyedUnarchiver.unarchiveObject(with: userDecodedObject) as! NSDictionary
        let token = userdetails.value(forKey: "token") as! NSString
        return token
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
            dateFormatter.dateFormat = "dd/MM/yyyy"
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
