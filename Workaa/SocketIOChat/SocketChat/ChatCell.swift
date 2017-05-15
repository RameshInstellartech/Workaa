//
//  ChatCell.swift
//  Workaa
//
//  Created by IN1947 on 1/31/16.
//  Copyright © 2016 IN1947. All rights reserved.
//

import UIKit

class ChatCell: BaseCell
{
    // right side text chat cell
    @IBOutlet weak var righttextView = UIView()
    @IBOutlet weak var righttextMessageView = UIView()
    @IBOutlet weak var righttextwidth = NSLayoutConstraint()
    @IBOutlet weak var righttextMessagelbl = KILabel()
    @IBOutlet weak var righttextDatelbl = UILabel()
    @IBOutlet weak var righttextstarimage = UIImageView()

    // left side text chat cell
    @IBOutlet weak var lefttextView = UIView()
    @IBOutlet weak var lefttextMessageView = UIView()
    @IBOutlet weak var lefttextwidth = NSLayoutConstraint()
    @IBOutlet weak var lefttextMessagelbl = KILabel()
    @IBOutlet weak var lefttextDatelbl = UILabel()
    @IBOutlet weak var lefttextUserNamelbl = UILabel()
    @IBOutlet weak var lefttextUserTagNamelbl = UILabel()
    @IBOutlet weak var lefttextUserNamewidth = NSLayoutConstraint()
    @IBOutlet weak var lefttextUserTagNamewidth = NSLayoutConstraint()
    @IBOutlet weak var lefttextstarimage = UIImageView()

    // right side image chat cell
    @IBOutlet weak var rightimageView = UIView()
    @IBOutlet weak var rightchatimage = AsyncImageView()
    @IBOutlet weak var rightimageDatelbl = UILabel()
    @IBOutlet weak var rightimagestarimage = UIImageView()

    // left side image chat cell
    @IBOutlet weak var leftimageView = UIView()
    @IBOutlet weak var leftsubimageView = UIView()
    @IBOutlet weak var leftchatimage = AsyncImageView()
    @IBOutlet weak var leftimageDatelbl = UILabel()
    @IBOutlet weak var leftimageMessagelbl = KILabel()
    @IBOutlet weak var leftimageMessageheight = NSLayoutConstraint()
    @IBOutlet weak var leftimageUserNamelbl = UILabel()
    @IBOutlet weak var leftimageUserTagNamelbl = UILabel()
    @IBOutlet weak var leftimageUserNamewidth = NSLayoutConstraint()
    @IBOutlet weak var leftimageUserTagNamewidth = NSLayoutConstraint()
    @IBOutlet weak var leftimagestarimage = UIImageView()

    // right comment text chat cell
    @IBOutlet weak var rightcommentView = UIView()
    @IBOutlet weak var rightsubcommentView = UIView()
    @IBOutlet weak var rightcommentDatelbl = UILabel()
    @IBOutlet weak var rightcommentDetailslbl = UILabel()
    @IBOutlet weak var rightcommentDetailsheight = NSLayoutConstraint()
    @IBOutlet weak var rightcommentMsglbl = KILabel()
    @IBOutlet weak var rightcommentstarimage = UIImageView()

    // left comment text chat cell
    @IBOutlet weak var leftcommentView = UIView()
    @IBOutlet weak var leftsubcommentView = UIView()
    @IBOutlet weak var leftcommentDatelbl = UILabel()
    @IBOutlet weak var leftcommentUserNamelbl = UILabel()
    @IBOutlet weak var leftcommentUserTagNamelbl = UILabel()
    @IBOutlet weak var leftcommentUserNamewidth = NSLayoutConstraint()
    @IBOutlet weak var leftcommentUserTagNamewidth = NSLayoutConstraint()
    @IBOutlet weak var leftcommentDetailslbl = UILabel()
    @IBOutlet weak var leftcommentMsglbl = KILabel()
    @IBOutlet weak var leftcommentstarimage = UIImageView()

    // right file chat cell
    @IBOutlet weak var rightfileView = UIView()
    @IBOutlet weak var rightsubfileView = UIView()
    @IBOutlet weak var rightfileDatelbl = UILabel()
    @IBOutlet weak var rightfiletypebtn = UIButton()
    @IBOutlet weak var rightfiletitlelbl = UILabel()
    @IBOutlet weak var rightfilesizelbl = UILabel()
    @IBOutlet weak var rightfilestarimage = UIImageView()

