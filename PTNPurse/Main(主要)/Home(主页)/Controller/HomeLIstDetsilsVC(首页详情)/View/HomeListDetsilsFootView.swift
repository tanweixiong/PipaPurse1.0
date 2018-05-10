//
//  HomeLIstDetsilsFootView.swift
//  PTNPurse
//
//  Created by tam on 2018/1/23.
//  Copyright © 2018年 Wilkinson. All rights reserved.
//

import UIKit

class HomeListDetsilsFootView: UIView {
    @IBOutlet weak var footBtn1: UIButton!
    @IBOutlet weak var footBtn2: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        footBtn1.layer.cornerRadius = 5
        footBtn1.layer.masksToBounds = true
        footBtn1.layer.borderWidth = 1
        footBtn1.layer.borderColor = R_UIThemeSkyBlueColor.cgColor
        footBtn1.setTitleColor(R_UIThemeSkyBlueColor, for: .normal)
        
        footBtn2.layer.cornerRadius = 5
        footBtn2.layer.masksToBounds = true
        footBtn2.backgroundColor = R_UIThemeSkyBlueColor
        footBtn2.setTitleColor(UIColor.white, for: .normal)
    }
    
}

