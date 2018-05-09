//
//  HomeConversionStatusView.swift
//  PTNPurse
//
//  Created by tam on 2018/1/17.
//  Copyright © 2018年 Wilkinson. All rights reserved.
//

import UIKit

class HomeConversionStatusView: UIView {
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var coinNameLabel: UILabel!
    @IBOutlet weak var USDPriceLabel: UILabel!
    @IBOutlet weak var CNYPriceLabel: UILabel!
    @IBOutlet weak var rankLabel1: UILabel!
    @IBOutlet weak var rankLabel2: UILabel!
    
    var model = QuotesModel(){
        didSet{
            
            let names = model?.coinName == nil ? "" : model?.coinName
            coinNameLabel.text = names
            
            let url = model?.coinIcon == nil ? "" : model?.coinIcon
            iconImageView.sd_setImage(with: NSURL(string:url!)! as URL, placeholderImage: UIImage.init(named: "ic_defaultPicture"))
            
            //usd
            if let coinPrice = model?.coinPrice {
                let unit = Tools.getIsChinese() == true ? "USD" : "CNY"
                rankLabel2.text = unit
                CNYPriceLabel.text = "≈¥" + Tools.getWalletAmount(amount: coinPrice.stringValue)
            }
            
            //cny
            if let coinPriceBySys = model?.coinPriceBySys {
                let unit = Tools.getIsChinese() == true ? "CNY" : "USD"
                rankLabel1.text = unit
                USDPriceLabel.text =  Tools.getWalletAmount(amount: coinPriceBySys.stringValue)
            }
        }
    }
    
    
}


