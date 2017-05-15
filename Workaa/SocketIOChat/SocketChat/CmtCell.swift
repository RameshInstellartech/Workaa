//
//  ChatCell.swift
//  Workaa
//
//  Created by IN1947 on 1/31/16.
//  Copyright © 2016 IN1947. All rights reserved.
//

import UIKit

class CmtCell: BaseCell
{
    @IBOutlet weak var lblChatMessage: KILabel!
    @IBOutlet weak var lblSenderDetails: UILabel!
    @IBOutlet weak var starimage = UIImageView()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
