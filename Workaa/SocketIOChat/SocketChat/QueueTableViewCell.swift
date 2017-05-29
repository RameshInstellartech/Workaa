//
//  QueueTableViewCell.swift
//  Workaa
//
//  Created by IN1947 on 27/02/17.
//  Copyright © 2017 IN1947. All rights reserved.
//

import UIKit

class QueueTableViewCell: UITableViewCell
{
    @IBOutlet weak var lbltaskdesc: UILabel!
    @IBOutlet weak var lblusername: UILabel!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var lbldate: UILabel!
    @IBOutlet weak var lblarrow: UILabel!
    @IBOutlet weak var arrowheight = NSLayoutConstraint()
    @IBOutlet weak var textheight = NSLayoutConstraint()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
