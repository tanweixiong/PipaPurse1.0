//
//  BusinessTransactionDeView.swift
//  PTNPurse
//
//  Created by tam on 2018/5/11.
//  Copyright © 2018年 Wilkinson. All rights reserved.
//

import UIKit

class BusinessTransactionDeView: UIView {
    @IBOutlet weak var backGroundVw: UIView!
    @IBOutlet weak var entrustPriceLab: UILabel!
    @IBOutlet weak var limteLab: UILabel!
    @IBOutlet weak var dataLab: UILabel!
    @IBOutlet weak var remarkLab: UILabel!{
        didSet{
            remarkLab.font = UIFont.systemFont(ofSize: 12)
            remarkLab.textColor = UIColor.R_UIColorFromRGB(color: 0x4D4F51)
        }
    }
    @IBOutlet weak var quotationLab: UILabel!
    @IBOutlet weak var transactionLimitLab: UILabel!
    @IBOutlet weak var releaseDataLab: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        Tools.setViewShadow(backGroundVw)
        
        quotationLab.text = LanguageHelper.getString(key: "C2C_Quotation")
        transactionLimitLab.text = LanguageHelper.getString(key: "C2C_home_Limit")
        releaseDataLab.text = LanguageHelper.getString(key: "C2C_ReleaseData")
    }
    
    var model = BusinessModel(){
        didSet{
            let price = model?.entrustPrice == nil ? 0 : (model?.entrustPrice)!
            entrustPriceLab.text = Tools.setNSDecimalNumber(price) + " CNY"
            
            let entrustMaxPrice = model?.entrustMaxPrice == nil ? 0 : model?.entrustMaxPrice
            let entrustMinPrice = model?.entrustMinPrice == nil ? 0 : model?.entrustMinPrice
            limteLab.text = Tools.getWalletAmount(amount: (entrustMinPrice!.stringValue)) + "~" + Tools.getWalletAmount(amount: (entrustMaxPrice!.stringValue))
            
            if let data = model?.date {
                dataLab.text = data
            }
            
            if let remark = model?.remark {
                remarkLab.text = remark
            }
        }
    }

}
