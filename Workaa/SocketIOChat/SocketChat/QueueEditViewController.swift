//
//  QueueEditViewController.swift
//  Workaa
//
//  Created by IN1947 on 29/05/17.
//  Copyright © 2017 IN1947. All rights reserved.
//

import UIKit

@objc protocol QueueUpdate:class
{
    func refreshTaskDetails()
}

class QueueEditViewController: UIViewController, UITextViewDelegate, ConnectionProtocol
{
    @IBOutlet weak var taskField : PlaceholderTextView!
    @IBOutlet weak var descriptionView : PlaceholderTextView!
    @IBOutlet weak var goruplbl : UILabel!
    @IBOutlet weak var scrollview : UIScrollView!
    @IBOutlet weak var switchtype : TTFadeSwitch!
    @IBOutlet weak var grouplogo : AsyncImageView!

    var taskDictionary = NSMutableDictionary()
    var connectionClass = ConnectionClass()
    weak var delegate:QueueUpdate?

    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        connectionClass.delegate = self

        self.title = "Queue Edit"
        
        let rightcontainView = UIView()
        rightcontainView.frame = CGRect(x: 0.0, y: 0.0, width: 44.0, height: 44.0)
        let closeiconbtn = UIButton()
        closeiconbtn.frame = CGRect(x: CGFloat(0.0), y: CGFloat(0.0), width: CGFloat(44.0), height: CGFloat(44.0))
        closeiconbtn.titleLabel?.font = UIFont(name: Workaa_Font, size: CGFloat(25.0))
        closeiconbtn.backgroundColor = UIColor.clear
        closeiconbtn.setTitleColor(UIColor.white, for: .normal)
        closeiconbtn.setTitle(closeIcon, for: .normal)
        closeiconbtn.contentHorizontalAlignment = .right
        closeiconbtn.addTarget(self, action: #selector(self.closeaction), for: .touchUpInside)
        rightcontainView.addSubview(closeiconbtn)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightcontainView)
        
        switchtype.thumbImage = UIImage(named: "switchToggle")
        switchtype.thumbHighlightImage = UIImage(named: "switchToggleHigh")
        switchtype.trackMaskImage = UIImage(named: "switchMask")
        switchtype.viewstring = "addQueue"
        switchtype.onString = "NORMAL"
        switchtype.offString = "HIGH  "
        switchtype.onLabel.font = UIFont(name: LatoBlack, size: CGFloat(11.0))!
        switchtype.offLabel.font = UIFont(name: LatoBlack, size: CGFloat(11.0))!
        switchtype.onLabel.textColor = UIColor.white
        switchtype.offLabel.textColor = UIColor.white
        switchtype.labelsEdgeInsets = UIEdgeInsetsMake(0.0, 13.0, 0.0, 26.0)
        switchtype.thumbInsetX = -3.0
        switchtype.thumbOffsetY = 2.0
        switchtype.isOn = true
        
        let type = String(format: "%@", taskDictionary.value(forKey: "priority") as! CVarArg)
        if type == "0"
        {
            switchtype.isOn = true
        }
        else
        {
            switchtype.isOn = false
        }
        
        let filestring = String(format: "%@%@", kfilePath, taskDictionary.value(forKey: "groupLogo") as! CVarArg)
        let fileUrl = NSURL(string: filestring)
        grouplogo.imageURL = fileUrl as URL?
        
        goruplbl.text = String(format: "%@", taskDictionary.value(forKey: "groupName") as! CVarArg)
        
        taskField.text = String(format: "%@", taskDictionary.value(forKey: "task") as! CVarArg)
        
        descriptionView.text = String(format: "%@", taskDictionary.value(forKey: "info") as! CVarArg)

        print("taskDictionary =>\(taskDictionary)")
    }
    
    func closeaction()
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func updateaction(sender : AnyObject)
    {
        if(taskField.text?.characters.count==0)
        {
            self.showAlert(alerttitle: "Info", alertmsg: queueToTaskReponse.value(forKey: "taskRequired") as! String)
        }
        else if((taskField.text?.characters.count)!>255)
        {
            self.showAlert(alerttitle: "Info", alertmsg: queueToTaskReponse.value(forKey: "taskLength") as! String)
        }
        else
        {
            var priority = "0"
            if(!switchtype.isOn)
            {
                priority = "1"
            }
            
            connectionClass.queueEdit(groupId: taskDictionary.value(forKey: "groupId") as! String, taskid: taskDictionary.value(forKey: "id") as! String, taskname: taskField.text!, taskdescription: descriptionView.text, priority: priority)
        }
    }
    
    func showAlert(alerttitle : String, alertmsg : String)
    {
        let alertController = UIAlertController(title: alerttitle, message: alertmsg, preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Connection Delegate
    
    func GetFailureReponseMethod(errorreponse: String)
    {
        print("GetFailureReponseMethod")
    }
    
    func GetReponseMethod(reponse : NSDictionary)
    {
        print("reponse => \(reponse)")
        
        var priority = "0"
        if(!switchtype.isOn)
        {
            priority = "1"
        }
        
        taskDictionary.setValue(taskField.text!, forKey: "task")
        taskDictionary.setValue(descriptionView.text, forKey: "info")
        taskDictionary.setValue(priority, forKey: "priority")

        self.delegate?.refreshTaskDetails()
        
        self.closeaction()
    }
    
    // MARK: - UITextView Delegate
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool
    {
        if (text == "\n")
        {
            textView.resignFirstResponder()
            return false
        }
        
        return true
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
