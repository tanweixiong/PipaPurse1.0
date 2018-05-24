//
//  BusinessInviteFriendsCell.swift
//  PTNPurse
//
//  Created by tam on 2018/4/8.
//  Copyright © 2018年 Wilkinson. All rights reserved.
//

import UIKit

class BusinessInviteFriendsCell: UITableViewCell {
    @IBOutlet weak var usernameLab: UILabel!
    @IBOutlet weak var avatarImageVw: UIImageView!
    @IBOutlet weak var priceLab: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

    }
    
    var model = BusinessBonusDetailsModel(){
        didSet{
            let url = model?.userphoto == nil ? "" : (model?.userphoto)!
            avatarImageVw.sd_setImage(with: NSURL(string: url )! as URL, placeholderImage: UIImage.init(named: "ic_mine_avatar"))
            usernameLab.text = model?.username == nil ? "" : (model?.username)!
            
            let price = model?.price == nil ? 0 : (model?.price)!
            priceLab.text = "+ " + price.stringValue
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
