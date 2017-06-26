//
//  ConnectionClass.swift
//  Workaa
//
//  Created by IN1947 on 02/11/16.
//  Copyright © 2016 IN1947. All rights reserved.
//

import UIKit

@objc protocol ConnectionProtocol:class
{
    func GetReponseMethod(reponse : NSDictionary)
    func GetFailureReponseMethod(errorreponse : String)
}

class ConnectionClass: NSObject
{
    weak var delegate:ConnectionProtocol?
    var commonmethodClass = CommonMethodClass()
    
    func StartApp()
    {
        let urlpath = String(format: "%@%@", kUrlPath,kappLabel)
        print("urlpath =>\(urlpath)")
        
        let request : ASIFormDataRequest = ASIFormDataRequest(url: NSURL(string: urlpath)! as URL)
        request.requestMethod = "POST"
        request.addHeader("Accept", value: "application/json")
        request.startSynchronous()
        
        self.getRequest(request: request)
    }
    
    func getAppLabel()
    {
        let urlpath = String(format: "%@%@", commonmethodClass.retrieveteamUrl(),kappLabelDomain)
        print("urlpath =>\(urlpath)")
        print("token =>\(commonmethodClass.retrieveUsernameToken())")

        let request : ASIFormDataRequest = ASIFormDataRequest(url: NSURL(string: urlpath)! as URL)
        request.requestMethod = "POST"
        request.addPostValue(commonmethodClass.retrieveteamdomain(), forKey: "domain")
        request.addPostValue(commonmethodClass.retrieveUsernameToken(), forKey: "token")
        request.addHeader("Accept", value: "application/json")
        request.startSynchronous()
        
        self.getRequest(request: request)
    }
    
    func logOut()
    {
        let urlpath = String(format: "%@%@", kBaseURL,klogOut)
        print("urlpath =>\(urlpath)")
        
        let request : ASIFormDataRequest = ASIFormDataRequest(url: NSURL(string: urlpath)! as URL)
        request.requestMethod = "POST"
        request.addPostValue(commonmethodClass.retrieveUsernameToken(), forKey: "token")
        request.addHeader("Accept", value: "application/json")
        request.startSynchronous()
        
        self.getRequest(request: request)
    }
    
    func getGroupMsg(groupId:String, count:String)
    {
        let urlpath = String(format: "%@%@", kBaseURL,kgetgroupmsg)
        print("urlpath =>\(urlpath)")
        
        let request : ASIFormDataRequest = ASIFormDataRequest(url: NSURL(string: urlpath)! as URL)
        request.requestMethod = "POST"
        request.addPostValue(commonmethodClass.retrieveUsernameToken(), forKey: "token")
        request.addPostValue(groupId as NSObjectProtocol!, forKey: "groupid")
        request.addPostValue(count as NSObjectProtocol!, forKey: "count")
        request.addHeader("Accept", value: "application/json")
        request.startSynchronous()
        
        self.getRequest(request: request)
    }
    
    func getCafeMsg(count:String)
    {
        let urlpath = String(format: "%@%@", kBaseURL,kgetcafemsg)
        print("urlpath =>\(urlpath)")
        
        let request : ASIFormDataRequest = ASIFormDataRequest(url: NSURL(string: urlpath)! as URL)
        request.requestMethod = "POST"
        request.addPostValue(commonmethodClass.retrieveUsernameToken(), forKey: "token")
        request.addPostValue(count as NSObjectProtocol!, forKey: "count")
        request.addHeader("Accept", value: "application/json")
        request.startSynchronous()
        
        self.getRequest(request: request)
    }
    
    func getDirectMsg(uId:String, count:String)
    {
        let urlpath = String(format: "%@%@", kBaseURL,kgetdirectmsg)
        print("urlpath =>\(urlpath)")
        
        let request : ASIFormDataRequest = ASIFormDataRequest(url: NSURL(string: urlpath)! as URL)
        request.requestMethod = "POST"
        request.addPostValue(commonmethodClass.retrieveUsernameToken(), forKey: "token")
        request.addPostValue(uId as NSObjectProtocol!, forKey: "uid")
        request.addPostValue(count as NSObjectProtocol!, forKey: "count")
        request.addHeader("Accept", value: "application/json")
        request.startSynchronous()
        
        self.getRequest(request: request)
    }
    
    func teamVerify(domain:String)
    {
        let urlpath = String(format: "%@%@", kUrlPath,kteamverify)
        print("urlpath =>\(urlpath)")
        
        let request : ASIFormDataRequest = ASIFormDataRequest(url: NSURL(string: urlpath)! as URL)
        request.requestMethod = "POST"
        request.addPostValue(domain as NSObjectProtocol!, forKey: "domain")
        request.addHeader("Accept", value: "application/json")
        request.startSynchronous()
        
        self.getRequest(request: request)
    }
    
    func emailIdVerify(email:String)
    {
        let urlpath = String(format: "%@%@", kUrlPath,kemailIdVerify)
        print("urlpath =>\(urlpath)")
        
        let request : ASIFormDataRequest = ASIFormDataRequest(url: NSURL(string: urlpath)! as URL)
        request.requestMethod = "POST"
        request.addPostValue(email as NSObjectProtocol!, forKey: "email")
        request.addHeader("Accept", value: "application/json")
        request.startSynchronous()
        
        self.getRequest(request: request)
    }
    
