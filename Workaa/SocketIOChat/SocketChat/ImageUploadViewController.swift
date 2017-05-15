//
//  ImageUploadViewController.swift
//  Workaa
//
//  Created by IN1947 on 13/01/17.
//  Copyright © 2017 IN1947. All rights reserved.
//

import UIKit

protocol ImageUploadDelegate: class
{
    func imageUploadtoServer(filename : String, comment : String)
    func fileUploadtoServer(filename : String, comment : String)
}

class ImageUploadViewController: UITableViewController
{
    var uploadimage : UIImage!
    var estimateheight : CGFloat!
    weak var delegate: ImageUploadDelegate?
    var titletxtfield : UITextField!
    var cmttxtView : UITextView!
    var filename : String!

    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if uploadimage != nil
        {
            self.title = "Upload Image"
        }
        else
        {
            self.title = "Upload File"
        }
        
        let doneButton : UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(ImageUploadViewController.doneAction))
        self.navigationItem.rightBarButtonItem = doneButton
        
        let cancelButton : UIBarButtonItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(ImageUploadViewController.cancelAction))
        self.navigationItem.leftBarButtonItem = cancelButton
        
        estimateheight = 100
    }
    
    // MARK: Action Methods
    
    func doneAction()
    {
        print("cmttxtView =>\(cmttxtView.text)")
        print("titletxtfield =>\(String(describing: titletxtfield.text))")
        
        var filname = String(format: "%@.jpg", titletxtfield.text!)
        if uploadimage == nil
        {
            filname = String(format: "%@", titletxtfield.text!)
        }
        if titletxtfield.text?.characters.count == 0
        {
            if uploadimage != nil
            {
                filname = "Image uploaded from iOS.jpg"
            }
            else
            {
                filname = String(format: "File uploaded from iOS.%@", (filename as NSString).pathExtension)
            }
        }
        
        print("filname =>\(filname)")

        self.dismiss(animated: true, completion: nil)
        if uploadimage != nil
        {
            delegate?.imageUploadtoServer(filename: filname, comment: cmttxtView.text)
        }
        else
        {
            delegate?.fileUploadtoServer(filename: filname, comment: cmttxtView.text)
        }
    }
    
    func cancelAction()
    {
        self.dismiss(animated: true, completion: nil)
    }

    // MARK: UITableView Delegate and Datasource Methods
    
    override func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if uploadimage != nil
        {
            return 3
        }
        else
        {
            return 2
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if uploadimage != nil
        {
            if(indexPath.row==0)
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: "imageCell", for: indexPath) as UITableViewCell
                
                let imageView = cell.contentView.viewWithTag(1) as? UIImageView
                imageView?.image = uploadimage
                
                return cell
            }
            else if(indexPath.row==1)
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: "titleCell", for: indexPath)
                titletxtfield = cell.contentView.viewWithTag(1) as? UITextField
                
                return cell
            }
            else
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath)
                
                cmttxtView = cell.contentView.viewWithTag(1) as? UITextView
                let placeholder = cell.contentView.viewWithTag(2) as? UILabel
                
                if (cmttxtView?.text.characters.count)!>0
                {
                    placeholder?.isHidden = true
                }
                
                return cell
            }
        }
        else
        {
            if(indexPath.row==0)
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: "titleCell", for: indexPath)
                titletxtfield = cell.contentView.viewWithTag(1) as? UITextField
                titletxtfield.text = filename

                return cell
            }
            else
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath)
                
                cmttxtView = cell.contentView.viewWithTag(1) as? UITextView
                let placeholder = cell.contentView.viewWithTag(2) as? UILabel
                
                if (cmttxtView?.text.characters.count)!>0
                {
                    placeholder?.isHidden = true
                }
                
                return cell
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if uploadimage != nil
        {
            if(indexPath.row==0)
            {
                return 200
            }
            else if(indexPath.row==1)
            {
                return 44
            }
            else
            {
                return estimateheight
            }
        }
        else
        {
            if(indexPath.row==0)
            {
                return 44
            }
            else
            {
                return estimateheight
            }
        }
    }
    
    // MARK: UITextViewDelegate Methods

    func textViewDidBeginEditing(_ textView: UITextView)
    {
        let view = textView.superview!
        let cell = view.superview as! UITableViewCell
        let placeholder = cell.contentView.viewWithTag(2) as? UILabel
        placeholder?.isHidden = true
    }
    
    func textViewDidEndEditing(_ textView: UITextView)
    {
        let view = textView.superview!
        let cell = view.superview as! UITableViewCell
        let placeholder = cell.contentView.viewWithTag(2) as? UILabel
        if (textView.text.characters.count)>0
        {
            placeholder?.isHidden = true
        }
        else
        {
            placeholder?.isHidden = false
        }
    }
    
    func textViewDidChange(_ textView: UITextView)
    {
        if textView.contentSize.height > 100
        {
            estimateheight = textView.contentSize.height
        }
        else
        {
            estimateheight = 100
        }
        
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
    }
    
    // MARK: didReceiveMemoryWarning

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
