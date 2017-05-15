//
//  ProfileInfoTableViewCell.swift
//  Workaa
//
//  Created by IN1947 on 25/03/17.
//  Copyright © 2017 IN1947. All rights reserved.
//

import UIKit

class ProfileInfoTableViewCell: UITableViewCell
{
    @IBOutlet weak var titlelbl: UILabel!
    @IBOutlet weak var txtfield: UITextField!
    @IBOutlet weak var textfield: PlaceholderTextView!

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
