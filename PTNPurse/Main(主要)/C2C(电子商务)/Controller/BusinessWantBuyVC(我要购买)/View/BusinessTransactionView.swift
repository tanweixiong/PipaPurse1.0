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
    @IBOutlet weak var nameLab: UILabel!
    @IBOutlet weak var backGroundVw: UIView!
    
    var model = BusinessWantBuyData(){
        didSet{
           let avatar = model.avatarUrl == nil ? "" : model.avatarUrl
           avatarImageView.sd_setImage(with:NSURL(string: avatar!)! as URL, placeholderImage: UIImage.init(named: "ic_defaultPicture"))
            
            let price = model.entrustPrice == nil ? 0 : model.entrustPrice
            let newPrice = Tools.setPriceNumber(price: price!)
            priceLab.text = Tools.getWalletAmount(amount: newPrice) + " CNY" + "/" + model.coinCore!
            
            let username = model.name == nil ? "" : model.name
            self.nameLab.text = username
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        Tools.setViewShadow(backGroundVw)
   }
}
