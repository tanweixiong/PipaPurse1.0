//
//  HomeDetsilsAssetsView.swift
//  PTNPurse
//
//  Created by tam on 2018/3/13.
//  Copyright © 2018年 Wilkinson. All rights reserved.
//

import UIKit

class HomeDetsilsAssetsView: UIView {

    @IBOutlet weak var availableLab: UILabel!
    @IBOutlet weak var freezeLab: UILabel!
    
    var model = HomeConvertModel(){
        didSet{

            self.availableLab.text = LanguageHelper.getString(key: "homepage_Amount_Available") + "：" + (self.model?.fakebalance?.stringValue)!
            self.freezeLab.text = LanguageHelper.getString(key: "homepage_Freeze_Amount") + "：" + (self.model?.totalbalance?.stringValue)!
        }
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