    // left file chat cell
    @IBOutlet weak var leftfileView = UIView()
    @IBOutlet weak var leftsubfileView = UIView()
    @IBOutlet weak var leftfileDatelbl = UILabel()
    @IBOutlet weak var leftfileUserNamelbl = UILabel()
    @IBOutlet weak var leftfileUserTagNamelbl = UILabel()
    @IBOutlet weak var leftfileUserNamewidth = NSLayoutConstraint()
    @IBOutlet weak var leftfileUserTagNamewidth = NSLayoutConstraint()
    @IBOutlet weak var leftfiletypebtn = UIButton()
    @IBOutlet weak var leftfiletitlelbl = UILabel()
    @IBOutlet weak var leftfilesizelbl = UILabel()
    @IBOutlet weak var leftfilestarimage = UIImageView()

    // right share text chat cell
    @IBOutlet weak var rightsharetextView = UIView()
    @IBOutlet weak var rightsubsharetextView = UIView()
    @IBOutlet weak var rightsharetextDatelbl = UILabel()
    @IBOutlet weak var rightsharetextlbl = KILabel()
    @IBOutlet weak var rightsharetextnamelbl = KILabel()
    @IBOutlet weak var rightsharetextmessagelbl = KILabel()
    @IBOutlet weak var rightsharetextheight = NSLayoutConstraint()
    @IBOutlet weak var rightsharetextstarimage = UIImageView()

    // left share text chat cell
    @IBOutlet weak var leftsharetextView = UIView()
    @IBOutlet weak var leftsubsharetextView = UIView()
    @IBOutlet weak var leftsharetextDatelbl = UILabel()
    @IBOutlet weak var leftsharetextUserNamelbl = UILabel()
    @IBOutlet weak var leftsharetextUserTagNamelbl = UILabel()
    @IBOutlet weak var leftsharetextUserNamewidth = NSLayoutConstraint()
    @IBOutlet weak var leftsharetextUserTagNamewidth = NSLayoutConstraint()
    @IBOutlet weak var leftsharetextlbl = KILabel()
    @IBOutlet weak var leftsharetextnamelbl = KILabel()
    @IBOutlet weak var leftsharetextmessagelbl = KILabel()
    @IBOutlet weak var leftsharetextheight = NSLayoutConstraint()
    @IBOutlet weak var leftsharetextstarimage = UIImageView()

    // right share image chat cell
    @IBOutlet weak var rightshareimageView = UIView()
    @IBOutlet weak var rightsubshareimageView = UIView()
    @IBOutlet weak var rightshareimageDatelbl = UILabel()
    @IBOutlet weak var rightshareimagedetailslbl = UILabel()
    @IBOutlet weak var rightshareimagetextlbl = KILabel()
    @IBOutlet weak var rightshareimagetextheight = NSLayoutConstraint()
    @IBOutlet weak var rightshareimage = AsyncImageView()
    @IBOutlet weak var rightshareimagestarimage = UIImageView()

    // left share image chat cell
    @IBOutlet weak var leftshareimageView = UIView()
    @IBOutlet weak var leftsubshareimageView = UIView()
    @IBOutlet weak var leftshareimageDatelbl = UILabel()
    @IBOutlet weak var leftshareimageUserNamelbl = UILabel()
    @IBOutlet weak var leftshareimageUserTagNamelbl = UILabel()
    @IBOutlet weak var leftshareimageUserNamewidth = NSLayoutConstraint()
    @IBOutlet weak var leftshareimageUserTagNamewidth = NSLayoutConstraint()
    @IBOutlet weak var leftshareimagedetailslbl = UILabel()
    @IBOutlet weak var leftshareimagetextlbl = KILabel()
    @IBOutlet weak var leftshareimagetextheight = NSLayoutConstraint()
    @IBOutlet weak var leftshareimage = AsyncImageView()
    @IBOutlet weak var leftshareimagestarimage = UIImageView()

    // right share file chat cell
    @IBOutlet weak var rightsharefileView = UIView()
    @IBOutlet weak var rightsubsharefileView = UIView()
    @IBOutlet weak var rightsharefileDatelbl = UILabel()
    @IBOutlet weak var rightsharefiledetailslbl = UILabel()
    @IBOutlet weak var rightsharefiletypebtn = UIButton()
    @IBOutlet weak var rightsharefiletitlelbl = UILabel()
    @IBOutlet weak var rightsharefilesizelbl = UILabel()
    @IBOutlet weak var rightsharefiletextlbl = KILabel()
    @IBOutlet weak var rightsharefilestarimage = UIImageView()