    func verifyEmail(email:String, code:String)
    {
        let urlpath = String(format: "%@%@", kUrlPath,kverifyEmail)
        print("urlpath =>\(urlpath)")
        
        let request : ASIFormDataRequest = ASIFormDataRequest(url: NSURL(string: urlpath)! as URL)
        request.requestMethod = "POST"
        request.addPostValue(code as NSObjectProtocol!, forKey: "code")
        request.addPostValue(email as NSObjectProtocol!, forKey: "email")
        request.addHeader("Accept", value: "application/json")
        request.startSynchronous()
        
        self.getRequest(request: request)
    }
    
    func register(email:String, password:String)
    {
        let urlpath = String(format: "%@%@", kUrlPath,kregister)
        print("urlpath =>\(urlpath)")
        
        let request : ASIFormDataRequest = ASIFormDataRequest(url: NSURL(string: urlpath)! as URL)
        request.requestMethod = "POST"
        request.addPostValue(password as NSObjectProtocol!, forKey: "password")
        request.addPostValue(email as NSObjectProtocol!, forKey: "email")
        request.addPostValue(uniqueId as NSObjectProtocol!, forKey: "deviceid")
        request.addHeader("Accept", value: "application/json")
        request.startSynchronous()
        
        self.getRequest(request: request)
    }

    func CreateTeam(fname:String, lname:String, username:String, name:String, domain:String, industry:String, employees:String, email:String)
    {
        let urlpath = String(format: "%@%@", kUrlPath,kcreateTeam)
        print("urlpath =>\(urlpath)")
        
        let request : ASIFormDataRequest = ASIFormDataRequest(url: NSURL(string: urlpath)! as URL)
        request.requestMethod = "POST"
        request.addPostValue(fname as NSObjectProtocol!, forKey: "fname")
        request.addPostValue(lname as NSObjectProtocol!, forKey: "lname")
        request.addPostValue(username as NSObjectProtocol!, forKey: "username")
        request.addPostValue(name as NSObjectProtocol!, forKey: "name")
        request.addPostValue(domain as NSObjectProtocol!, forKey: "domain")
        request.addPostValue(industry as NSObjectProtocol!, forKey: "industry")
        request.addPostValue(employees as NSObjectProtocol!, forKey: "employees")
        request.addPostValue(email as NSObjectProtocol!, forKey: "email")
        request.addHeader("Accept", value: "application/json")
        request.startSynchronous()
        
        self.getRequest(request: request)
    }
    
    func SignIn(email:String, password:String)
    {
        let urlpath = String(format: "%@%@", kBaseURL,klogin)
        print("urlpath =>\(urlpath)")

        let request : ASIFormDataRequest = ASIFormDataRequest(url: NSURL(string: urlpath)! as URL)
        request.requestMethod = "POST"
        request.addPostValue(email as NSObjectProtocol!, forKey: "email")
        request.addPostValue(password as NSObjectProtocol!, forKey: "password")
        request.addPostValue(kDeviceToken as NSObjectProtocol!, forKey: "devicetoken")
        request.addPostValue(uniqueId as NSObjectProtocol!, forKey: "deviceid")
        request.addHeader("Accept", value: "application/json")
        request.startSynchronous()
        
        self.getRequest(request: request)
    }
    
    func ForgotEmail(email:String)
    {
        let urlpath = String(format: "%@%@", kBaseURL,kforgotPasswordRequest)
        print("urlpath =>\(urlpath)")
        
        let request : ASIFormDataRequest = ASIFormDataRequest(url: NSURL(string: urlpath)! as URL)
        request.requestMethod = "POST"
        request.addPostValue(email as NSObjectProtocol!, forKey: "email")
        request.addHeader("Accept", value: "application/json")
        request.startSynchronous()
        
        self.getRequest(request: request)
    }
    
    func SignUp(fname:String, lname:String, email:String, password:String, username:String)
    {
        let urlpath = String(format: "%@%@", kBaseURL,kregister)
        print("urlpath =>\(urlpath)")
        
        let request : ASIFormDataRequest = ASIFormDataRequest(url: NSURL(string: urlpath)! as URL)
        request.requestMethod = "POST"
        request.addPostValue(fname as NSObjectProtocol!, forKey: "fname")
        request.addPostValue(lname as NSObjectProtocol!, forKey: "lname")
        request.addPostValue(email as NSObjectProtocol!, forKey: "email")
        request.addPostValue(username as NSObjectProtocol!, forKey: "username")
        request.addPostValue(password as NSObjectProtocol!, forKey: "password")
        request.addPostValue(uniqueId as NSObjectProtocol!, forKey: "deviceid")
        request.addHeader("Accept", value: "application/json")
        request.startSynchronous()
        
        self.getRequest(request: request)
    }
    
    func getTeamList()
    {
        let urlpath = String(format: "%@%@", kBaseURL,kteamlist)
        print("urlpath =>\(urlpath)")
        print("token =>\(commonmethodClass.retrieveUsernameToken())")

        let request : ASIFormDataRequest = ASIFormDataRequest(url: NSURL(string: urlpath)! as URL)
        request.requestMethod = "POST"
        request.addPostValue(commonmethodClass.retrieveUsernameToken(), forKey: "token")
        request.addHeader("Accept", value: "application/json")
        request.startSynchronous()
        
        self.getRequest(request: request)
    }
    
    func SelectTeam()
    {
        let urlpath = String(format: "%@%@", kBaseURL,kselectTeam)
        print("urlpath =>\(urlpath)")
        
        let request : ASIFormDataRequest = ASIFormDataRequest(url: NSURL(string: urlpath)! as URL)
        request.requestMethod = "POST"
        request.addPostValue(commonmethodClass.retrieveUsernameToken(), forKey: "token")
        request.addPostValue(commonmethodClass.retrieveteamid(), forKey: "team")
        request.addHeader("Accept", value: "application/json")
        request.startSynchronous()
        
        self.getRequest(request: request)
    }
    
