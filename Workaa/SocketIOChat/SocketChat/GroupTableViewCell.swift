//
//  GroupTableViewCell.swift
//  Workaa
//
//  Created by IN1947 on 28/02/17.
//  Copyright © 2017 IN1947. All rights reserved.
//

import UIKit

class GroupTableViewCell: UITableViewCell
{
    @IBOutlet weak var profileimage: AsyncImageView!
    @IBOutlet weak var lblgroupname: UILabel!
    @IBOutlet weak var lbltask: UILabel!
    @IBOutlet weak var lblstatus: UILabel!
    @IBOutlet weak var circleView: UIView!
    @IBOutlet weak var countlbl: UILabel!
    @IBOutlet weak var lblarrow: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
