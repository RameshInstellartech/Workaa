//
//  TeamListViewController.swift
//  Workaa
//
//  Created by IN1947 on 08/11/16.
//  Copyright © 2016 IN1947. All rights reserved.
//

import UIKit

class TeamListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ConnectionProtocol
{
    @IBOutlet weak var tblteamUserList: UITableView!
    
    var alertClass = AlertClass()
    var teamArray = NSArray()
    var connectionClass = ConnectionClass()
    var teamdictionary : NSDictionary!
    var commonmethodClass = CommonMethodClass()
    var validationClass = ValidationClass()

    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let createteamButton : UIBarButtonItem = UIBarButtonItem(title: "Create Team", style: UIBarButtonItemStyle.plain, target: self, action: #selector(TeamListViewController.CreateTeamAction))
        self.navigationItem.rightBarButtonItem = createteamButton
        
//        tblteamUserList.register(UITableViewCell.classForKeyedArchiver(), forCellReuseIdentifier: "idCellTeamUser")
        tblteamUserList.register(UINib(nibName: "TeamTableViewCell", bundle: nil), forCellReuseIdentifier: "TeamCell")
        
        self.getTeamList()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = false
        
        navigationController?.navigationBar.barTintColor = blueColor
        
        self.title = String(format: "Welcome, %@", commonmethodClass.retrieveusername())
    }
    
    func getTeamList()
    {
        connectionClass.delegate = self
        self.connectionClass.getTeamList()
    }
        
    func loadTeamInvite()
    {
        self.title = "Back"
        
        let teamInviteObj = self.storyboard?.instantiateViewController(withIdentifier: "TeamInviteViewID") as? TeamInviteViewController
        self.navigationController?.pushViewController(teamInviteObj!, animated: true)
    }
    
    func GetFailureReponseMethod(errorreponse: String)
    {
        print("GetFailureReponseMethod")
    }
    
    func GetReponseMethod(reponse : NSDictionary)
    {
        print("reponse => \(reponse)")
        
        if let getreponse = reponse.value(forKey: "data") as? NSDictionary
        {
            if let getteamlist = getreponse.value(forKey: "teamList") as? NSArray
            {
                teamArray = getteamlist
                tblteamUserList.reloadData()
            }
        }        
    }
        
    @IBAction func checkIn(sender: AnyObject)
    {
        print("checkIn")
    }
    
    @IBAction func taskList(sender: AnyObject)
    {
        let tasklistObj = self.storyboard?.instantiateViewController(withIdentifier: "TaskListViewID") as? TaskListViewController
        self.navigationController?.pushViewController(tasklistObj!, animated: true)
    }
    
    @IBAction func checkInStatus(sender: AnyObject)
    {
        print("checkInStatus")
    }
    
    func inviteaction()
    {
        print("inviteaction")
    }
    
    func CreateTeamAction()
    {
        self.title = "Back"
        
        let createteamObj = self.storyboard?.instantiateViewController(withIdentifier: "CreateTeamID") as? CreateTeamViewController
        self.navigationController?.pushViewController(createteamObj!, animated: true)
    }
    
    // MARK: UITableView Delegate and Datasource methods
    
    private func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return teamArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TeamCell", for: indexPath) as! TeamTableViewCell
        
        let teamdictionary = teamArray[indexPath.row] as! NSDictionary
        cell.lblteamname.text = teamdictionary["name"] as? String
        
        let filestring = String(format: "%@%@", kfilePath,(teamdictionary["teamLogo"] as? String)!)
        let fileUrl = NSURL(string: filestring)
        cell.profileimage.imageURL = fileUrl as URL?
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 80.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        
        print("commonmethodClass.teamid =>\(commonmethodClass.retrieveteamid())")
        
        SocketIOManager.sharedInstance.VerifySocket() { (messageInfo) -> Void in
            print("Send messageInfo =>\(messageInfo)")
        }
        
        self.connectionClass.delegate = nil
        self.connectionClass.SelectTeam()
        
        let homedetailObj = self.storyboard?.instantiateViewController(withIdentifier: "HomeDetailViewID") as? HomeDetailViewController
        self.navigationController?.pushViewController(homedetailObj!, animated: true)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]?
    {
        let inviteRowAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "Invite", handler:{action, indexpath in
                        
            print("commonmethodClass.teamid =>\(self.commonmethodClass.retrieveteamid())")
            
            self.connectionClass.delegate = nil
            self.connectionClass.SelectTeam()
            self.loadTeamInvite()
            
        });
        inviteRowAction.backgroundColor = UIColor.red
        
        return [inviteRowAction]
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
