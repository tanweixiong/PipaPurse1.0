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
            let newPrice = Tools.setPriceNumber(price: entrustPrice!)
            priceLab.text = Tools.getWalletAmount(amount: newPrice) + " " + "CNY"
            
            let dealNum = model?.dealNum == nil ? 0 : model?.dealNum
            dealNumLab.text = LanguageHelper.getString(key: "C2C_home_Deal") + Tools.setPriceNumber(price: dealNum!) + "       "
            
            let receivablesType = model?.receivablesType == nil ? 0 : model?.receivablesType
            receivablesTypeLab.text = Tools.getPaymentDetailsMethod((receivablesType!.stringValue)) + "       "
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
