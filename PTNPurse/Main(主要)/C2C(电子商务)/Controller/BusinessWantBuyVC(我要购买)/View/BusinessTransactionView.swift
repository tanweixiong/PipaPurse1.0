//
//  BusinessTransactionView.swift
//  PTNPurse
//
//  Created by tam on 2018/3/12.
//  Copyright © 2018年 Wilkinson. All rights reserved.
//

import UIKit

class BusinessTransactionView: UIView {
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var priceLab: UILabel!
    @IBOutlet weak var limitLab: UILabel!
    @IBOutlet weak var nameLab: UILabel!
    
    var model = BusinessWantBuyData(){
        didSet{
           let avatar = model.avatarUrl == nil ? "" : model.avatarUrl
           avatarImageView.sd_setImage(with:NSURL(string: avatar!)! as URL, placeholderImage: UIImage.init(named: "ic_defaultPicture"))
            
            let price = model.entrustPrice == nil ? 0 : model.entrustPrice
            let newPrice = Tools.setPriceNumber(price: price!)
            priceLab.text = Tools.getWalletAmount(amount: newPrice) + " CNY"
            
            let max = model.entrustMaxPrice == nil ? 0 : model.entrustMaxPrice
            let min = model.entrustMinPrice == nil ? 0 : model.entrustMinPrice
            limitLab.text = LanguageHelper.getString(key: "C2C_home_Limit") + "：" + Tools.getWalletAmount(amount: (min?.stringValue)!) + "~" + Tools.getWalletAmount(amount: (max?.stringValue)!)
            
            let username = model.name == nil ? "" : model.name
            self.nameLab.text = username
            
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
   }
}
