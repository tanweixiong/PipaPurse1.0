//
//  HomeStampView.swift
//  PTNPurse
//
//  Created by tam on 2018/1/16.
//  Copyright © 2018年 Wilkinson. All rights reserved.
//

import UIKit

class HomeStampView: UIView {
    var homeStampViewBlock:((UIButton)->())?;
    @IBOutlet weak var dlView: UIView!
    @IBOutlet weak var trView: UIView!
    @IBOutlet weak var arView: UIView!
    @IBOutlet weak var ltView: UIView!
    
    @IBOutlet weak var titleLabel1: UILabel!
    @IBOutlet weak var titleLabel2: UILabel!
    @IBOutlet weak var titleLabel3: UILabel!
    @IBOutlet weak var titleLabel4: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        Tools.setViewShadow(dlView)
        Tools.setViewShadow(trView)
        Tools.setViewShadow(arView)
        Tools.setViewShadow(ltView)
        
        titleLabel1.text = LanguageHelper.getString(key: "homePage_receive")
        titleLabel2.text = LanguageHelper.getString(key: "homePage_transfer")
        titleLabel3.text = LanguageHelper.getString(key: "homePage_conversion")
        titleLabel4.text = LanguageHelper.getString(key: "homePage_details")
    }
    
    @IBAction func onClick(_ sender: UIButton) {
        if homeStampViewBlock != nil {
            homeStampViewBlock!(sender)
        }
    }
    
}
