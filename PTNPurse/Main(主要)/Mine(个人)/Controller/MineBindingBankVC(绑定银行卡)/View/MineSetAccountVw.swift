//
//  MineSetAccountVw.swift
//  BCPPurse
//
//  Created by SKINK on 2018/4/16.
//  Copyright © 2018年 Wilkinson. All rights reserved.
//

import UIKit

class MineSetAccountVw: UIView {
    @IBOutlet weak var determineBtn: UIButton!
    @IBOutlet weak var titleLab: UILabel!
    @IBOutlet weak var paymentMethodTF: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        determineBtn.layer.borderWidth = 1
        determineBtn.layer.borderColor = UIColor.R_UIColorFromRGB(color: 0xCED7E6).cgColor
    }
}


