//
//  HomeSelectDetailsView.swift
//  PTNPurse
//
//  Created by tam on 2018/1/17.
//  Copyright © 2018年 Wilkinson. All rights reserved.
//

import UIKit

class HomeSelectDetailsView: UIView {
    @IBOutlet weak var allBtn: UIButton!
    @IBOutlet weak var dataBtn: UIButton!
    @IBOutlet weak var allView: UIView!
    @IBOutlet weak var dataView: UIView!
    @IBOutlet weak var dataLabel: UILabel!
    @IBOutlet weak var transferBtn: UIButton!
    @IBOutlet weak var transferView: UIView!
    @IBOutlet weak var conversionLabel: UILabel!
    @IBOutlet weak var allLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        Tools.setViewShadow(allView)
        Tools.setViewShadow(dataView)
        Tools.setViewShadow(transferView)
        conversionLabel.text = LanguageHelper.getString(key: "homePage_conversion") + LanguageHelper.getString(key: "homePage_Details_Recording") 
        allLabel.text = LanguageHelper.getString(key: "homePage_Details_All")
        
    }
    
}
