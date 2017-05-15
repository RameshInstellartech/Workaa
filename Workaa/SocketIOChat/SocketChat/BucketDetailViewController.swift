//
//  BucketDetailViewController.swift
//  Workaa
//
//  Created by IN1947 on 16/03/17.
//  Copyright © 2017 IN1947. All rights reserved.
//

import UIKit

class BucketDetailViewController: UIViewController
{
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var tasktitlelbl: UILabel!
    @IBOutlet weak var tasktitleheight: NSLayoutConstraint!
    @IBOutlet weak var assignlbl: UILabel!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var datelbl: UILabel!
    @IBOutlet weak var taskdesc: UITextView!
    @IBOutlet weak var taskdescheight: NSLayoutConstraint!
    @IBOutlet weak var profileimage: AsyncImageView!
    @IBOutlet weak var groupNamelbl: UILabel!

    var myBucketDictionary = NSDictionary()
    var commonmethodClass = CommonMethodClass()
    var alertClass = AlertClass()
    var bottomView : BottomView!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        print("myBucketDictionary =>\(myBucketDictionary)")
        
        let filestring = String(format: "%@%@", kfilePath,(myBucketDictionary["groupLogo"] as? String)!)
        let fileUrl = NSURL(string: filestring)
        profileimage.imageURL = fileUrl as URL?
        
        groupNamelbl.text = String(format: "%@", myBucketDictionary.value(forKey: "groupName") as! CVarArg)
        
        tasktitlelbl.text = String(format: "%@", myBucketDictionary.value(forKey: "task") as! CVarArg)
        tasktitleheight.constant = commonmethodClass.dynamicHeight(width: screenWidth-40, font: tasktitlelbl.font, string: tasktitlelbl.text!)
        
        assignlbl.text = String(format: "by %@ %@", myBucketDictionary.value(forKey: "assignFirstName") as! CVarArg, myBucketDictionary.value(forKey: "assignLastName") as! CVarArg)
        
        let priority = String(format: "%@", myBucketDictionary.value(forKey: "priority") as! CVarArg)
        if priority == "1"
        {
            statusView.isHidden = false
        }
        else
        {
            statusView.isHidden = true
        }
        
        let time = String(format: "%@", myBucketDictionary.value(forKey: "time") as! CVarArg)
        datelbl.text = String(format: "%@", commonmethodClass.convertDateInCell(date: time))
        
        taskdesc.text = String(format: "%@", myBucketDictionary.value(forKey: "info") as! CVarArg)
        taskdescheight.constant = commonmethodClass.dynamicHeight(width: screenWidth-40, font: taskdesc.font!, string: taskdesc.text!)
        if(taskdescheight.constant<30.0)
        {
            taskdescheight.constant = 30.0
        }
        else
        {
            taskdescheight.constant = taskdescheight.constant + 20.0
        }
        
        self.loadbottomView()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = false
        
        navigationController?.navigationBar.barTintColor = blueColor
        
        self.title = String(format: "Welcome, %@", commonmethodClass.retrieveusername())
    }
    
    func loadbottomView()
    {
        bottomView = Bundle.main.loadNibNamed("BottomView", owner: nil, options: nil)?[0] as! BottomView
        bottomView.frame = CGRect(x: 0.0, y: screenHeight-124.0, width: screenWidth, height: 60.0)
        bottomView.loadbottomView(tag: 0)
        self.view.addSubview(bottomView)
    }
    
    func close()
    {
        navigation().popViewController(animated: true)
    }
    
    @IBAction func doneaction(sender : AnyObject)
    {
        let hour = String(format: "%@", myBucketDictionary.value(forKey: "hours") as! CVarArg)
        let taskid = String(format: "%@", myBucketDictionary.value(forKey: "id") as! CVarArg)
        if hour == "1"
        {
            self.alertClass.donetaskAlert(taskid: taskid)
        }
        else
        {
            self.alertClass.doneSaveAction(taskid: taskid, hours: "")
        }
    }
    
    @IBAction func notdoneaction(sender : AnyObject)
    {
        let taskid = String(format: "%@", myBucketDictionary.value(forKey: "id") as! CVarArg)
        self.alertClass.notdonetaskAlert(taskid: taskid)
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
