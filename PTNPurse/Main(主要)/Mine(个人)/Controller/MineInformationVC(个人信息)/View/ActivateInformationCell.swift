//
//  ActivateInformationCell.swift
//  DHSWallet
//
//  Created by tam on 2018/4/24.
//  Copyright © 2018年 zhengyi. All rights reserved.
//

import UIKit

class ActivateInformationCell: UITableViewCell {

    @IBOutlet weak var backGroundVw: UIView!
    @IBOutlet weak var headingLab: UILabel!
 
    @IBOutlet weak var textfield: UITextField!
    @IBOutlet weak var iconBtn: UIButton!
    @IBOutlet weak var avatarImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        Tools.setViewShadow(backGroundVw)
        textfield.textColor = UIColor.R_UIColorFromRGB(color: 0x828A9E)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
