//
//  FavGroupMsgViewController.swift
//  Workaa
//
//  Created by IN1947 on 08/05/17.
//  Copyright © 2017 IN1947. All rights reserved.
//

import UIKit

class FavMsgViewController: UIViewController, ConnectionProtocol, UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet weak var tblfavlist: UITableView!

    var connectionClass = ConnectionClass()
    var commonmethodClass = CommonMethodClass()
    var groupdictionary = NSDictionary()
    var userdictionary = NSDictionary()
    var favmsgArray = NSArray()
    var chattype = String()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        print("groupdictionary =>\(groupdictionary)")
        print("userdictionary =>\(userdictionary)")
        print("chattype =>\(chattype)")

        self.title = "Favourite Messages"
        
        connectionClass.delegate = self
        
        commonmethodClass.delayWithSeconds(0.1, completion: {
            self.getFavMsgList()
        })
        
        tblfavlist.register(UITableViewCell.classForKeyedArchiver(), forCellReuseIdentifier: "idCellFavMsg")
    }
    
    func getFavMsgList()
    {
        if chattype == "DirectChat"
        {
            connectionClass.getDirectFavMsgList(uid: String(format: "%@", userdictionary.value(forKey: "id") as! CVarArg))
        }
        else if chattype == "CafeChat"
        {
            connectionClass.getCafeFavMsgList()
        }
        else
        {
            connectionClass.getFavMsgList(groupid: String(format: "%@", groupdictionary.value(forKey: "id") as! CVarArg))
        }
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
            if let favmsglist = getreponse.value(forKey: "messageList") as? NSArray
            {
                favmsgArray = favmsglist
                
                tblfavlist.reloadData()
            }
        }
    }
    
    // MARK: UITableView Delegate and Datasource Methods
    
    private func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return favmsgArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "idCellFavMsg") as UITableViewCell!
        
        let imageView : UIImageView
        imageView  = UIImageView(frame:CGRect(x: 13, y: 13, width: 15, height: 15))
        imageView.image = UIImage(named: "yellowstar.png")
        cell.contentView.addSubview(imageView)
        
        let favdictionary = favmsgArray[indexPath.row] as! NSDictionary
        let infostring = String(format: "%@",favdictionary.value(forKey: "info") as! CVarArg)
        let ownstring = String(format: "%@",favdictionary.value(forKey: "own") as! CVarArg)
        
        cell.textLabel?.font = UIFont(name: LatoRegular, size: 17.0)

        var messagestring = ""
        var attributedString = NSMutableAttributedString()
        if infostring == "message" || infostring == "share"
        {
            if ownstring == "1"
            {
                messagestring = String(format: "    Your message in :\n%@",favdictionary.value(forKey: "message") as! CVarArg)
                
                let msgrange = (messagestring as NSString).range(of: "Your message in :")
                attributedString = NSMutableAttributedString(string:messagestring)
                attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.lightGray , range: msgrange)
            }
            else
            {
                messagestring = String(format: "    %@'s message in :\n%@",favdictionary.value(forKey: "username") as! CVarArg, favdictionary.value(forKey: "message") as! CVarArg)
                
                let msgrange = (messagestring as NSString).range(of: "'s message in :")
                let namerange = (messagestring as NSString).range(of: favdictionary.value(forKey: "username") as! String)
                attributedString = NSMutableAttributedString(string:messagestring)
                attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.lightGray , range: msgrange)
                attributedString.addAttribute(NSForegroundColorAttributeName, value: blueColor , range: namerange)
                attributedString.addAttribute(NSFontAttributeName, value: UIFont (name: LatoBold, size: 17.0)! , range: namerange)
            }
        }
        if infostring == "file"
        {
            let filedictionary = favdictionary.value(forKey: "file") as! NSDictionary
            
            if ownstring == "1"
            {
                messagestring = String(format: "    Your file :\n%@",filedictionary.value(forKey: "title") as! CVarArg)
                
                let msgrange = (messagestring as NSString).range(of: "Your file :")
                let namerange = (messagestring as NSString).range(of: filedictionary.value(forKey: "title") as! String)
                attributedString = NSMutableAttributedString(string:messagestring)
                attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.lightGray , range: msgrange)
                attributedString.addAttribute(NSForegroundColorAttributeName, value: blueColor , range: namerange)
                attributedString.addAttribute(NSFontAttributeName, value: UIFont (name: LatoBold, size: 17.0)! , range: namerange)
            }
            else
            {
                messagestring = String(format: "    %@'s file :\n%@",favdictionary.value(forKey: "username") as! CVarArg, filedictionary.value(forKey: "title") as! CVarArg)
                
                let msgrange = (messagestring as NSString).range(of: "'s file :")
                let titlerange = (messagestring as NSString).range(of: filedictionary.value(forKey: "title") as! String)
                let namerange = (messagestring as NSString).range(of: favdictionary.value(forKey: "username") as! String)
                attributedString = NSMutableAttributedString(string:messagestring)
                attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.lightGray , range: msgrange)
                attributedString.addAttribute(NSForegroundColorAttributeName, value: blueColor , range: titlerange)
                attributedString.addAttribute(NSFontAttributeName, value: UIFont (name: LatoBold, size: 17.0)! , range: titlerange)
                attributedString.addAttribute(NSForegroundColorAttributeName, value: blueColor , range: namerange)
                attributedString.addAttribute(NSFontAttributeName, value: UIFont (name: LatoBold, size: 17.0)! , range: namerange)
            }
        }
        if infostring == "comment"
        {
            let filedictionary = favdictionary.value(forKey: "source") as! NSDictionary
            
            if ownstring == "1"
            {
                messagestring = String(format: "    Your comment on :\n%@",filedictionary.value(forKey: "file_title") as! CVarArg)
                
                let msgrange = (messagestring as NSString).range(of: "Your comment on :")
                let namerange = (messagestring as NSString).range(of: filedictionary.value(forKey: "file_title") as! String)
                attributedString = NSMutableAttributedString(string:messagestring)
                attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.lightGray , range: msgrange)
                attributedString.addAttribute(NSForegroundColorAttributeName, value: blueColor , range: namerange)
                attributedString.addAttribute(NSFontAttributeName, value: UIFont (name: LatoBold, size: 17.0)! , range: namerange)
            }
            else
            {
                messagestring = String(format: "    %@'s comment on :\n%@",favdictionary.value(forKey: "username") as! CVarArg, filedictionary.value(forKey: "file_title") as! CVarArg)
                
                let msgrange = (messagestring as NSString).range(of: "'s comment on :")
                let titlerange = (messagestring as NSString).range(of: filedictionary.value(forKey: "file_title") as! String)
                let namerange = (messagestring as NSString).range(of: favdictionary.value(forKey: "username") as! String)
                attributedString = NSMutableAttributedString(string:messagestring)
                attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.lightGray , range: msgrange)
                attributedString.addAttribute(NSForegroundColorAttributeName, value: blueColor , range: titlerange)
                attributedString.addAttribute(NSFontAttributeName, value: UIFont (name: LatoBold, size: 17.0)! , range: titlerange)
                attributedString.addAttribute(NSForegroundColorAttributeName, value: blueColor , range: namerange)
                attributedString.addAttribute(NSFontAttributeName, value: UIFont (name: LatoBold, size: 17.0)! , range: namerange)
            }
        }
        
        cell.textLabel?.attributedText = attributedString
        cell.textLabel?.numberOfLines = 100000000
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let favdictionary = favmsgArray[indexPath.row] as! NSDictionary
        let idstring = String(format: "%@",favdictionary.value(forKey: "id") as! CVarArg)
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Remove Favourite", style: .default , handler:{ (UIAlertAction)in
            
            if self.chattype == "DirectChat"
            {
                SocketIOManager.sharedInstance.directRemoveFav(idstring: idstring, uid: String(format: "%@", self.userdictionary.value(forKey: "id") as! CVarArg)) { (messageInfo) -> Void in
                    
                    print("Send messageInfo =>\(messageInfo)")
                    
                    if let getreponse = messageInfo.value(forKey: "apiResponse") as? NSDictionary
                    {
                        if let statuscode = getreponse.value(forKey: "status") as? NSInteger
                        {
                            if statuscode==1
                            {
                                self.getFavMsgList()
                            }
                            else
                            {
                                print("MSG ERROR")
                            }
                        }
                    }
                }
            }
            else if self.chattype == "CafeChat"
            {
                SocketIOManager.sharedInstance.cafeRemoveFav(idstring: idstring) { (messageInfo) -> Void in
                    
                    print("Send messageInfo =>\(messageInfo)")
                    
                    if let getreponse = messageInfo.value(forKey: "apiResponse") as? NSDictionary
                    {
                        if let statuscode = getreponse.value(forKey: "status") as? NSInteger
                        {
                            if statuscode==1
                            {
                                self.getFavMsgList()
                            }
                            else
                            {
                                print("MSG ERROR")
                            }
                        }
                    }
                }
            }
            else
            {
                SocketIOManager.sharedInstance.groupRemoveFav(idstring: idstring, groupid: String(format: "%@", self.groupdictionary.value(forKey: "id") as! CVarArg)) { (messageInfo) -> Void in
                    
                    print("Send messageInfo =>\(messageInfo)")
                    
                    if let getreponse = messageInfo.value(forKey: "apiResponse") as? NSDictionary
                    {
                        if let statuscode = getreponse.value(forKey: "status") as? NSInteger
                        {
                            if statuscode==1
                            {
                                self.getFavMsgList()
                            }
                            else
                            {
                                print("MSG ERROR")
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        let favdictionary = favmsgArray[indexPath.row] as! NSDictionary
        let ownstring = String(format: "%@",favdictionary.value(forKey: "own") as! CVarArg)
        let infostring = String(format: "%@",favdictionary.value(forKey: "info") as! CVarArg)

        var messagestring = ""
        if infostring == "message" || infostring == "share"
        {
            if ownstring == "1"
            {
                messagestring = String(format: "    Your message in :\n%@",favdictionary.value(forKey: "message") as! CVarArg)
            }
            else
            {
                messagestring = String(format: "    %@'s message in :\n%@",favdictionary.value(forKey: "username") as! CVarArg, favdictionary.value(forKey: "message") as! CVarArg)
            }
        }
        if infostring == "file"
        {
            let filedictionary = favdictionary.value(forKey: "file") as! NSDictionary
            
            if ownstring == "1"
            {
                messagestring = String(format: "    Your file :\n%@",filedictionary.value(forKey: "title") as! CVarArg)
            }
            else
            {
                messagestring = String(format: "    %@'s file :\n%@",favdictionary.value(forKey: "username") as! CVarArg, filedictionary.value(forKey: "title") as! CVarArg)
            }
        }
        if infostring == "comment"
        {
            let filedictionary = favdictionary.value(forKey: "source") as! NSDictionary
            
            if ownstring == "1"
            {
                messagestring = String(format: "    Your comment on :\n%@",filedictionary.value(forKey: "file_title") as! CVarArg)
            }
            else
            {
                messagestring = String(format: "    %@'s comment on :\n%@",favdictionary.value(forKey: "username") as! CVarArg, filedictionary.value(forKey: "file_title") as! CVarArg)
            }
        }
        
        var txtheight : CGFloat!
        txtheight = commonmethodClass.dynamicHeight(width: screenWidth-40, font: UIFont(name: LatoRegular, size: 17.0)!, string: messagestring as String)
        txtheight = ceil(txtheight)
        txtheight = txtheight + 20.0

        return txtheight
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
