//
//  BottomView.swift
//  Workaa
//
//  Created by IN1947 on 15/04/17.
//  Copyright © 2017 IN1947. All rights reserved.
//

import UIKit

class BottomView: UIView
{
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    func loadbottomView(tag : NSInteger)
    {
        var array = NSArray()
        array = [homeIcon,taskIcon,"",messageIcon,cafeIcon]

        for view : UIView in self.subviews
        {
            for view1 : UIView in view.subviews
            {
                if(view1.tag>0)
                {
                    for view2 : UIView in view1.subviews
                    {
                        if(view2.frame.size.height==38.0)
                        {
                            if let lbl = view2 as? UILabel
                            {
                                lbl.text = String(format: "%@", array.object(at: view1.tag-1) as! CVarArg)
                                
                                if(tag==view1.tag)
                                {
                                    lbl.textColor = blueColor
                                }
                                else
                                {
                                    lbl.textColor = UIColor.black
                                }
                            }
                        }
                        if(view1.tag==3)
                        {
                            if let btn = view2 as? UIButton
                            {
                                btn.setTitle(plusIcon, for: .normal)
                            }
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func bottomAction(sender : AnyObject)
    {
        print("sender =>\(sender.tag)")
        
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        if sender.tag == 1
        {
            if self.next?.next is HomeDetailViewController
            {
                return
            }
            
            appDelegate.gotoWall()
        }
        else if sender.tag == 2
        {
            if self.next?.next is TaskListViewController
            {
                return
            }
            
            appDelegate.gotoTaskList()
        }
        else if sender.tag == 3
        {
            let createtask = storyboard.instantiateViewController(withIdentifier: "CreateTaskID") as? CreateTaskViewController
            navigation().pushViewController(createtask!, animated: true)
        }
        else if sender.tag == 4
        {
            if self.next?.next is MessageViewController
            {
                return
            }
            
            appDelegate.gotoMessenger()
        }
        else if sender.tag == 5
        {
            if self.next?.next is CafeViewController
            {
                return
            }
            
            var isView : Bool!
            isView = false
            
            var viewcontroller = UIViewController()
            
            for aviewcontroller : UIViewController in navigation().viewControllers
            {
                if aviewcontroller is CafeViewController
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
                let cafeViewObj = storyboard.instantiateViewController(withIdentifier: "CafeViewID") as? CafeViewController
                navigation().pushViewController(cafeViewObj!, animated: false)
            }
        }
    }
}
