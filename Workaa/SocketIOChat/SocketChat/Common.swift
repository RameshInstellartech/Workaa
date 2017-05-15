//
//  Common.swift
//  Workaa
//
//  Created by IN1947 on 02/11/16.
//  Copyright © 2016 IN1947. All rights reserved.
//


import UIKit


// SERVER Details

//let kBaseURL = "http://35.160.88.112:81/mobileapi/"
//let kChatBaseURL = "http://35.160.88.112:3000"
//let kBaseURL = "http://192.168.1.2:81/mobileapi/"
//let kBaseURL = "http://35.166.72.7:81/mobileapi/"
//let kChatBaseURL = "http://35.166.72.7:5000/"
//let kfilePath = "http://35.166.72.7:81"

//let kBaseURL = "http://192.168.1.2:8000/mobileapi/"
//let kChatBaseURL = "http://192.168.1.2:81/"
//let kfilePath = "http://192.168.1.2:8000"

var kBaseURL = ""
var kChatBaseURL = ""
var kfilePath = ""

//let kUrlPath = "http://192.168.1.2:82/ios/"
let kUrlPath = "http://dotsit.in/backend/ios/"

// DEFINE AND INITAILZE Details

let uniqueId = (UIDevice.current.identifierForVendor?.uuidString)! as String
let rootViewController =  UIApplication.shared.keyWindow?.rootViewController

func navigation() -> UINavigationController {
    var NVc: UINavigationController?
    let side: SWRevealViewController? = (rootViewController as? SWRevealViewController)
    for viewcontroller: UIViewController in (side?.childViewControllers)! {
        if (viewcontroller is UINavigationController) {
            NVc = (viewcontroller as? UINavigationController)
            break
        }
    }
    return NVc!
}

var kDeviceToken = ""
let kDevice = "2"
let kEncryptionKey = "c_7#nTbCmXgXG7R!8^MW2)6u1^JjB6sh"
let appDelegate = UIApplication.shared.delegate as! AppDelegate
let managedContext = appDelegate.managedObjectContext
var signUpReponse = NSDictionary()
var signInReponse = NSDictionary()
var checkInReponse = NSDictionary()
var teamInviteReponse = NSDictionary()
var groupInviteReponse = NSDictionary()
var groupCreateReponse = NSDictionary()
var taskAddReponse = NSDictionary()
var taskStatusReponse = NSDictionary()
var queueToTaskReponse = NSDictionary()
var socketOnReponse = NSDictionary()
var servererrormsg = String()
var directunreadcount = NSInteger()
var groupunreadcount = NSInteger()

// SCREEN SIZE Details

let kResizewidth : CGFloat = 800
let screenWidth = UIScreen.main.bounds.width
let screenHeight = UIScreen.main.bounds.height
let SCREEN_MAX_LENGTH    = max(screenWidth, screenHeight)
let SCREEN_MIN_LENGTH    = min(screenWidth, screenHeight)
let IS_IPHONE_4_OR_LESS  = UIDevice.current.userInterfaceIdiom == .phone && SCREEN_MAX_LENGTH < 568.0
let IS_IPHONE_5          = UIDevice.current.userInterfaceIdiom == .phone && SCREEN_MAX_LENGTH == 568.0
let IS_IPHONE_6          = UIDevice.current.userInterfaceIdiom == .phone && SCREEN_MAX_LENGTH == 667.0
let IS_IPHONE_6P         = UIDevice.current.userInterfaceIdiom == .phone && SCREEN_MAX_LENGTH == 736.0
let IS_IPAD              = UIDevice.current.userInterfaceIdiom == .pad && SCREEN_MAX_LENGTH == 1024.0
let IS_IPAD_PRO          = UIDevice.current.userInterfaceIdiom == .pad && SCREEN_MAX_LENGTH == 1366.0


// COLOR Details

let blueColor = UIColor(red: 0/255, green: 202/255, blue: 252/255, alpha: 1)
let greenColor = UIColor(red: 24/255, green: 208/255, blue: 124/255, alpha: 1)
let redColor = UIColor(red: 255/255, green: 57/255, blue: 61/255, alpha: 1)
let lightgrayColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
func getRandomColor() -> UIColor
{
    let randomRed:CGFloat = CGFloat(drand48())
    let randomGreen:CGFloat = CGFloat(drand48())
    let randomBlue:CGFloat = CGFloat(drand48())
    return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
}
let cafeColor = UIColor(red: 126/255, green: 77/255, blue: 151/255, alpha: 1)

