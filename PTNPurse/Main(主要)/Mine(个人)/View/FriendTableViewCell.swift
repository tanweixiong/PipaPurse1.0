//
//  FriendTableViewCell.swift
//  PTNPurse
//
//  Created by zhengyi on 2018/1/21.
//  Copyright © 2018年 Wilkinson. All rights reserved.
//

import UIKit
import SDWebImage

class FriendTableViewCell: UITableViewCell {
    
    @IBOutlet weak var bgview: UIView!
    @IBOutlet weak var headImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var HeadImageHeightConstraint: NSLayoutConstraint!
    var friend: Friend? {
        didSet {
            if friend?.name != nil && friend?.photo != nil {
                let url = URL.init(string: (friend?.photo)!)
                headImageView.sd_setImage(with: url, placeholderImage: UIImage.init(named: "ic_defaultPicture"))
                nameLabel.text = friend?.name
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        headImageView.layer.borderWidth = 1
        headImageView.layer.borderColor = R_ZYMineViewGrayColor.cgColor
        headImageView.setViewBoarderCorner(radius: HeadImageHeightConstraint.constant / 2)
        
        self.selectionStyle = .none
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        Tools.setViewShadow(bgview)

    }
    
}
