//
//  AlertClass.swift
//  Workaa
//
//  Created by IN1947 on 05/11/16.
//  Copyright © 2016 IN1947. All rights reserved.
//

import UIKit

class AlertClass: UIView, ConnectionProtocol, UITextViewDelegate
{
    var connectionClass = ConnectionClass()
    var notdonetask = UIAlertController()
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    func showAlert(alerttitle : String, alertmsg : String)
    {
        let alertController = UIAlertController(title: alerttitle, message: alertmsg, preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        rootViewController?.present(alertController, animated: true, completion: nil)
    }
    
    func profileAttachment()
    {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Take Photo", style: .default , handler:{ (UIAlertAction)in
            
            for aviewcontroller : UIViewController in navigation().viewControllers
            {
                if let profileView = aviewcontroller as? ProfileViewController
                {
                    profileView.camera()
                    break
                }
            }
            
        }))
        
        alert.addAction(UIAlertAction(title: "Choose From Library", style: .default , handler:{ (UIAlertAction)in
            
            for aviewcontroller : UIViewController in navigation().viewControllers
            {
                if let profileView = aviewcontroller as? ProfileViewController
                {
                    profileView.library()
                    break
                }
            }
            
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel , handler:{ (UIAlertAction)in
            print("Cancel")
        }))
        
        rootViewController?.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
        
    func createTeamAttachment()
    {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Take Photo", style: .default , handler:{ (UIAlertAction)in
            
            for aviewcontroller : UIViewController in navigation().viewControllers
            {
                if let createteamView = aviewcontroller as? CreateTeamViewController
                {
                    createteamView.camera()
                    break
                }
            }
            
        }))
        
        alert.addAction(UIAlertAction(title: "Choose From Library", style: .default , handler:{ (UIAlertAction)in
            
            for aviewcontroller : UIViewController in navigation().viewControllers
            {
                if let createteamView = aviewcontroller as? CreateTeamViewController
                {
                    createteamView.library()
                    break
                }
            }
            
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel , handler:{ (UIAlertAction)in
            print("Cancel")
        }))
        
        rootViewController?.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
    
    func createGroupAttachment()
    {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Take Photo", style: .default , handler:{ (UIAlertAction)in
            
            for aviewcontroller : UIViewController in navigation().viewControllers
            {
                if let creategroupView = aviewcontroller as? CreateGroupViewController
                {
                    creategroupView.camera()
                    break
                }
            }
            
        }))
        
        alert.addAction(UIAlertAction(title: "Choose From Library", style: .default , handler:{ (UIAlertAction)in
            
            for aviewcontroller : UIViewController in navigation().viewControllers
            {
                if let creategroupView = aviewcontroller as? CreateGroupViewController
                {
                    creategroupView.library()
                    break
                }
            }
            
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel , handler:{ (UIAlertAction)in
            print("Cancel")
        }))
        
        rootViewController?.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
    
    func attachmentAlert()
    {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Take Photo", style: .default , handler:{ (UIAlertAction)in
            
            for aviewcontroller : UIViewController in navigation().viewControllers
            {
                if let groupView = aviewcontroller as? GroupViewController
                {
                    groupView.camera()
                    break
                }
            }
            for aviewcontroller : UIViewController in navigation().viewControllers
            {
                if let cafeView = aviewcontroller as? CafeViewController
                {
                    cafeView.camera()
                    break
                }
            }
            for aviewcontroller : UIViewController in navigation().viewControllers
            {
                if let onetooneView = aviewcontroller as? OneToOneChatViewController
                {
                    onetooneView.camera()
                    break
                }
            }
            
        }))
        
        alert.addAction(UIAlertAction(title: "Choose From Library", style: .default , handler:{ (UIAlertAction)in
            
            for aviewcontroller : UIViewController in navigation().viewControllers
            {
                if let groupView = aviewcontroller as? GroupViewController
                {
                    groupView.library()
                    break
                }
            }
            for aviewcontroller : UIViewController in navigation().viewControllers
            {
                if let cafeView = aviewcontroller as? CafeViewController
                {
                    cafeView.library()
                    break
                }
            }
            for aviewcontroller : UIViewController in navigation().viewControllers
            {
                if let onetooneView = aviewcontroller as? OneToOneChatViewController
                {
                    onetooneView.library()
                    break
                }
            }
            
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel , handler:{ (UIAlertAction)in
            print("Cancel")
        }))
        
        rootViewController?.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
    
    func donetaskAlert(taskid:String)
    {
        let donetask = UIAlertController(title: "Task", message: "", preferredStyle: UIAlertControllerStyle.alert)
        
        donetask.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
        donetask.addAction(UIAlertAction(title: "Submit", style: UIAlertActionStyle.default, handler: { (action) -> Void in
            
            let txtField = donetask.textFields![0] as UITextField
            print("txtField =>\(String(describing: txtField.text))")
            
            if (txtField.text?.characters.count)! > 0
            {
                self.doneSaveAction(taskid: taskid, hours: txtField.text!)
            }
            else
            {
                AlertClass().showAlert(alerttitle: "Info", alertmsg: taskStatusReponse.value(forKey: "hoursRequired") as! String)
            }
            
        }))
        donetask.addTextField(configurationHandler: {(textField: UITextField!) in
            textField.placeholder = "Hours"
            textField.attributedPlaceholder = NSAttributedString(string: textField.placeholder!, attributes: [NSForegroundColorAttributeName:UIColor.darkGray])
            textField.keyboardType = UIKeyboardType.decimalPad
            textField.textColor = UIColor.darkGray
        })
        
        rootViewController?.present(donetask, animated: true, completion: nil)
    }
    
    func doneSaveAction(taskid:String, hours:String)
    {
        self.connectionClass.delegate = self
        self.connectionClass.TaskStatus(taskid: taskid, status: "1", description: "", hours: hours)
    }
    
    func notdonetaskAlert(taskid:String)
    {
        notdonetask = UIAlertController(title: "Task\n\n\n\n\n\n\n", message: "", preferredStyle: UIAlertControllerStyle.alert)
        
        let rect = CGRect(x: 5.0, y: 60.0, width: 260.0, height: 150.0)
        let textView = UITextView(frame: rect)
        textView.font               = UIFont(name: LatoRegular, size: 16)
        textView.textColor          = UIColor.lightGray
        textView.backgroundColor    = UIColor.white
        textView.layer.borderColor  = UIColor.lightGray.cgColor
        textView.layer.borderWidth  = 0.5
        textView.text               = "Description"
        textView.layer.cornerRadius = 5.0
        textView.delegate           = self
        notdonetask.view.addSubview(textView)
        
        CommonMethodClass().delayWithSeconds(0.5, completion: {
            textView.becomeFirstResponder()
            UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseInOut, animations: {() -> Void in
                self.notdonetask.view.center = CGPoint(x: screenWidth/2.0, y: (screenHeight/2.0)-110.0)
            }, completion: { _ in })
        })
        
        notdonetask.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
        notdonetask.addAction(UIAlertAction(title: "Submit", style: UIAlertActionStyle.default, handler: { (action) -> Void in
            
            if (textView.text?.characters.count)! > 255
            {
                AlertClass().showAlert(alerttitle: "Info", alertmsg: taskStatusReponse.value(forKey: "descriptionLength") as! String)
            }
            else
            {
                self.notdoneSaveAction(taskid: taskid, description: textView.text!)
            }
            
        }))
        
        rootViewController?.present(notdonetask, animated: true, completion: nil)
    }
    
    func notdoneSaveAction(taskid:String, description:String)
    {
        self.connectionClass.delegate = self
        self.connectionClass.TaskStatus(taskid: taskid, status: "0", description: description, hours: "")
    }
    
    // MARK: UITextView Delegate

    func textViewDidBeginEditing(_ textView: UITextView)
    {
        if textView.textColor == UIColor.lightGray
        {
            textView.text = ""
            textView.textColor = UIColor.darkGray
        }
        
        CommonMethodClass().delayWithSeconds(0.3, completion: {
            UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseInOut, animations: {() -> Void in
                self.notdonetask.view.center = CGPoint(x: screenWidth/2.0, y: (screenHeight/2.0)-110.0)
            }, completion: { _ in })
        })
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool
    {
        if (text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    func textViewDidChange(_ textView: UITextView)
    {
        if textView.text.characters.count == 0
        {
            
        }
        else
        {
            
        }
    }
    
    // MARK: Connection Delegate
    
    func GetFailureReponseMethod(errorreponse: String)
    {
        print("GetFailureReponseMethod")
    }
    
    func GetReponseMethod(reponse : NSDictionary)
    {
        print("reponse => \(reponse)")
        
        for aviewcontroller : UIViewController in navigation().viewControllers
        {
            if let tasklistView = aviewcontroller as? TaskListViewController
            {
                tasklistView.getMyBucketList()
                break
            }
        }
        for aviewcontroller : UIViewController in navigation().viewControllers
        {
            if let homedetailView = aviewcontroller as? HomeDetailViewController
            {
                homedetailView.getMyBucketList()
                break
            }
        }
        for aviewcontroller : UIViewController in navigation().viewControllers
        {
            if let bucketdetailView = aviewcontroller as? BucketDetailViewController
            {
                bucketdetailView.close()
                break
            }
        }
    }
}