// FONT Details

let LatoBold = "Lato-Bold"
let LatoRegular = "Lato-Regular"
let LatoLight = "Lato-Light"
let LatoBlack = "Lato-Black"
let LatoItalic = "Lato-Italic"
let Workaa_Font = "icomoon"

// API Methods

let kappLabelDomain = "appLabelDomain/"
let kappLabel = "appLabel/"
let kregister = "register/"
let klogin = "login/"
let kteamlist = "teamList/"
let kgrouplist = "groupList/"
let kcreateTeam = "teamCreate/"
let kselectTeam = "teamAssign/"
let kteamInvite = "teamInvite/"
let kgroupCreate = "groupCreate/"
let knongroupuserlist = "nonGroupUserList/"
let kgropupInvite = "groupInvite/"
let ksendFile = "InsertImageGroupChat/"
let konetoonesendFile = "InsertImageDirectChat/"
let kcafesendFile = "InsertImageCafeChat/"
let kuserList = "groupUserList/"
let kcreateTask = "taskAdd/"
let kcreateMyTask = "myTaskAdd/"
let kmybucketlist = "myBucketList/"
let ktaskstatus = "taskStatus/"
let kqueueadd = "queueAdd/"
let kqueuelist = "myQueueList/"
let kqueuetotask = "queueToTask/"
let kgrouptasks = "getGroupTasks/"
let kpasttaskgroup = "getGroupPastTasks/"
let kuserInfo = "userInfo/"
let kuserpicupload = "userPicUpload/"
let kgeneraluserinfo = "generalUserInfo/"
let kcontactuserinfo = "contactUserInfo/"
let kworkuserinfo = "workUserInfo/"
let kteamuserslist = "teamUsersList/"
let kteamverify = "teamDomainVerify/"
let kemailIdVerify = "emailIdVerify/"
let kverifyEmail = "verifyEmail/"
let kcheckInOut = "checkInOut/"
let klogOut = "logout/"
let kgetgroupmsg = "groupMessage/"
let kgrouplogoupdate = "groupLogoUpdate/"
let kgroupNameUpdate = "groupNameUpdate/"
let kgroupTypeUpdate = "groupTypeUpdate/"
let kgroupHoursUpdate = "groupHoursUpdate/"
let kgroupUserMarkAdmin = "groupUserMarkAdmin/"
let kgroupUserRemoveAdmin = "groupUserRemoveAdmin/"
let kgroupUserRemove = "groupUserRemove/"
let kgroupMessageStarred = "groupMessageStarred/"
let kgroupFileList = "groupFileList/"
let kdirectMessageStarred = "directMessageStarred/"
let kcafeMessageStarred = "cafeMessageStarred/"
let kdirectFileList = "directFileList/"
let kcafeFileList = "cafeFileList/"

// Icon Codes

let homeIcon = "\u{e918}"
let taskIcon = "\u{e90f}"
let messageIcon = "\u{e903}"
let cafeIcon = "\u{e902}"
let checkInNowIcon = "\u{e906}"
let checkInLaterIcon = "\u{e900}"
let remindMeIcon = "\u{e901}"
let leaveIcon = "\u{e90b}"
let closeIcon = "\u{e919}"
let menuIcon = "\u{e91b}"
let clockIcon = "\u{e91a}"
let notifiIcon = "\u{e917}"
let backarrowIcon = "\u{f104}"
let tickIcon = "\u{e5ca}"
let editIcon = "\u{e916}"
let plusIcon = "\u{e145}"
let rightarrowIcon = "\u{e91c}"
let sendIcon = "\u{e90c}"
let cameraIcon = "\u{e907}"
let personIcon = "\u{e909}"
let roundplusIcon = "\u{e90e}"
let roundtickIcon = "\u{e914}"
let solidrightarrowIcon = "\u{f105}"
let soliddownarrowIcon = "\u{f107}"
let soliduparrowIcon = "\u{f106}"
let adduserIcon = "\u{e91d}"
let attachIcon = "\u{e91e}"
let cmtIcon = "\u{e903}"
let filesIcon = "\u{e915}"

