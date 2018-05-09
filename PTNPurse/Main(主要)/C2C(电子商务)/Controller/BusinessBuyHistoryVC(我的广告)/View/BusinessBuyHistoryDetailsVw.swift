//
//  BusinessBuyHistoryDetailsVw.swift
//  PTNPurse
//
//  Created by tam on 2018/3/22.
//  Copyright © 2018年 Wilkinson. All rights reserved.
//

import UIKit

class BusinessBuyHistoryDetailsVw: UIView {
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var priceLab: UILabel!
    @IBOutlet weak var dataLab: UILabel!
    @IBOutlet weak var limitLab: UILabel!
    @IBOutlet weak var entrustMaxPriceLab: UILabel!
    @IBOutlet weak var nameLab: UILabel!
    @IBOutlet weak var stateLab: UILabel!
    @IBOutlet weak var receivablesTypeLab: UILabel!
    @IBOutlet weak var backgroundVw: UIView!
    
    @IBOutlet weak var title1Lab: UILabel!
    @IBOutlet weak var title2Lab: UILabel!
    @IBOutlet weak var title3Lab: UILabel!
    @IBOutlet weak var title4Lab: UILabel!
    @IBOutlet weak var title5Lab: UILabel!
    @IBOutlet weak var title6Lab: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        Tools.setViewShadow(backgroundVw)
    }
    
    var model = BusinessModel(){
        didSet{
            
            let avatar = model?.photo == nil ? "" : model?.photo
            avatarImageView.sd_setImage(with:NSURL(string: avatar!)! as URL, placeholderImage: UIImage.init(named: "ic_defaultPicture"))
            
            let price = model?.entrustPrice == nil ? 0 : model?.entrustPrice
            priceLab.text = Tools.getWalletAmount(amount: (price?.stringValue)!) + "CNY"

            let data = model?.date == nil ? "" : model?.date
            dataLab.text = data
            
            let entrustMinPrice = model?.entrustMinPrice == nil ? 0 : model?.entrustMinPrice
            limitLab.text = (entrustMinPrice?.stringValue)! + LanguageHelper.getString(key: "homePage_Numbers")
            
            let receivablesType = model?.receivablesType == nil ? 0 : model?.receivablesType
            receivablesTypeLab.text = Tools.getPaymentDetailsMethod((receivablesType?.stringValue)!)
            
            let username = model?.username == nil ? "" : model?.username
            self.nameLab.text = username
            
            let state = model?.state == nil ? 0 : model?.state
            stateLab.text = Tools.getMineAdvertisingMethod((state?.stringValue)!)
            
            let entrustMaxPrice = model?.entrustMaxPrice == nil ? 0 : model?.entrustMaxPrice
            entrustMaxPriceLab.text = (entrustMaxPrice?.stringValue)! + LanguageHelper.getString(key: "homePage_Numbers")
            
            //标题
            title1Lab.text = LanguageHelper.getString(key: "C2C_publish_details_order_Status")
            title2Lab.text = LanguageHelper.getString(key: "C2C_publish_details_order_Unit")
            title3Lab.text = LanguageHelper.getString(key: "C2C_publish_details_order_Limit")
            title4Lab.text = LanguageHelper.getString(key: "C2C_publish_details_order_Method")
            title5Lab.text = LanguageHelper.getString(key: "C2C_publish_details_order_Minimum_limit")
            title6Lab.text = LanguageHelper.getString(key: "C2C_publish_details_order_Time")
        }
    }

}
