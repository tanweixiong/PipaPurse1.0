//
//  BusinessWantFinishView.swift
//  PTNPurse
//
//  Created by tam on 2018/3/12.
//  Copyright © 2018年 Wilkinson. All rights reserved.
//

import UIKit

class BusinessWantFinishView: UIView {
    @IBOutlet weak var contactBtn: UIButton!
    @IBOutlet weak var remindBtn: UIButton!
    @IBOutlet weak var finishTitleLab: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        contactBtn.layer.borderWidth = 1
        contactBtn.layer.borderColor = UIColor.R_UIColorFromRGB(color: 0xCED7E6).cgColor
        
        contactBtn.setTitle(LanguageHelper.getString(key: "C2C_home_finish_Back"), for: .normal)
        remindBtn.setTitle(LanguageHelper.getString(key: "C2C_home_finish_See_details"), for: .normal)
    }
}
