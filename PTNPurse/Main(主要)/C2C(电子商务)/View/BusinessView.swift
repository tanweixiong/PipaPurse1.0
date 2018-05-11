//
//  BusinessView.swift
//  PTNPurse
//
//  Created by tam on 2018/3/12.
//  Copyright © 2018年 Wilkinson. All rights reserved.
//

import UIKit

class BusinessView: UIView {
    @IBOutlet weak var sellBtn: UIButton!
    @IBOutlet weak var buyBtn: UIButton!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        buyBtn.setTitle(LanguageHelper.getString(key: "C2C_home_Buy"), for: .normal)
        sellBtn.setTitle(LanguageHelper.getString(key: "C2C_home_Sell"), for: .normal)
    }


}
