//
//  ValidationClass.swift
//  Workaa
//
//  Created by IN1947 on 05/11/16.
//  Copyright © 2016 IN1947. All rights reserved.
//

import UIKit

class ValidationClass: NSObject
{
    func containsOnlyLetters(input: String) -> Bool
    {
        for chr in input.characters
        {
            if (!(chr >= "a" && chr <= "z") && !(chr >= "A" && chr <= "Z") )
            {
                return false
            }
        }
        return true
    }
    
    func containsAlphaNumeric(input: String) -> Bool
    {
        let characterset = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ0123456789_")
        if input.rangeOfCharacter(from: characterset.inverted) != nil
        {
            return false
        }
        return true
    }
    
    func isValidEmail(testStr:String) -> Bool
    {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
}
