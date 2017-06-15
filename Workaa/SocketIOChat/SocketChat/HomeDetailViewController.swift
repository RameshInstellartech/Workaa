//
//  HomeDetailViewController.swift
//  Workaa
//
//  Created by IN1947 on 23/02/17.
//  Copyright © 2017 IN1947. All rights reserved.
//

import UIKit

class HomeDetailViewController: UIViewController, CardsSwipingViewDelegate, callingdetailpageDelegate, ConnectionProtocol
{
    @IBOutlet weak var cardsSwipingView = CardsSwipingView()
    @IBOutlet weak var titlelbl: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var tasklistView: UIView!
    @IBOutlet weak var tasklistheight: NSLayoutConstraint!
    @IBOutlet weak var cardheight: NSLayoutConstraint!
    @IBOutlet weak var menubtn: UIButton!
    @IBOutlet weak var notifibtn: UIButton!

    var commonmethodClass = CommonMethodClass()
    var taskarray = NSArray()
    var queueArray = NSArray()
    var connectionClass = ConnectionClass()
    var checkInView = CheckInView()
    var bottomView : BottomView!
    var cardcount = NSInteger()
    var startcount = NSInteger()
    var refreshControl = UIRefreshControl()

    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        connectionClass.delegate = self
        cardsSwipingView?.delegate = self;
        
        menubtn.setTitle(menuIcon, for: .normal)
        notifibtn.setTitle(notifiIcon, for: .normal)

