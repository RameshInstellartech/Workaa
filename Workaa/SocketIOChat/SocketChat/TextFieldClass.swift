//
//  TextFieldClass.swift
//  Workaa
//
//  Created by IN1947 on 02/11/16.
//  Copyright © 2016 IN1947. All rights reserved.
//

import UIKit

class TextFieldClass: UITextField
{
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)!
        
//        self.layer.borderWidth = 1.0;
//        self.layer.borderColor = UIColor.lightGray.cgColor;
        self.layer.cornerRadius = self.frame.size.height/2.0;
        self.layer.masksToBounds = true;
        
        self.attributedPlaceholder = NSAttributedString(string: self.placeholder!, attributes: [NSForegroundColorAttributeName:UIColor.lightGray])
        
//        let paddingView = UIView()
//        paddingView.frame = CGRect(x : 0, y : 0, width : 20, height : 40)
//        self.leftView = paddingView;
//        self.leftViewMode = UITextFieldViewMode.always;
    }
    
    var count:Int
    {
        get
        {
            return self.text?.characters.count ?? 0
        }
    }
}
