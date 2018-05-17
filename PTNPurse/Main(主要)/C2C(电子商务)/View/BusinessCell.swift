//
//  BusinessCell.swift
//  PTNPurse
//
//  Created by tam on 2018/3/12.
//  Copyright © 2018年 Wilkinson. All rights reserved.
//

import UIKit

class BusinessCell: UITableViewCell {
    @IBOutlet weak var avatarImageView: UIImageView!
//    @IBOutlet weak var transactionLab: UILabel!
//    @IBOutlet weak var praiseLab: UILabel!
    @IBOutlet weak var priceLab: UILabel!
    @IBOutlet weak var backgroundVw: UIView!
    @IBOutlet weak var nameLab: UILabel!
    @IBOutlet weak var dealNumLab: UILabel!
    @IBOutlet weak var receivablesTypeLab: UILabel!
    @IBOutlet weak var maxLab: UILabel!
    var style = BusinessTransactionStyle.buyStyle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        Tools.setViewShadow(backgroundVw)
    }
    
    var model = BusinessModel(){
        didSet{  
            let avatarUrl = model?.photo == nil ? ""  : model?.photo
            avatarImageView.sd_setImage(with: NSURL(string: avatarUrl!)! as URL, placeholderImage: UIImage.init(named: "ic_defaultPicture"))

            let name = model?.username == nil ? "" : model?.username
            nameLab.text = name
            
            let entrustPrice = model?.entrustPrice == nil ? 0 : model?.entrustPrice
            let newPrice = String(format: "%.2f", (entrustPrice?.doubleValue)!)
            priceLab.text = Tools.getWalletAmount(amount: newPrice) + " " + "CNY"
            
            let dealNum = model?.dealNum == nil ? 0 : model?.dealNum
            dealNumLab.text = LanguageHelper.getString(key: "C2C_home_Deal") + "：" + (dealNum?.stringValue)!
            
            let receivablesType = model?.receivablesType == nil ? 0 : model?.receivablesType
            receivablesTypeLab.text = LanguageHelper.getString(key: "C2C_payment_method") + "：" + Tools.getPaymentDetailsMethod((receivablesType!.stringValue))
            
            if let entrustMaxPrice = model?.entrustMaxPrice {
                maxLab.text = LanguageHelper.getString(key: "C2C_mine_my_advertisement_Limit") + "：" + Tools.getWalletAmount(amount: (entrustMaxPrice.stringValue))
            }
            
            backgroundVw.backgroundColor = style == .buyStyle ? UIColor.R_UIColorFromRGB(color: 0xFFF0EC) : UIColor.R_UIColorFromRGB(color: 0xEEFEF4)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
