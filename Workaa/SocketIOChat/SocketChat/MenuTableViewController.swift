//
//  MenuTableViewController.swift
//  Workaa
//
//  Created by IN1947 on 02/03/17.
//  Copyright © 2017 IN1947. All rights reserved.
//

import UIKit

class MenuTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ConnectionProtocol
{
    @IBOutlet weak var menuList: UITableView!
    
    var commonmethodClass = CommonMethodClass()
    var checkInView = CheckInView()
    var menuArray = NSArray()
    var connectionClass = ConnectionClass()
    var selIndex = NSInteger()
    var overlayView = UIView()

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        connectionClass.delegate = self
        
        menuList.register(UINib(nibName: "ProfileTableViewCell", bundle: nil), forCellReuseIdentifier: "ProfileCell")
        menuList.register(UINib(nibName: "MenuTableViewCell", bundle: nil), forCellReuseIdentifier: "menucell")
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        self.loadArray()
        
        overlayView = UIView()
        overlayView.backgroundColor = UIColor.clear
        overlayView.frame = CGRect(x: CGFloat(0.0), y: CGFloat(0.0), width: CGFloat(screenWidth), height: CGFloat(screenHeight))
        overlayView.backgroundColor = UIColor.clear
        self.revealViewController().frontViewController.view.addSubview(overlayView)
        
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.closeView))
        tapGesture.numberOfTapsRequired = 1
        overlayView.addGestureRecognizer(tapGesture)
        
