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
    
    @IBOutlet weak var dealNumLab: UILabel!
    @IBOutlet weak var receivablesTypeLab: UILabel!
    var model = BusinessModel(){
        didSet{
           let avatar = model?.photo == nil ? "" : model?.photo
           avatarImageView.sd_setImage(with:NSURL(string: avatar!)! as URL, placeholderImage: UIImage.init(named: "ic_defaultPicture"))
            
            let price = model?.entrustPrice == nil ? 0 : model?.entrustPrice
            let newPrice = Tools.setPriceNumber(price: price!)
            priceLab.text = Tools.getWalletAmount(amount: newPrice) + " CNY" + "/" + (model?.coinCore!)!
            
            let username = model?.username == nil ? "" : model?.username
            nameLab.text = username
            
            let dealNum = model?.dealNum == nil ? 0 : model?.dealNum
            dealNumLab.text = LanguageHelper.getString(key: "C2C_Volume") + "：" + (dealNum?.stringValue)!
            
            let receivablesType = model?.receivablesType == nil ? 0 : model?.receivablesType
            receivablesTypeLab.text = LanguageHelper.getString(key: "C2C_payment_method") + "：" + Tools.getPaymentDetailsMethod((receivablesType!.stringValue))
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        Tools.setViewShadow(backGroundVw)
   }
}