    func getUserInfo()
    {
        let urlpath = String(format: "%@%@", kBaseURL,kuserInfo)
        print("urlpath =>\(urlpath)")
        
        let request : ASIFormDataRequest = ASIFormDataRequest(url: NSURL(string: urlpath)! as URL)
        request.requestMethod = "POST"
        request.addPostValue(commonmethodClass.retrieveUsernameToken(), forKey: "token")
        request.addHeader("Accept", value: "application/json")
        request.startSynchronous()
        
        self.getRequest(request: request)
    }
    
    func getUploadProfilePic(imageData:Data)
    {
        let urlpath = String(format: "%@%@", kBaseURL,kuserpicupload)
        print("urlpath =>\(urlpath)")
        
        let request : ASIFormDataRequest = ASIFormDataRequest(url: NSURL(string: urlpath)! as URL)
        request.requestMethod = "POST"
        request.addPostValue(commonmethodClass.retrieveUsernameToken(), forKey: "token")
        request.addData(imageData, withFileName: "profile.jpg", andContentType: "multipart/form-data", forKey: "profilepic")
        request.addHeader("Accept", value: "application/json")
        request.startSynchronous()
        
        self.getRequest(request: request)
    }
    
    func UpdateGeneralInfo(firstname:String, lastname:String, gender:String, dob:String, location:String, myself:String)
    {
        let urlpath = String(format: "%@%@", kBaseURL,kgeneraluserinfo)
        print("urlpath =>\(urlpath)")
        
        let request : ASIFormDataRequest = ASIFormDataRequest(url: NSURL(string: urlpath)! as URL)
        request.requestMethod = "POST"
        request.addPostValue(commonmethodClass.retrieveUsernameToken(), forKey: "token")
        request.addPostValue(firstname as NSObjectProtocol!, forKey: "firstname")
        request.addPostValue(lastname as NSObjectProtocol!, forKey: "lastname")
        request.addPostValue(gender as NSObjectProtocol!, forKey: "gender")
        request.addPostValue(dob as NSObjectProtocol!, forKey: "dob")
        request.addPostValue(location as NSObjectProtocol!, forKey: "location")
        request.addPostValue(myself as NSObjectProtocol!, forKey: "myself")
        request.addHeader("Accept", value: "application/json")
        request.startSynchronous()
        
        self.getRequest(request: request)
    }
    
    func UpdateContactInfo(phone:String, address:String)
    {
        let urlpath = String(format: "%@%@", kBaseURL,kcontactuserinfo)
        print("urlpath =>\(urlpath)")
        
        let request : ASIFormDataRequest = ASIFormDataRequest(url: NSURL(string: urlpath)! as URL)
        request.requestMethod = "POST"
        request.addPostValue(commonmethodClass.retrieveUsernameToken(), forKey: "token")
        request.addPostValue(phone as NSObjectProtocol!, forKey: "phone")
        request.addPostValue(address as NSObjectProtocol!, forKey: "address")
        request.addHeader("Accept", value: "application/json")
        request.startSynchronous()
        
        self.getRequest(request: request)
    }
    
    func UpdateWorkInfo(occupation:String, skills:String)
    {
        let urlpath = String(format: "%@%@", kBaseURL,kworkuserinfo)
        print("urlpath =>\(urlpath)")
        
        let request : ASIFormDataRequest = ASIFormDataRequest(url: NSURL(string: urlpath)! as URL)
        request.requestMethod = "POST"
        request.addPostValue(commonmethodClass.retrieveUsernameToken(), forKey: "token")
        request.addPostValue(occupation as NSObjectProtocol!, forKey: "occupation")
        request.addPostValue(skills as NSObjectProtocol!, forKey: "skills")
        request.addHeader("Accept", value: "application/json")
        request.startSynchronous()
        
        self.getRequest(request: request)
    }
    
    func getGroupList()
    {
        let urlpath = String(format: "%@%@", kBaseURL,kgrouplist)
        print("urlpath =>\(urlpath)")
        
        let request : ASIFormDataRequest = ASIFormDataRequest(url: NSURL(string: urlpath)! as URL)
        request.requestMethod = "POST"
        request.addPostValue(commonmethodClass.retrieveUsernameToken(), forKey: "token")
        request.addHeader("Accept", value: "application/json")
        request.startSynchronous()
        
        self.getRequest(request: request)
    }
    
    func getUserList()
    {
        let urlpath = String(format: "%@%@", kBaseURL,kteamuserslist)
        print("urlpath =>\(urlpath)")
        
        let request : ASIFormDataRequest = ASIFormDataRequest(url: NSURL(string: urlpath)! as URL)
        request.requestMethod = "POST"
        request.addPostValue(commonmethodClass.retrieveUsernameToken(), forKey: "token")
        request.addHeader("Accept", value: "application/json")
        request.startSynchronous()
        
        self.getRequest(request: request)
    }
    
    func getMyBucketList()
    {
        let urlpath = String(format: "%@%@", kBaseURL,kmybucketlist)
        
        let request : ASIFormDataRequest = ASIFormDataRequest(url: NSURL(string: urlpath)! as URL)
        request.requestMethod = "POST"
        request.addPostValue(commonmethodClass.retrieveUsernameToken(), forKey: "token")
        request.addHeader("Accept", value: "application/json")
        request.startSynchronous()
        
        self.getRequest(request: request)
    }
    