//        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.closeView))
//        overlayView.addGestureRecognizer(panGestureRecognizer)
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        
        overlayView.removeFromSuperview()
    }
    
    func closeView()
    {
        self.revealViewController().revealToggle(animated: true)
    }
    
    func loadArray()
    {
        if appDelegate.checkInString == "1"
        {
            menuArray = ["Bucket","Messenger","Groups","Check-Out","Logout"]
        }
        else
        {
            menuArray = ["Bucket","Messenger","Groups","Check-In","Logout"]
        }
        
        if menuList != nil
        {
            menuList.reloadData()
        }
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return menuArray.count + 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if(indexPath.row==0)
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath) as! ProfileTableViewCell
            
            let imagestring = String(format: "%@%@", kfilePath,commonmethodClass.retrieveprofileimg())
            let fileUrl = NSURL(string: imagestring)
            cell.profileimage?.imageURL = fileUrl as URL?
            
            cell.profilename.text = String(format: "%@",commonmethodClass.retrieveusername().uppercased)
            
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "menucell", for: indexPath) as! MenuTableViewCell
            
            for view : UIView in cell.contentView.subviews
            {
                if(view.frame.size.height==20)
                {
                    view.removeFromSuperview()
                }
            }
            
            cell.menunamelbl.text = String(format: "%@",menuArray[indexPath.row-1] as! CVarArg)
            
            if(indexPath.row==2 || indexPath.row==3)
            {
                let countlbl = UILabel()
                if(indexPath.row==2)
                {
                    countlbl.frame = CGRect(x: CGFloat(190.0), y: CGFloat(17.0), width: CGFloat(20.0), height: CGFloat(20.0))
                    if directunreadcount == 0
                    {
                        countlbl.isHidden = true
                    }
                    else
                    {
                        countlbl.isHidden = false
                    }
                    countlbl.text = String(format: "%d", directunreadcount)
                }
                else
                {
                    countlbl.frame = CGRect(x: CGFloat(170.0), y: CGFloat(17.0), width: CGFloat(20.0), height: CGFloat(20.0))
                    if groupunreadcount == 0
                    {
                        countlbl.isHidden = true
                    }
                    else
                    {
                        countlbl.isHidden = false
                    }
                    countlbl.text = String(format: "%d", groupunreadcount)
                }
                countlbl.font = UIFont(name: LatoBold, size: CGFloat(11.0))
                countlbl.backgroundColor = greenColor
                countlbl.textColor = UIColor.white
                countlbl.layer.cornerRadius = countlbl.frame.size.width/2.0
                countlbl.layer.masksToBounds = true
                countlbl.textAlignment = .center
                cell.contentView.addSubview(countlbl)
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if(indexPath.row==0)
        {
            return 300.0
        }
        else
        {
            return 50.0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        print("didSelectRowAt =>\(indexPath.row)")
        
        selIndex = indexPath.row
        
        if(indexPath.row==0)
        {
            self.performSegue(withIdentifier: "ProfileView", sender: indexPath)
        }
        else if(indexPath.row==1)
        {
            self.performSegue(withIdentifier: "taskList", sender: indexPath)
        }
        else if(indexPath.row==2)
        {
            self.performSegue(withIdentifier: "MessageView", sender: indexPath)
        }
        else if(indexPath.row==3)
        {
            self.performSegue(withIdentifier: "groupList", sender: indexPath)
        }
        else if(indexPath.row==4)
        {
            if appDelegate.checkInString == "1"
            {
                if let checkoutreponse = checkInReponse.value(forKey: "checkOutList") as? NSDictionary
                {
                    connectionClass.checkInOut(process: String(format: "%@", checkoutreponse.value(forKey: "id") as! CVarArg))
                }
            }
            else if (appDelegate.checkInString == "2" || appDelegate.checkInString == "0")
            {
                self.loadCheckInView()
            }
        }
        else if(indexPath.row==5)
        {
            connectionClass.logOut()
            
            self.revealViewController().revealToggle(animated: false)
            commonmethodClass.removeallkey()
            
            var isView : Bool!
            isView = false
            
            var viewcontroller = UIViewController()
            
            for aviewcontroller : UIViewController in navigation().viewControllers
            {
                if aviewcontroller is WelcomeViewController
                {
                    viewcontroller = aviewcontroller
                    isView = true
                    break
                }
            }
            
            if isView==true
            {
                navigation().popToViewController(viewcontroller, animated: false)
            }
            else
            {
                let welcomeObj = storyboard?.instantiateViewController(withIdentifier: "WelcomeViewID") as? WelcomeViewController
                navigation().pushViewController(welcomeObj!, animated: false)
            }
        }
    }
    
    func loadCheckInView()
    {
        for v: UIView in checkInView.subviews {
            v.removeFromSuperview()
        }
        checkInView.removeFromSuperview()
        
        checkInView = Bundle.main.loadNibNamed("CheckInView", owner: nil, options: nil)?[0] as! CheckInView
        checkInView.frame = CGRect(x: 0.0, y: 0.0, width: screenWidth, height: screenHeight)
        checkInView.loadCheckInView()
        //appDelegate.window?.addSubview(checkInView)
        self.revealViewController().view.addSubview(checkInView)
    }
    
    func GetFailureReponseMethod(errorreponse: String)
    {
        print("GetFailureReponseMethod")
    }
    
    func GetReponseMethod(reponse : NSDictionary)
    {
        print("reponse => \(reponse)")
        
        if(selIndex==4)
        {
            appDelegate.checkInString = "2"
            
            self.loadArray()
        }
        if(selIndex==5)
        {
//            self.revealViewController().revealToggle(animated: false)
//            commonmethodClass.removeallkey()
//            
//            var isView : Bool!
//            isView = false
//            
//            var viewcontroller = UIViewController()
//            
//            for aviewcontroller : UIViewController in navigation().viewControllers
//            {
//                if aviewcontroller is WelcomeViewController
//                {
//                    viewcontroller = aviewcontroller
//                    isView = true
//                    break
//                }
//            }
//            
//            if isView==true
//            {
//                navigation().popToViewController(viewcontroller, animated: false)
//            }
//            else
//            {
//                let welcomeObj = storyboard?.instantiateViewController(withIdentifier: "WelcomeViewID") as? WelcomeViewController
//                navigation().pushViewController(welcomeObj!, animated: false)
//            }
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
}
