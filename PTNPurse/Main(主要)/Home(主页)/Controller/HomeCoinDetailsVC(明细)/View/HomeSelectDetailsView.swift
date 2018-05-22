//
//  HomeSelectDetailsView.swift
//  PTNPurse
//
//  Created by tam on 2018/1/17.
//  Copyright © 2018年 Wilkinson. All rights reserved.
//

import UIKit

class HomeSelectDetailsView: UIView {

    @IBOutlet weak var transferBtn: UIButton!
    @IBOutlet weak var transferView: UIView!
    @IBOutlet weak var conversionLabel: UILabel!
    
    @IBOutlet weak var backGroundVw: UIView!
    
    @IBOutlet weak var centerDisY: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        Tools.setViewShadow(transferView)
        conversionLabel.text = LanguageHelper.getString(key: "C2C_Trade")
    }
    
}