    func getQueueList()
    {
        let urlpath = String(format: "%@%@", kBaseURL,kqueuelist)
        
        let request : ASIFormDataRequest = ASIFormDataRequest(url: NSURL(string: urlpath)! as URL)
        request.requestMethod = "POST"
        request.addPostValue(commonmethodClass.retrieveUsernameToken(), forKey: "token")
        request.addHeader("Accept", value: "application/json")
        request.startSynchronous()
        
        self.getRequest(request: request)
    }
    
    func queueToTask(taskid:String, taskname:String, taskdescription:String, users:String, priority:String)
    {
        let urlpath = String(format: "%@%@", kBaseURL,kqueuetotask)
        
        let request : ASIFormDataRequest = ASIFormDataRequest(url: NSURL(string: urlpath)! as URL)
        request.requestMethod = "POST"
        request.addPostValue(commonmethodClass.retrieveUsernameToken(), forKey: "token")
        request.addPostValue(taskid as NSObjectProtocol!, forKey: "id")
        request.addPostValue(taskname as NSObjectProtocol!, forKey: "task")
        request.addPostValue(taskdescription as NSObjectProtocol!, forKey: "info")
        request.addPostValue(users as NSObjectProtocol!, forKey: "users")
        request.addPostValue(priority as NSObjectProtocol!, forKey: "priority")
        request.addHeader("Accept", value: "application/json")
        request.startSynchronous()
        
        self.getRequest(request: request)
    }
    
    func queueEdit(groupId:String, taskid:String, taskname:String, taskdescription:String, priority:String)
    {
        let urlpath = String(format: "%@%@", kBaseURL,kqueueEdit)
        
        let request : ASIFormDataRequest = ASIFormDataRequest(url: NSURL(string: urlpath)! as URL)
        request.requestMethod = "POST"
        request.addPostValue(commonmethodClass.retrieveUsernameToken(), forKey: "token")
        request.addPostValue(groupId as NSObjectProtocol!, forKey: "groupid")
        request.addPostValue(taskid as NSObjectProtocol!, forKey: "id")
        request.addPostValue(taskname as NSObjectProtocol!, forKey: "task")
        request.addPostValue(taskdescription as NSObjectProtocol!, forKey: "info")
        request.addPostValue(priority as NSObjectProtocol!, forKey: "priority")
        request.addHeader("Accept", value: "application/json")
        request.startSynchronous()
        
        self.getRequest(request: request)
    }
    
    func queueDelete(groupId:String, taskid:String)
    {
        let urlpath = String(format: "%@%@", kBaseURL,kqueueDelete)
        
        let request : ASIFormDataRequest = ASIFormDataRequest(url: NSURL(string: urlpath)! as URL)
        request.requestMethod = "POST"
        request.addPostValue(commonmethodClass.retrieveUsernameToken(), forKey: "token")
        request.addPostValue(groupId as NSObjectProtocol!, forKey: "groupid")
        request.addPostValue(taskid as NSObjectProtocol!, forKey: "id")
        request.addHeader("Accept", value: "application/json")
        request.startSynchronous()
        
        self.getRequest(request: request)
    }
    
    func queueReject(groupId:String, taskid:String)
    {
        let urlpath = String(format: "%@%@", kBaseURL,kqueueReject)
        
        let request : ASIFormDataRequest = ASIFormDataRequest(url: NSURL(string: urlpath)! as URL)
        request.requestMethod = "POST"
        request.addPostValue(commonmethodClass.retrieveUsernameToken(), forKey: "token")
        request.addPostValue(groupId as NSObjectProtocol!, forKey: "groupid")
        request.addPostValue(taskid as NSObjectProtocol!, forKey: "id")
        request.addHeader("Accept", value: "application/json")
        request.startSynchronous()
        
        self.getRequest(request: request)
    }
    
    func getNonGroupUserList(groupId:String)
    {
        let urlpath = String(format: "%@%@", kBaseURL,knongroupuserlist)
        
        let request : ASIFormDataRequest = ASIFormDataRequest(url: NSURL(string: urlpath)! as URL)
        request.requestMethod = "POST"
        request.addPostValue(groupId as NSObjectProtocol!, forKey: "groupid")
        request.addPostValue(commonmethodClass.retrieveUsernameToken(), forKey: "token")
        request.addHeader("Accept", value: "application/json")
        request.startSynchronous()
        
        self.getRequest(request: request)
    }
    
    func InvitePeople(email:String)
    {
        let urlpath = String(format: "%@%@", kBaseURL,kteamInvite)
        print("urlpath =>\(urlpath)")
        
        let request : ASIFormDataRequest = ASIFormDataRequest(url: NSURL(string: urlpath)! as URL)
        request.requestMethod = "POST"
        request.addPostValue(commonmethodClass.retrieveUsernameToken(), forKey: "token")
        request.addPostValue(email as NSObjectProtocol!, forKey: "email")
        request.addHeader("Accept", value: "application/json")
        request.startSynchronous()
        
        self.getRequest(request: request)
    }
    
    func GroupInvitePeople(email:String, groupid:String)
    {
        let urlpath = String(format: "%@%@", kBaseURL,kgropupInvite)
        print("urlpath =>\(urlpath)")
        
        let request : ASIFormDataRequest = ASIFormDataRequest(url: NSURL(string: urlpath)! as URL)
        request.requestMethod = "POST"
        request.addPostValue(commonmethodClass.retrieveUsernameToken(), forKey: "token")
        request.addPostValue(email as NSObjectProtocol!, forKey: "email")
        request.addPostValue(groupid as NSObjectProtocol!, forKey: "groupid")
        request.addHeader("Accept", value: "application/json")
        request.startSynchronous()
        
        self.getRequest(request: request)
    }
    