        let revealViewController: SWRevealViewController? = self.revealViewController()
        if revealViewController != nil
        {
            menubtn.addTarget(revealViewController, action: #selector(revealViewController?.revealToggle(_:)), for: .touchUpInside)
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        tasklistView.isHidden = true
        
        if(checkInReponse.count>0)
        {
            self.loadCheckInView()
        }
        
        self.loadbottomView()
        
        self.setRefreshControl()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = true
        
        titlelbl.text = String(format: "Welcome, %@", commonmethodClass.retrieveusername())
        
        self.cardsSwipingView?.clearQueue()
        
        self.cardheight.constant = 290.0
        
        commonmethodClass.delayWithSeconds(0.0, completion: {
            self.getQueueList()
            self.getMyBucketList()
        })
    }
    
    func setRefreshControl()
    {
        let attributes = [ NSForegroundColorAttributeName : UIColor.white ] as [String: Any]
        refreshControl.tintColor = UIColor.white
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to Refresh...", attributes: attributes)
        refreshControl.addTarget(self, action: #selector(HomeDetailViewController.refreshData(sender:)), for: .valueChanged)
        self.scrollView.addSubview(refreshControl)
    }
    
    func refreshData(sender: UIRefreshControl)
    {
        commonmethodClass.delayWithSeconds(1.0, completion: {
            self.cardsSwipingView?.clearQueue()
            self.cardheight.constant = 290.0
            self.getQueueList()
            self.getMyBucketList()
            self.refreshControl.endRefreshing()
        })
    }
    
    func loadbottomView()
    {
        bottomView = Bundle.main.loadNibNamed("BottomView", owner: nil, options: nil)?[0] as! BottomView
        bottomView.frame = CGRect(x: 0.0, y: screenHeight-60.0, width: screenWidth, height: 60.0)
        bottomView.loadbottomView(tag: 1)
        self.view.addSubview(bottomView)
    }
    
    func getMyBucketList()
    {
        self.connectionClass.getMyBucketList()
    }
    
    func getQueueList()
    {
        self.connectionClass.getQueueList()
    }
    
    func loadCheckInView()
    {
        if commonmethodClass.AlreadyExist(Key: "CheckInSavedDate")
        {
            let savedDate = UserDefaults.standard.value(forKey: "CheckInSavedDate") as! Date
            let unitFlags = Set<Calendar.Component>([.day])
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let startTime = dateFormatter.date(from: commonmethodClass.dateConvertString(date: savedDate))
            let endTime = dateFormatter.date(from: commonmethodClass.dateConvertString(date: Date()))
            let timeDifference = Calendar.current.dateComponents(unitFlags, from: startTime!, to: endTime!)
            
            if (timeDifference.day)! >= 1
            {
                if(appDelegate.checkInString != "1" && appDelegate.checkInString != "3")
                {
                    for v: UIView in checkInView.subviews {
                        v.removeFromSuperview()
                    }
                    checkInView.removeFromSuperview()
                    
                    checkInView = Bundle.main.loadNibNamed("CheckInView", owner: nil, options: nil)?[0] as! CheckInView
                    checkInView.frame = CGRect(x: 0.0, y: 0.0, width: screenWidth, height: screenHeight-60.0)
                    checkInView.loadCheckInView()
                    self.view.addSubview(checkInView)
                    
                    //self.commonmethodClass.ovalAnimation(self.checkInView, center: CGPoint(x: CGFloat(screenWidth / 2.0), y: CGFloat(self.checkInView.frame.size.height / 2.0)), colorFrom: UIColor(white: 1.0, alpha: 0.8), colorTo: UIColor(white: 1.0, alpha: 0.8), withradius: 120.0)
                }
            }
        }
        else
        {
            if(appDelegate.checkInString != "1" && appDelegate.checkInString != "3")
            {
                for v: UIView in checkInView.subviews {
                    v.removeFromSuperview()
                }
                checkInView.removeFromSuperview()
                
                checkInView = Bundle.main.loadNibNamed("CheckInView", owner: nil, options: nil)?[0] as! CheckInView
                checkInView.frame = CGRect(x: 0.0, y: 0.0, width: screenWidth, height: screenHeight-60.0)
                checkInView.loadCheckInView()
                self.view.addSubview(checkInView)
                
//                self.commonmethodClass.ovalAnimation(self.checkInView, center: CGPoint(x: CGFloat(screenWidth / 2.0), y: CGFloat(self.checkInView.frame.size.height / 2.0)), colorFrom: UIColor(white: 1.0, alpha: 0.8), colorTo: UIColor(white: 1.0, alpha: 0.8), withradius: 120.0)
            }
        }
    }
    
    func loadScrollView()
    {
        for view in tasklistView.subviews
        {
            if let lbl = view as? UILabel
            {
                print("lbl =>\(lbl)")
            }
            else
            {
                if view.frame.size.height != 1.0
                {
                    view.removeFromSuperview()
                }
            }
        }
        
        if(taskarray.count==0)
        {
            tasklistView.isHidden = true
        }
        else
        {
            tasklistView.isHidden = false
        }
        
        tasklistView.layer.cornerRadius = 20.0
        tasklistView.layer.masksToBounds = true
                
        var Ypos : CGFloat!
        Ypos = 40.0
        for i in 0 ..< taskarray.count
        {
            let bucketdictionary = taskarray[i] as! NSDictionary
            let taskname = String(format: "%@", bucketdictionary.value(forKey: "task") as! CVarArg)
            
            var txtheight = commonmethodClass.dynamicHeight(width: screenWidth-120, font: UIFont (name: LatoRegular, size: 14)!, string: taskname as String)
            txtheight = ceil(txtheight)
            txtheight = txtheight + 25.0

            let subtaskView = UIView()
            subtaskView.frame = CGRect(x: CGFloat(0.0), y: Ypos, width: screenWidth-20.0, height: CGFloat(txtheight))
            subtaskView.backgroundColor = UIColor.clear
            tasklistView.addSubview(subtaskView)
            
            let circleView = UIView()
            circleView.frame = CGRect(x: CGFloat(15.0), y: CGFloat((subtaskView.frame.size.height-10.0)/2.0), width: CGFloat(10.0), height: CGFloat(10.0))
            circleView.backgroundColor = getRandomColor()
            circleView.layer.cornerRadius = 5.0
            circleView.layer.masksToBounds = true
            subtaskView.addSubview(circleView)
            
            let tasklbl = UILabel(frame: CGRect(x: CGFloat(40.0), y: CGFloat(10.0), width: CGFloat(subtaskView.frame.size.width-90.0), height: subtaskView.frame.size.height-20.0))
            tasklbl.font = UIFont(name: LatoRegular, size: CGFloat(14))
            tasklbl.text = taskname
            tasklbl.backgroundColor = UIColor.clear
            tasklbl.textColor = UIColor.darkGray
            tasklbl.numberOfLines = 100000
//            tasklbl.textAlignment = .justified
            subtaskView.addSubview(tasklbl)
            
            let arrowlbl = UILabel(frame: CGRect(x: CGFloat(tasklbl.frame.maxX), y: CGFloat(0.0), width: CGFloat(20.0), height: subtaskView.frame.size.height))
            arrowlbl.font = UIFont(name: Workaa_Font, size: CGFloat(20))
            arrowlbl.text = solidrightarrowIcon
            arrowlbl.backgroundColor = UIColor.clear
            arrowlbl.textColor = UIColor.lightGray
            arrowlbl.textAlignment = .right
            subtaskView.addSubview(arrowlbl)
            
            if i != taskarray.count - 1
            {
                let lineView = UIView()
                lineView.frame = CGRect(x: CGFloat(tasklbl.frame.origin.x), y: subtaskView.frame.size.height-0.5, width: subtaskView.frame.size.width-70.0, height: CGFloat(0.5))
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
        
        if queueArray.count == 0
        {
            self.cardheight.constant = 0.0
        }
        else
        {
            self.cardheight.constant = 290.0
        }
        
        commonmethodClass.delayWithSeconds(0.1, completion: {
            self.scrollView.contentSize = CGSize(width: screenWidth, height: self.tasklistheight.constant+self.cardheight.constant+70.0)
        })
    }
    
    func buttonaction(sender: UIButton!)
    {
        print("sender =>\(sender.tag)")
        
        self.title = ""
        
        let bucketdetailObj = self.storyboard?.instantiateViewController(withIdentifier: "BucketDetailViewID") as? BucketDetailViewController
        bucketdetailObj?.myBucketDictionary = taskarray[sender.tag] as! NSDictionary
        self.navigationController?.pushViewController(bucketdetailObj!, animated: true)
    }
    
    func callDetailPage(_ dictionary: [AnyHashable : Any]!)
    {
        let taskdetailObj = self.storyboard?.instantiateViewController(withIdentifier: "TaskDetailViewID") as? TaskDetailViewController
        taskdetailObj?.taskDictionary = NSMutableDictionary(dictionary: dictionary)
        self.present(taskdetailObj!, animated: true, completion: nil)
    }
    
    func addCard()
    {
        self.cardsSwipingView?.clearQueue()
        self.cardsSwipingView?.isHidden = false
        
        var Ypos = CGFloat()
        var widthspace = CGFloat()
        Ypos = 30.0
        widthspace = 20.0
        for i in startcount ..< cardcount
        {
            let bucketdictionary = queueArray[i] as! NSDictionary as? [AnyHashable: Any] ?? [:]
            
            let card = CardView(frame: CGRect(x: CGFloat(0), y: CGFloat(Ypos), width: CGFloat(screenWidth - widthspace), height: cardheight.constant))
            card.delegate = self
            card.queueDictionary = bucketdictionary
            card.filepath = kfilePath
            self.cardsSwipingView?.enqueueCard(card)
                            
            Ypos = Ypos - 10.0
            widthspace = widthspace + 10.0
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
        
        if let getreponse = reponse.value(forKey: "data") as? NSDictionary
        {
            if let getqueuelist = getreponse.value(forKey: "queueList") as? NSArray
            {
                queueArray = getqueuelist
                if(queueArray.count>0)
                {
                    startcount = 0
                    
                    if(queueArray.count>3)
                    {
                        cardcount = 3
                    }
                    else
                    {
                        cardcount = queueArray.count
                    }
                    
                    self.addCard()
                }
            }
            if let getmybucketlist = getreponse.value(forKey: "taskList") as? NSArray
            {
                taskarray = getmybucketlist
                self.loadScrollView()
            }
        }
    }

    // MARK: didReceiveMemoryWarning

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - CardsSwipingViewDelegate

    func cardsSwipingView(_ cardsSwipingView: CardsSwipingView, willDismissCard card: UIView, toLeft: Bool) -> Bool
    {
        cardcount += 1
        startcount += 1
        if(cardcount<=queueArray.count)
        {
            commonmethodClass.delayWithSeconds(0.3, completion: {
                self.addCard()
            })
        }
        else
        {
            if(startcount==queueArray.count)
            {
                commonmethodClass.delayWithSeconds(0.5, completion: {
                    self.cardsSwipingView?.isHidden = true
                })
            }
        }
        return true
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
