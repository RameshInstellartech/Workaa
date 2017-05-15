//
//  BaseCell.swift
//  Workaa
//
//  Created by IN1947 on 1/31/16.
//  Copyright © 2016 IN1947. All rights reserved.
//

import UIKit

class BaseCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        separatorInset = .zero
        preservesSuperviewLayoutMargins = false
        layoutMargins = .zero
        layoutIfNeeded()
        
        // Set the selection style to None.
        selectionStyle = UITableViewCellSelectionStyle.none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
