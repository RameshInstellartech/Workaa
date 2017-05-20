//
//  UserTableViewCell.swift
//  Workaa
//
//  Created by IN1947 on 27/03/17.
//  Copyright © 2017 IN1947. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell
{
    @IBOutlet weak var profileimage: AsyncImageView!
    @IBOutlet weak var lblusername: UILabel!
    @IBOutlet weak var lblchatdesc: UILabel!
    @IBOutlet weak var countlbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