    // left share file chat cell
    @IBOutlet weak var leftsharefileView = UIView()
    @IBOutlet weak var leftsubsharefileView = UIView()
    @IBOutlet weak var leftsharefileDatelbl = UILabel()
    @IBOutlet weak var leftsharefileUserNamelbl = UILabel()
    @IBOutlet weak var leftsharefileUserTagNamelbl = UILabel()
    @IBOutlet weak var leftsharefileUserNamewidth = NSLayoutConstraint()
    @IBOutlet weak var leftsharefileUserTagNamewidth = NSLayoutConstraint()
    @IBOutlet weak var leftsharefiledetailslbl = UILabel()
    @IBOutlet weak var leftsharefiletypebtn = UIButton()
    @IBOutlet weak var leftsharefiletitlelbl = UILabel()
    @IBOutlet weak var leftsharefilesizelbl = UILabel()
    @IBOutlet weak var leftsharefiletextlbl = KILabel()
    @IBOutlet weak var leftsharefilestarimage = UIImageView()

    // right share comment chat cell
    @IBOutlet weak var rightsharecommentView = UIView()
    @IBOutlet weak var rightsubsharecommentView = UIView()
    @IBOutlet weak var rightsharecommentDatelbl = UILabel()
    @IBOutlet weak var rightsharecommenttextlbl = KILabel()
    @IBOutlet weak var rightsharecommenttextheight = NSLayoutConstraint()
    @IBOutlet weak var rightsharecommentnamelbl = UILabel()
    @IBOutlet weak var rightsharecommentdetailslbl = UILabel()
    @IBOutlet weak var rightsharecommentstarimage = UIImageView()

    // left share comment chat cell
    @IBOutlet weak var leftsharecommentView = UIView()
    @IBOutlet weak var leftsubsharecommentView = UIView()
    @IBOutlet weak var leftsharecommentDatelbl = UILabel()
    @IBOutlet weak var leftsharecommentUserNamelbl = UILabel()
    @IBOutlet weak var leftsharecommentUserTagNamelbl = UILabel()
    @IBOutlet weak var leftsharecommentUserNamewidth = NSLayoutConstraint()
    @IBOutlet weak var leftsharecommentUserTagNamewidth = NSLayoutConstraint()
    @IBOutlet weak var leftsharecommenttextlbl = KILabel()
    @IBOutlet weak var leftsharecommenttextheight = NSLayoutConstraint()
    @IBOutlet weak var leftsharecommentnamelbl = UILabel()
    @IBOutlet weak var leftsharecommentdetailslbl = UILabel()
    @IBOutlet weak var leftsharecommentstarimage = UIImageView()

    // right link chat cell
    @IBOutlet weak var rightlinkView = UIView()
    @IBOutlet weak var rightsublinkView = UIView()
    @IBOutlet weak var rightlinkDatelbl = UILabel()
    @IBOutlet weak var rightlinkmsglbl = KILabel()
    @IBOutlet weak var rightlinkmsgheight = NSLayoutConstraint()
    @IBOutlet weak var rightlinkimage = AsyncImageView()
    @IBOutlet weak var rightlinktitlelbl = UILabel()
    @IBOutlet weak var rightlinkdesclbl = UILabel()
    @IBOutlet weak var rightlinkurllbl = UILabel()
    @IBOutlet weak var rightlinkstarimage = UIImageView()

    // left link chat cell
    @IBOutlet weak var leftlinkView = UIView()
    @IBOutlet weak var leftsublinkView = UIView()
    @IBOutlet weak var leftlinkDatelbl = UILabel()
    @IBOutlet weak var leftlinkUserNamelbl = UILabel()
    @IBOutlet weak var leftlinkUserTagNamelbl = UILabel()
    @IBOutlet weak var leftlinkUserNamewidth = NSLayoutConstraint()
    @IBOutlet weak var leftlinkUserTagNamewidth = NSLayoutConstraint()
    @IBOutlet weak var leftlinkmsglbl = KILabel()
    @IBOutlet weak var leftlinkmsgheight = NSLayoutConstraint()
    @IBOutlet weak var leftlinkimage = AsyncImageView()
    @IBOutlet weak var leftlinktitlelbl = UILabel()
    @IBOutlet weak var leftlinkdesclbl = UILabel()
    @IBOutlet weak var leftlinkurllbl = UILabel()
    @IBOutlet weak var leftlinkstarimage = UIImageView()

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
