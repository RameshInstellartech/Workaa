//
//  WelcomeViewController.swift
//  Workaa
//
//  Created by IN1947 on 02/03/17.
//  Copyright © 2017 IN1947. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController
{
    var commonmethodClass = CommonMethodClass()

    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if(!self.commonmethodClass.retrieveteamdomain().isEqual(to: ""))
        {
            let homedetailObj = self.storyboard?.instantiateViewController(withIdentifier: "HomeDetailViewID") as? HomeDetailViewController
            self.navigationController?.pushViewController(homedetailObj!, animated: false)
        }
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        self.title = ""

        self.navigationController?.navigationBar.isHidden = true
    }

    @IBAction func existingteam(sender : AnyObject)
    {
        let teamcheckingObj = self.storyboard?.instantiateViewController(withIdentifier: "TeamCheckingViewID") as? TeamCheckingViewController
        self.navigationController?.pushViewController(teamcheckingObj!, animated: true)
    }
    
    @IBAction func createteam(sender : AnyObject)
    {
        let createteamemailObj = self.storyboard?.instantiateViewController(withIdentifier: "CreateTeamEmailViewID") as? CreateTeamEmailViewController
        self.navigationController?.pushViewController(createteamemailObj!, animated: true)
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
