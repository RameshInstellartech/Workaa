//
//  GroupUserTableViewCell.swift
//  Workaa
//
//  Created by IN1947 on 17/05/17.
//  Copyright © 2017 IN1947. All rights reserved.
//

import UIKit

class GroupUserTableViewCell: UITableViewCell
{
    @IBOutlet weak var profileimage: AsyncImageView!
    @IBOutlet weak var lblusername: UILabel!
    @IBOutlet weak var levelView: UIView!
    @IBOutlet weak var levelLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