    func CreateGroup(groupname:String, desc:String, privacy:String, imageData:Data, hourpermission:String, users:String)
    {
        let urlpath = String(format: "%@%@", kBaseURL,kgroupCreate)
        print("urlpath =>\(urlpath)")
        print("imageData =>\(imageData.count)")
        
        let request : ASIFormDataRequest = ASIFormDataRequest(url: NSURL(string: urlpath)! as URL)
        request.requestMethod = "POST"
        request.addPostValue(groupname as NSObjectProtocol!, forKey: "name")
        request.addPostValue(desc as NSObjectProtocol!, forKey: "description")
        request.addPostValue(privacy as NSObjectProtocol!, forKey: "type")
        request.addPostValue(hourpermission as NSObjectProtocol!, forKey: "hours")
        if imageData.count > 0
        {
            request.addData(imageData, withFileName: "image.jpeg", andContentType: "multipart/form-data", forKey: "image")
        }
        request.addPostValue(commonmethodClass.retrieveUsernameToken(), forKey: "token")
        request.addPostValue(users as NSObjectProtocol!, forKey: "users")
        request.addHeader("Accept", value: "application/json")
        request.startSynchronous()
        
        self.getRequest(request: request)
    }
    
    func UpdateGroupLogo(groupid:String, imageData:Data)
    {
        let urlpath = String(format: "%@%@", kBaseURL,kgrouplogoupdate)
        print("urlpath =>\(urlpath)")

        let request : ASIFormDataRequest = ASIFormDataRequest(url: NSURL(string: urlpath)! as URL)
        request.requestMethod = "POST"
        request.addPostValue(groupid as NSObjectProtocol!, forKey: "groupid")
        request.addData(imageData, withFileName: "image.jpeg", andContentType: "multipart/form-data", forKey: "image")
        request.addPostValue(commonmethodClass.retrieveUsernameToken(), forKey: "token")
        request.addHeader("Accept", value: "application/json")
        request.startSynchronous()
        
        self.getRequest(request: request)
    }
    
    func UpdateGroupTitle(groupid:String, name:String)
    {
        let urlpath = String(format: "%@%@", kBaseURL,kgroupNameUpdate)
        print("urlpath =>\(urlpath)")
        
        let request : ASIFormDataRequest = ASIFormDataRequest(url: NSURL(string: urlpath)! as URL)
        request.requestMethod = "POST"
        request.addPostValue(groupid as NSObjectProtocol!, forKey: "groupid")
        request.addPostValue(name as NSObjectProtocol!, forKey: "name")
        request.addPostValue(commonmethodClass.retrieveUsernameToken(), forKey: "token")
        request.addHeader("Accept", value: "application/json")
        request.startSynchronous()
        
        self.getRequest(request: request)
    }
    
    func UpdateGroupType(groupid:String, type:String)
    {
        let urlpath = String(format: "%@%@", kBaseURL,kgroupTypeUpdate)
        print("urlpath =>\(urlpath)")
        
        let request : ASIFormDataRequest = ASIFormDataRequest(url: NSURL(string: urlpath)! as URL)
        request.requestMethod = "POST"
        request.addPostValue(groupid as NSObjectProtocol!, forKey: "groupid")
        request.addPostValue(type as NSObjectProtocol!, forKey: "type")
        request.addPostValue(commonmethodClass.retrieveUsernameToken(), forKey: "token")
        request.addHeader("Accept", value: "application/json")
        request.startSynchronous()
        
        self.getRequest(request: request)
    }
    
    func UpdateGroupHours(groupid:String, hours:String)
    {
        let urlpath = String(format: "%@%@", kBaseURL,kgroupHoursUpdate)
        print("urlpath =>\(urlpath)")
        
        let request : ASIFormDataRequest = ASIFormDataRequest(url: NSURL(string: urlpath)! as URL)
        request.requestMethod = "POST"
        request.addPostValue(groupid as NSObjectProtocol!, forKey: "groupid")
        request.addPostValue(hours as NSObjectProtocol!, forKey: "hours")
        request.addPostValue(commonmethodClass.retrieveUsernameToken(), forKey: "token")
        request.addHeader("Accept", value: "application/json")
        request.startSynchronous()
        
        self.getRequest(request: request)
    }
    
    func getGroupInfo(groupid:String)
    {
        let urlpath = String(format: "%@%@", kBaseURL,kgetgroupInfo)
        print("urlpath =>\(urlpath)")
        
        let request : ASIFormDataRequest = ASIFormDataRequest(url: NSURL(string: urlpath)! as URL)
        request.requestMethod = "POST"
        request.addPostValue(groupid as NSObjectProtocol!, forKey: "groupid")
        request.addPostValue(commonmethodClass.retrieveUsernameToken(), forKey: "token")
        request.addHeader("Accept", value: "application/json")
        request.startSynchronous()
        
        self.getRequest(request: request)
    }
    
