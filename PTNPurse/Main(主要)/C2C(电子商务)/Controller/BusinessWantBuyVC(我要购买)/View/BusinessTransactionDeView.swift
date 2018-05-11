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
    @IBOutlet weak var remarkLab: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        Tools.setViewShadow(backGroundVw)
    }
    
    var model = BusinessModel(){
        didSet{
            let price = model?.entrustPrice == nil ? 0 : model?.entrustPrice
            let newPrice = Tools.setPriceNumber(price: price!)
            entrustPriceLab.text = Tools.getWalletAmount(amount: newPrice) + " CNY"
            
            let entrustMaxPrice = model?.entrustMaxPrice == nil ? 0 : model?.entrustMaxPrice
            let entrustMinPrice = model?.entrustMinPrice == nil ? 0 : model?.entrustMinPrice
            limteLab.text = Tools.getWalletAmount(amount: (entrustMaxPrice!.stringValue)) + "~" + Tools.getWalletAmount(amount: (entrustMinPrice!.stringValue)) +  "CNY"
            
            if let data = model?.date {
                dataLab.text = data
            }
            
            if let remark = model?.remark {
                remarkLab.text = remark
            }
        }
    }

}
