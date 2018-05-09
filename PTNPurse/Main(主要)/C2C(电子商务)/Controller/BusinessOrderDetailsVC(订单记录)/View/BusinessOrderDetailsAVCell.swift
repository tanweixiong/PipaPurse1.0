//
//  BusinessOrderDetailsAVCell.swift
//  PTNPurse
//
//  Created by tam on 2018/3/13.
//  Copyright © 2018年 Wilkinson. All rights reserved.
//

import UIKit

class BusinessOrderDetailsAVCell: UITableViewCell {
    @IBOutlet weak var backgroundVw: UIView!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLab: UILabel!
    @IBOutlet weak var statusLab: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        avatarImageView.sd_setImage(with:NSURL(string: "")! as URL, placeholderImage: UIImage.init(named: "ic_defaultPicture"))
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
