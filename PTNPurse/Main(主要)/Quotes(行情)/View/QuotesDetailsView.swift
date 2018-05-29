//
//  QuotesDetailsView.swift
//  PTNPurse
//
//  Created by tam on 2018/3/15.
//  Copyright © 2018年 Wilkinson. All rights reserved.
//

import UIKit

class QuotesDetailsView: UIView {
    @IBOutlet weak var lastLab: UILabel!
    @IBOutlet weak var lowLab: UILabel!
    @IBOutlet weak var highLab: UILabel!
    @IBOutlet weak var volLab: UILabel!
    @IBOutlet weak var rangsLab: UILabel!
    @IBOutlet weak var priceBySysLab: UILabel!
    
    @IBOutlet weak var lastTiLab: UILabel!
    @IBOutlet weak var volTiLab: UILabel!
    @IBOutlet weak var priceBySysTiLab: UILabel!
    @IBOutlet weak var lowTiLab: UILabel!
    @IBOutlet weak var highTiLab: UILabel!
    @IBOutlet weak var rangsTiLab: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }
    var model = QuotesDetsilsModel(){
        didSet{
            lowLab.text =  Tools.getWalletAmount(amount: (model?.low?.stringValue)!)
            highLab.text =  Tools.getWalletAmount(amount: (model?.high?.stringValue)!)
            volLab.text =  Tools.getWalletAmount(amount: (model?.vol?.stringValue)!)
            lastLab.text = Tools.getWalletAmount(amount: (model?.price?.stringValue)!)
            rangsLab.text = Tools.getWalletAmount(amount: (model?.range!)!)
            priceBySysLab.text = Tools.setNSDecimalNumber((model?.priceBySys)!)
            
            
            lastTiLab.text = LanguageHelper.getString(key: "lastest_price") + " CNY"
            volTiLab.text = LanguageHelper.getString(key: "volume")
//            priceBySysTiLab.text = LanguageHelper.getString(key: "")
            lowTiLab.text = "24h" + LanguageHelper.getString(key: "quotes_lowest")
            highTiLab.text = "24h" + LanguageHelper.getString(key: "quotes_height")
            rangsTiLab.text = LanguageHelper.getString(key: "up_low")
            
            
         }
    }

}
