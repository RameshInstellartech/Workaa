//
//  ImageUploadProgressView.swift
//  Workaa
//
//  Created by IN1947 on 16/01/17.
//  Copyright © 2017 IN1947. All rights reserved.
//

import UIKit

class ImageUploadProgressView: UIView
{
    var progressView : UIProgressView!
    @IBOutlet var imageView : UIImageView!
    @IBOutlet var uploadLbl : UILabel!
    @IBOutlet var doneLbl : UILabel!
    @IBOutlet var cancelbtn : UIButton!

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    func loadProgressView()
    {
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.progressTintColor = blueColor
        progressView.layer.cornerRadius = 5.0
        progressView.layer.masksToBounds = true
        progressView.clipsToBounds = true
        progressView.layer.frame = CGRect(x: CGFloat(60), y: CGFloat(45), width: CGFloat(screenWidth-70), height: CGFloat(10))
        progressView.trackTintColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
        progressView.setProgress(0.0, animated: false)
        self.addSubview(progressView)
        
        imageView.layer.cornerRadius = 5.0
        imageView.layer.masksToBounds = true
    }
        
    func setImage(image : UIImage)
    {
        imageView.image = image
    }
    
    func setProgress(progress : Float)
    {
        progressView.setProgress(progress, animated: false)
    }
    
    func showProgressView()
    {
        self.animateView(self, withAnimationType: kCATransitionFromBottom)
        
        uploadLbl.text = "Uploading your file..."
        
        progressView.setProgress(0.0, animated: false)
        uploadLbl.isHidden = false
        cancelbtn.isHidden = false
        doneLbl.isHidden = true
    }
    
    func uploadCompleted()
    {
        uploadLbl.isHidden = true
        cancelbtn.isHidden = true
        doneLbl.isHidden = false
    }
    
    func animateView(_ animateView: UIView, withAnimationType animType: String)
    {
        let animation = CATransition()
        animation.type = kCATransitionPush
        animation.subtype = animType
        animation.duration = 0.5
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        animateView.layer.add(animation, forKey: kCATransition)
        animateView.isHidden = !animateView.isHidden
    }
    
    @IBAction func cancel(sender: UIButton)
    {
        uploadLbl.text = "Cancelled"
        
        if self.next?.next is GroupViewController
        {
            (self.next?.next as? GroupViewController)?.cancelrequest()
        }
        if self.next?.next is OneToOneChatViewController
        {
            (self.next?.next as? OneToOneChatViewController)?.cancelrequest()
        }
        if self.next?.next is CafeViewController
        {
            (self.next?.next as? CafeViewController)?.cancelrequest()
        }
    }
}
