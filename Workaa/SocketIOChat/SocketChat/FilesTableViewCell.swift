//
//  FilesTableViewCell.swift
//  Workaa
//
//  Created by IN1947 on 09/05/17.
//  Copyright © 2017 IN1947. All rights reserved.
//

import UIKit

class FilesTableViewCell: UITableViewCell
{
    @IBOutlet weak var fileiconimage: UIImageView!
    @IBOutlet weak var filetile: UILabel!
    @IBOutlet weak var fileusername: UILabel!
    @IBOutlet weak var filesize: UILabel!
    @IBOutlet weak var filetime: UILabel!
    @IBOutlet weak var fileusernamewidth: NSLayoutConstraint!
    @IBOutlet weak var starimage: UIImageView!

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
