//
//  QuotesDetailsView.swift
//  PTNPurse
//
//  Created by tam on 2018/3/15.
//  Copyright © 2018年 Wilkinson. All rights reserved.
//

import UIKit

class QuotesDetailsView: UIView {

    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var view3: UIView!
    @IBOutlet weak var view4: UIView!
    @IBOutlet weak var lowLab: UILabel!
    @IBOutlet weak var highLab: UILabel!
    @IBOutlet weak var lastLab: UILabel!
    @IBOutlet weak var rangLab: UILabel!
    @IBOutlet weak var volLab: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        Tools.setViewShadow(view1)
        Tools.setViewShadow(view2)
        Tools.setViewShadow(view3)
        Tools.setViewShadow(view4)
    }
    var model = QuotesDetsilsModel(){
        didSet{
            lowLab.text = "24h\(LanguageHelper.getString(key: "quotes_lowest"))：" + Tools.getWalletAmount(amount: (model?.low?.stringValue)!)
            highLab.text = "24h\(LanguageHelper.getString(key: "quotes_height"))：" + Tools.getWalletAmount(amount: (model?.high?.stringValue)!)
            volLab.text = "24h\(LanguageHelper.getString(key: "quotes_volume"))：" + Tools.getWalletAmount(amount: (model?.vol?.stringValue)!)
            lastLab.text = Tools.getWalletAmount(amount: (model?.last?.stringValue)!)
            rangLab.text = Tools.getWalletAmount(amount: (model?.range!)!)
            
            //涨
            if model?.state == 0 {
                rangLab.textColor = UIColor.R_UIColorFromRGB(color: 0xFF4554)
            //跌
            }else if model?.state == 1 {
                rangLab.textColor = UIColor.R_UIColorFromRGB(color: 0x74A700)
            //不变
            }else if model?.state == 2 {
                rangLab.textColor = UIColor.R_UIColorFromRGB(color: 0x7F8795)
            }
            
         }
    }

}
