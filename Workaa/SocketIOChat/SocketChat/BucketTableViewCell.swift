//
//  BucketTableViewCell.swift
//  Workaa
//
//  Created by IN1947 on 28/02/17.
//  Copyright © 2017 IN1947. All rights reserved.
//

import UIKit

class BucketTableViewCell: UITableViewCell
{
    @IBOutlet weak var lbltaskdesc: UILabel!
    @IBOutlet weak var profileimage: AsyncImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
