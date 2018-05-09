//
//  HomeTransferFinishView.swift
//  PTNPurse
//
//  Created by tam on 2018/1/17.
//  Copyright © 2018年 Wilkinson. All rights reserved.
//

import UIKit

class HomeTransferFinishView: UIView {

    @IBOutlet weak var naviView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var detailsBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        closeBtn.layer.borderColor = UIColor.R_UIColorFromRGB(color: 0xCED7E6).cgColor
        closeBtn.layer.borderWidth = 1
        closeBtn.setTitle(LanguageHelper.getString(key: "homePage_Details_Successfully_Close"), for: .normal)
    }

}
