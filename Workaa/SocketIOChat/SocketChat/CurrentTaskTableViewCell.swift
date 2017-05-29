//
//  CurrentTaskTableViewCell.swift
//  Workaa
//
//  Created by IN1947 on 23/03/17.
//  Copyright © 2017 IN1947. All rights reserved.
//

import UIKit

class CurrentTaskTableViewCell: UITableViewCell
{
    @IBOutlet weak var lbltasktitle: UILabel!
    @IBOutlet weak var lbltaskdesc: UITextView!
    @IBOutlet weak var lblusername: UILabel!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var lbldate: UILabel!
    @IBOutlet weak var textheight = NSLayoutConstraint()

    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