    func UpdateMarkAdmin(groupid:String, email:String) -> NSDictionary
    {
        let urlpath = String(format: "%@%@", kBaseURL,kgroupUserMarkAdmin)
        print("urlpath =>\(urlpath)")
        
        let request : ASIFormDataRequest = ASIFormDataRequest(url: NSURL(string: urlpath)! as URL)
        request.requestMethod = "POST"
        request.addPostValue(commonmethodClass.retrieveUsernameToken(), forKey: "token")
        request.addPostValue(groupid as NSObjectProtocol!, forKey: "groupid")
        request.addPostValue(email as NSObjectProtocol!, forKey: "email")
        request.addHeader("Accept", value: "application/json")
        request.startSynchronous()
        
        var responseError : NSError?
        responseError = request.error as NSError?
        
        if (responseError == nil)
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
                                    return getreponse
                                }
                                else
                                {
                                    if let errormsg = getreponse.value(forKey: "message") as? String
                                    {
                                        AlertClass().showAlert(alerttitle: "Info", alertmsg: errormsg)
                                    }
                                }
                            }
                        }
                    }
                }
                else
                {
                    AlertClass().showAlert(alerttitle: "Info", alertmsg: servererrormsg)
                }
            }
            else
            {
                AlertClass().showAlert(alerttitle: "Info", alertmsg: servererrormsg)
            }
        }
        else
        {
            AlertClass().showAlert(alerttitle: "Info", alertmsg: (responseError?.localizedDescription)!)
        }
        return NSDictionary()
    }
    
    func UpdateRemoveAdmin(groupid:String, email:String) -> NSDictionary
    {
        let urlpath = String(format: "%@%@", kBaseURL,kgroupUserRemoveAdmin)
        print("urlpath =>\(urlpath)")
        
        let request : ASIFormDataRequest = ASIFormDataRequest(url: NSURL(string: urlpath)! as URL)
        request.requestMethod = "POST"
        request.addPostValue(commonmethodClass.retrieveUsernameToken(), forKey: "token")
        request.addPostValue(groupid as NSObjectProtocol!, forKey: "groupid")
        request.addPostValue(email as NSObjectProtocol!, forKey: "email")
        request.addHeader("Accept", value: "application/json")
        request.startSynchronous()
        
        var responseError : NSError?
        responseError = request.error as NSError?
        
        if (responseError == nil)
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
                                    return getreponse
                                }
                                else
                                {
                                    if let errormsg = getreponse.value(forKey: "message") as? String
                                    {
                                        AlertClass().showAlert(alerttitle: "Info", alertmsg: errormsg)
                                    }
                                }
                            }
                        }
                    }
                }
                else
                {
                    AlertClass().showAlert(alerttitle: "Info", alertmsg: servererrormsg)
                }
            }
            else
            {
                AlertClass().showAlert(alerttitle: "Info", alertmsg: servererrormsg)
            }
        }
        else
        {
            AlertClass().showAlert(alerttitle: "Info", alertmsg: (responseError?.localizedDescription)!)
        }
        return NSDictionary()
    }
    
    func UpdateRemoveUser(groupid:String, email:String) -> NSDictionary
    {
        let urlpath = String(format: "%@%@", kBaseURL,kgroupUserRemove)
        print("urlpath =>\(urlpath)")
        
        let request : ASIFormDataRequest = ASIFormDataRequest(url: NSURL(string: urlpath)! as URL)
        request.requestMethod = "POST"
        request.addPostValue(commonmethodClass.retrieveUsernameToken(), forKey: "token")
        request.addPostValue(groupid as NSObjectProtocol!, forKey: "groupid")
        request.addPostValue(email as NSObjectProtocol!, forKey: "email")
        request.addHeader("Accept", value: "application/json")
        request.startSynchronous()
        
        var responseError : NSError?
        responseError = request.error as NSError?
        
        if (responseError == nil)
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
                                    return getreponse
                                }
                                else
                                {
                                    if let errormsg = getreponse.value(forKey: "message") as? String
                                    {
                                        AlertClass().showAlert(alerttitle: "Info", alertmsg: errormsg)
                                    }
                                }
                            }
                        }
                    }
                }
                else
                {
                    AlertClass().showAlert(alerttitle: "Info", alertmsg: servererrormsg)
                }
            }
            else
            {
                AlertClass().showAlert(alerttitle: "Info", alertmsg: servererrormsg)
            }
        }
        else
        {
            AlertClass().showAlert(alerttitle: "Info", alertmsg: (responseError?.localizedDescription)!)
        }
        return NSDictionary()
    }
    
    func SendFile(groupid:String, imageData:Data, imagesize:String, filename : String)
    {
        let urlpath = String(format: "%@%@", kChatBaseURL,ksendFile)
        print("urlpath =>\(urlpath)")
        
        let request : ASIFormDataRequest = ASIFormDataRequest(url: NSURL(string: urlpath)! as URL)
        request.requestMethod = "POST"
        request.addPostValue(commonmethodClass.retrieveuserid(), forKey: "userid")
        request.addPostValue(commonmethodClass.retrieveteamid(), forKey: "teamid")
        request.addPostValue(commonmethodClass.retrievesessionid(), forKey: "sessid")
        request.addPostValue(groupid as NSObjectProtocol!, forKey: "groupid")
        request.addData(imageData, withFileName: filename, andContentType: "multipart/form-data", forKey: "image")
        request.addPostValue(imagesize as NSObjectProtocol!, forKey: "imagesize")
        request.addHeader("Accept", value: "application/json")
        request.startSynchronous()
        
        self.getRequest(request: request)
    }
    
    func getRequest(request:ASIFormDataRequest)
    {
        var responseError : NSError?
        responseError = request.error as NSError?
        
        if (responseError == nil)
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
                        reponseMethod(reponse: reponsedictionary)
                    }
                }
                else
                {
                    AlertClass().showAlert(alerttitle: "Info", alertmsg: servererrormsg)
                }
            }
            else
            {
                AlertClass().showAlert(alerttitle: "Info", alertmsg: servererrormsg)
            }
        }
        else
        {
            AlertClass().showAlert(alerttitle: "Info", alertmsg: (responseError?.localizedDescription)!)
        }
    }
    
    func reponseMethod(reponse:NSDictionary)
    {
        if let getreponse = reponse.value(forKey: "apiResponse") as? NSDictionary
        {
            if let statuscode = getreponse.value(forKey: "status") as? NSInteger
            {
                if statuscode==1
                {
                    self.delegate?.GetReponseMethod(reponse: getreponse)
                }
                else
                {
                    if let errormsg = getreponse.value(forKey: "message") as? String
                    {
                        AlertClass().showAlert(alerttitle: "Info", alertmsg: errormsg)
                        self.delegate?.GetFailureReponseMethod(errorreponse: errormsg)
                    }
                }
            }
        }
    }
    
    func UserList(groupid:String)
    {
        let urlpath = String(format: "%@%@", kBaseURL,kuserList)
        print("urlpath =>\(urlpath)")
        
        let request : ASIFormDataRequest = ASIFormDataRequest(url: NSURL(string: urlpath)! as URL)
        request.requestMethod = "POST"
        request.addPostValue(commonmethodClass.retrieveUsernameToken(), forKey: "token")
        request.addPostValue(groupid as NSObjectProtocol!, forKey: "groupid")
        request.addHeader("Accept", value: "application/json")
        request.startSynchronous()
        
        self.getRequest(request: request)
    }
    
    func getFavMsgList(groupid:String)
    {
        let urlpath = String(format: "%@%@", kBaseURL,kgroupMessageStarred)
        print("urlpath =>\(urlpath)")
        
        let request : ASIFormDataRequest = ASIFormDataRequest(url: NSURL(string: urlpath)! as URL)
        request.requestMethod = "POST"
        request.addPostValue(commonmethodClass.retrieveUsernameToken(), forKey: "token")
        request.addPostValue(groupid as NSObjectProtocol!, forKey: "groupid")
        request.addHeader("Accept", value: "application/json")
        request.startSynchronous()
        
        self.getRequest(request: request)
    }
    
    func getDirectFavMsgList(uid:String)
    {
        let urlpath = String(format: "%@%@", kBaseURL,kdirectMessageStarred)
        print("urlpath =>\(urlpath)")
        
        let request : ASIFormDataRequest = ASIFormDataRequest(url: NSURL(string: urlpath)! as URL)
        request.requestMethod = "POST"
        request.addPostValue(commonmethodClass.retrieveUsernameToken(), forKey: "token")
        request.addPostValue(uid as NSObjectProtocol!, forKey: "uid")
        request.addHeader("Accept", value: "application/json")
        request.startSynchronous()
        
        self.getRequest(request: request)
    }
    
    func getCafeFavMsgList()
    {
        let urlpath = String(format: "%@%@", kBaseURL,kcafeMessageStarred)
        print("urlpath =>\(urlpath)")
        
        let request : ASIFormDataRequest = ASIFormDataRequest(url: NSURL(string: urlpath)! as URL)
        request.requestMethod = "POST"
        request.addPostValue(commonmethodClass.retrieveUsernameToken(), forKey: "token")
        request.addHeader("Accept", value: "application/json")
        request.startSynchronous()
        
        self.getRequest(request: request)
    }
    
    func getFilesList(groupid:String)
    {
        let urlpath = String(format: "%@%@", kBaseURL,kgroupFileList)
        print("urlpath =>\(urlpath)")
        
        let request : ASIFormDataRequest = ASIFormDataRequest(url: NSURL(string: urlpath)! as URL)
        request.requestMethod = "POST"
        request.addPostValue(commonmethodClass.retrieveUsernameToken(), forKey: "token")
        request.addPostValue(groupid as NSObjectProtocol!, forKey: "groupid")
        request.addHeader("Accept", value: "application/json")
        request.startSynchronous()
        
        self.getRequest(request: request)
    }
    
    func getDirectFilesList(uid:String)
    {
        let urlpath = String(format: "%@%@", kBaseURL,kdirectFileList)
        print("urlpath =>\(urlpath)")
        
        let request : ASIFormDataRequest = ASIFormDataRequest(url: NSURL(string: urlpath)! as URL)
        request.requestMethod = "POST"
        request.addPostValue(commonmethodClass.retrieveUsernameToken(), forKey: "token")
        request.addPostValue(uid as NSObjectProtocol!, forKey: "uid")
        request.addHeader("Accept", value: "application/json")
        request.startSynchronous()
        
        self.getRequest(request: request)
    }
    
    func getCafeFilesList()
    {
        let urlpath = String(format: "%@%@", kBaseURL,kcafeFileList)
        print("urlpath =>\(urlpath)")
        
        let request : ASIFormDataRequest = ASIFormDataRequest(url: NSURL(string: urlpath)! as URL)
        request.requestMethod = "POST"
        request.addPostValue(commonmethodClass.retrieveUsernameToken(), forKey: "token")
        request.addHeader("Accept", value: "application/json")
        request.startSynchronous()
        
        self.getRequest(request: request)
    }
    
    func CreateTask(groupid:String, taskname:String, taskdescription:String, users:String, priority:String)
    {
        let urlpath = String(format: "%@%@", kBaseURL,kcreateTask)
        print("urlpath =>\(urlpath)")
        
        let request : ASIFormDataRequest = ASIFormDataRequest(url: NSURL(string: urlpath)! as URL)
        request.requestMethod = "POST"
        request.addPostValue(commonmethodClass.retrieveUsernameToken(), forKey: "token")
        request.addPostValue(groupid as NSObjectProtocol!, forKey: "groupid")
        request.addPostValue(taskname as NSObjectProtocol!, forKey: "task")
        request.addPostValue(taskdescription as NSObjectProtocol!, forKey: "info")
        request.addPostValue(users as NSObjectProtocol!, forKey: "users")
        request.addPostValue(priority as NSObjectProtocol!, forKey: "priority")
        request.addHeader("Accept", value: "application/json")
        request.startSynchronous()
        
        self.getRequest(request: request)
    }
    
    func CreateMyTask(groupid:String, taskname:String, taskdescription:String, status:String, hours:String)
    {
        let urlpath = String(format: "%@%@", kBaseURL,kcreateMyTask)
        print("urlpath =>\(urlpath)")
        
        let request : ASIFormDataRequest = ASIFormDataRequest(url: NSURL(string: urlpath)! as URL)
        request.requestMethod = "POST"
        request.addPostValue(commonmethodClass.retrieveUsernameToken(), forKey: "token")
        request.addPostValue(groupid as NSObjectProtocol!, forKey: "groupid")
        request.addPostValue(taskname as NSObjectProtocol!, forKey: "task")
        request.addPostValue(taskdescription as NSObjectProtocol!, forKey: "info")
        request.addPostValue(status as NSObjectProtocol!, forKey: "status")
        request.addPostValue(hours as NSObjectProtocol!, forKey: "hours")
        if status == "1"
        {
            request.addPostValue(appDelegate.latitudeString as NSObjectProtocol!, forKey: "lat")
            request.addPostValue(appDelegate.longitudeString as NSObjectProtocol!, forKey: "lon")
            request.addPostValue(appDelegate.addressString as NSObjectProtocol!, forKey: "address")
        }
        request.addHeader("Accept", value: "application/json")
        request.startSynchronous()
        
        self.getRequest(request: request)
    }
    
    func TaskStatus(taskid:String, status:String, description:String, hours:String)
    {
        let urlpath = String(format: "%@%@", kBaseURL,ktaskstatus)
        print("urlpath =>\(urlpath)")
        
        let request : ASIFormDataRequest = ASIFormDataRequest(url: NSURL(string: urlpath)! as URL)
        request.requestMethod = "POST"
        request.addPostValue(commonmethodClass.retrieveUsernameToken(), forKey: "token")
        request.addPostValue(taskid as NSObjectProtocol!, forKey: "id")
        request.addPostValue(status as NSObjectProtocol!, forKey: "status")
        request.addPostValue(description as NSObjectProtocol!, forKey: "description")
        request.addPostValue(hours as NSObjectProtocol!, forKey: "hours")
        request.addPostValue(appDelegate.latitudeString as NSObjectProtocol!, forKey: "lat")
        request.addPostValue(appDelegate.longitudeString as NSObjectProtocol!, forKey: "lon")
        request.addPostValue(appDelegate.addressString as NSObjectProtocol!, forKey: "address")
        request.addHeader("Accept", value: "application/json")
        request.startSynchronous()
        
        self.getRequest(request: request)
    }
    
    func AddQueue(groupid:String, taskname:String, taskdescription:String, priority:String)
    {
        let urlpath = String(format: "%@%@", kBaseURL,kqueueadd)
        print("urlpath =>\(urlpath)")        
        
        let request : ASIFormDataRequest = ASIFormDataRequest(url: NSURL(string: urlpath)! as URL)
        request.requestMethod = "POST"
        request.addPostValue(commonmethodClass.retrieveUsernameToken(), forKey: "token")
        request.addPostValue(groupid as NSObjectProtocol!, forKey: "groupid")
        request.addPostValue(taskname as NSObjectProtocol!, forKey: "task")
        request.addPostValue(taskdescription as NSObjectProtocol!, forKey: "info")
        request.addPostValue(priority as NSObjectProtocol!, forKey: "priority")
        request.addHeader("Accept", value: "application/json")
        request.startSynchronous()
        
        self.getRequest(request: request)
    }
    
    func getCurrentTask(groupid:String)
    {
        let urlpath = String(format: "%@%@", kBaseURL,kgrouptasks)
        print("urlpath =>\(urlpath)")
        
        let request : ASIFormDataRequest = ASIFormDataRequest(url: NSURL(string: urlpath)! as URL)
        request.requestMethod = "POST"
        request.addPostValue(commonmethodClass.retrieveUsernameToken(), forKey: "token")
        request.addPostValue(groupid as NSObjectProtocol!, forKey: "groupid")
        request.addHeader("Accept", value: "application/json")
        request.startSynchronous()
        
        self.getRequest(request: request)
    }
    
    func getPastTask(groupid:String)
    {
        let urlpath = String(format: "%@%@", kBaseURL,kpasttaskgroup)
        print("urlpath =>\(urlpath)")
        
        let request : ASIFormDataRequest = ASIFormDataRequest(url: NSURL(string: urlpath)! as URL)
        request.requestMethod = "POST"
        request.addPostValue(commonmethodClass.retrieveUsernameToken(), forKey: "token")
        request.addPostValue(groupid as NSObjectProtocol!, forKey: "groupid")
        request.addHeader("Accept", value: "application/json")
        request.startSynchronous()
        
        self.getRequest(request: request)
    }
    
    func checkInOut(process:String)
    {
        let urlpath = String(format: "%@%@", kBaseURL,kcheckInOut)
        print("urlpath =>\(urlpath)")
        
        let request : ASIFormDataRequest = ASIFormDataRequest(url: NSURL(string: urlpath)! as URL)
        request.requestMethod = "POST"
        request.addPostValue(commonmethodClass.retrieveUsernameToken(), forKey: "token")
        request.addPostValue(process as NSObjectProtocol!, forKey: "process_type")
        request.addPostValue(appDelegate.latitudeString as NSObjectProtocol!, forKey: "lat")
        request.addPostValue(appDelegate.longitudeString as NSObjectProtocol!, forKey: "lon")
        request.addHeader("Accept", value: "application/json")
        request.startSynchronous()
        
        self.getRequest(request: request)
    }
    
    deinit
    {
        print("deiniting")
    }
}
