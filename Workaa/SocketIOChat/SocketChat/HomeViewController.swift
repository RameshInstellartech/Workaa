//
//  HomeViewController.swift
//  Workaa
//
//  Created by IN1947 on 18/02/17.
//  Copyright © 2017 IN1947. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController
{
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var tasklistView: UIView!
    @IBOutlet weak var tasklistheight: NSLayoutConstraint!
    @IBOutlet weak var todaybrithView: UIView!
    @IBOutlet weak var todaybrithheight: NSLayoutConstraint!
    @IBOutlet weak var titlelbl: UILabel!

    var commonmethodClass = CommonMethodClass()
    var taskarray : NSArray!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.loadScrollView()
    }

    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = true
        
        titlelbl.text = String(format: "Welcome, %@", commonmethodClass.retrieveusername())
    }
    
    func loadScrollView()
    {
        tasklistView.layer.cornerRadius = 20.0
        tasklistView.layer.masksToBounds = true
        todaybrithView.layer.cornerRadius = 20.0
        todaybrithView.layer.masksToBounds = true
        
        taskarray = ["Emailer requirement for shanthi requirement for vijay shanthi requirement for vijay shanthi","Emailer requirement for shanthi requirement for vijay shanthi requirement for vijay shanthi","Emailer requirement for shanthi requirement for vijay shanthi requirement for vijay shanthi"] 
        
        var Ypos : CGFloat!
        Ypos = 40.0
        for i in 0 ..< taskarray.count
        {
            print("i =>\(taskarray[i])")
            
            let subtaskView = UIView()
            subtaskView.frame = CGRect(x: CGFloat(0.0), y: Ypos, width: screenWidth-30.0, height: CGFloat(80.0))
            subtaskView.backgroundColor = UIColor.clear
            tasklistView.addSubview(subtaskView)
            
            let circleView = UIView()
            circleView.frame = CGRect(x: CGFloat(15.0), y: CGFloat((subtaskView.frame.size.height-10.0)/2.0), width: CGFloat(10.0), height: CGFloat(10.0))
            circleView.backgroundColor = UIColor.green
            circleView.layer.cornerRadius = 5.0
            circleView.layer.masksToBounds = true
            subtaskView.addSubview(circleView)
            
            let tasklbl = UILabel(frame: CGRect(x: CGFloat(40.0), y: CGFloat(0.0), width: CGFloat(subtaskView.frame.size.width-70.0), height: subtaskView.frame.size.height-0.5))
            tasklbl.font = UIFont(name: LatoRegular, size: CGFloat(15))
            tasklbl.text = taskarray[i] as? String
            tasklbl.backgroundColor = UIColor.clear
            tasklbl.textColor = UIColor.darkGray
            tasklbl.numberOfLines = 100000
            tasklbl.textAlignment = .justified
            subtaskView.addSubview(tasklbl)
            
            if i != taskarray.count - 1
            {
                let lineView = UIView()
                lineView.frame = CGRect(x: CGFloat(tasklbl.frame.origin.x), y: subtaskView.frame.size.height-0.5, width: tasklbl.frame.size.width, height: CGFloat(0.5))
                lineView.backgroundColor = UIColor(red: CGFloat(230.0/255.0), green: CGFloat(230.0/255.0), blue: CGFloat(230.0/255.0), alpha: CGFloat(1.0))
                subtaskView.addSubview(lineView)
            }
            
            let button = UIButton()
            button.addTarget(self, action: #selector(self.buttonaction(sender:)), for: .touchUpInside)
            button.frame = CGRect(x: CGFloat(0.0), y: CGFloat(0.0), width: CGFloat(subtaskView.frame.size.width), height: CGFloat(subtaskView.frame.size.height))
            button.tag = i
            button.backgroundColor = UIColor.clear
            subtaskView.addSubview(button)
            
            Ypos = Ypos + subtaskView.frame.size.height
        }
        
        tasklistheight.constant = Ypos + 20.0
        
        /*--------------------------------------------------------------*/
        
        Ypos = 40.0
        for i in 0 ..< 2
        {
            let subtodaybrithView = UIView()
            subtodaybrithView.frame = CGRect(x: CGFloat(0.0), y: Ypos, width: screenWidth-30.0, height: CGFloat(50.0))
            subtodaybrithView.backgroundColor = UIColor.clear
            todaybrithView.addSubview(subtodaybrithView)
            
            let profileImagView = UIImageView()
            profileImagView.frame = CGRect(x: CGFloat(25.0), y: CGFloat((subtodaybrithView.frame.size.height-30.0)/2.0), width: CGFloat(30.0), height: CGFloat(30.0))
            profileImagView.backgroundColor = redColor
            profileImagView.layer.cornerRadius = profileImagView.frame.size.width/2.0
            profileImagView.layer.masksToBounds = true
            subtodaybrithView.addSubview(profileImagView)
            
            let chaticon = UILabel()
            chaticon.frame = CGRect(x: CGFloat(subtodaybrithView.frame.size.width-60), y: CGFloat((subtodaybrithView.frame.size.height-30.0)/2.0), width: CGFloat(30.0), height: CGFloat(30.0))
            chaticon.backgroundColor = UIColor.green
            chaticon.layer.cornerRadius = chaticon.frame.size.width/2.0
            chaticon.layer.masksToBounds = true
            subtodaybrithView.addSubview(chaticon)
            
            let namelbl = UILabel(frame: CGRect(x: CGFloat(profileImagView.frame.maxX+10.0), y: CGFloat(0.0), width: CGFloat(chaticon.frame.origin.x-profileImagView.frame.maxX-15.0), height: subtodaybrithView.frame.size.height-0.5))
            namelbl.font = UIFont(name: LatoRegular, size: CGFloat(15))
            namelbl.text = "Smith"
            namelbl.backgroundColor = UIColor.clear
            namelbl.textColor = UIColor.black
            subtodaybrithView.addSubview(namelbl)
            
            if i != 1
            {
                let lineView = UIView()
                lineView.frame = CGRect(x: CGFloat(40.0), y: subtodaybrithView.frame.size.height-0.5, width: CGFloat(subtodaybrithView.frame.size.width-70.0), height: CGFloat(0.5))
                lineView.backgroundColor = UIColor(red: CGFloat(230.0/255.0), green: CGFloat(230.0/255.0), blue: CGFloat(230.0/255.0), alpha: CGFloat(1.0))
                subtodaybrithView.addSubview(lineView)
            }
            
            Ypos = Ypos + subtodaybrithView.frame.size.height
        }
        
        todaybrithheight.constant = Ypos + 20.0
        
        commonmethodClass.delayWithSeconds(0.1, completion: {
            self.scrollView.contentSize = CGSize(width: screenWidth, height: self.tasklistheight.constant+self.todaybrithheight.constant+120.0)
        })
    }
    
    func buttonaction(sender: UIButton!)
    {
        print("sender =>\(sender.tag)")
        
//        let homedetailObj = self.storyboard?.instantiateViewController(withIdentifier: "HomeDetailViewID") as? HomeDetailViewController
//        self.navigationController?.pushViewController(homedetailObj!, animated: true)
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
