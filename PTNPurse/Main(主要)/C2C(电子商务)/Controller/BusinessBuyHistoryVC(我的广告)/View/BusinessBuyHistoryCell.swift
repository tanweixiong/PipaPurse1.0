//
//  BusinessBuyHistoryCell.swift
//  PTNPurse
//
//  Created by tam on 2018/3/13.
//  Copyright © 2018年 Wilkinson. All rights reserved.
//

import UIKit

class BusinessBuyHistoryCell: UITableViewCell {
    var style = BusinessTransactionStyle.buyStyle
    @IBOutlet weak var orderStateLab: UILabel!
    @IBOutlet weak var dateLab: UILabel!
    @IBOutlet weak var payMethodLab: UILabel!
    @IBOutlet weak var entrustMinPriceLab: UILabel!
    @IBOutlet weak var entrustMaxPriceLab: UILabel!
    @IBOutlet weak var detailsBtn: UIButton!
    @IBOutlet weak var operatingBtn: UIButton!
    @IBOutlet weak var backgroundVw: UIView!
    @IBOutlet weak var payMethodTitleLab: UILabel!
    @IBOutlet weak var entrustMinPriceTitleLab: UILabel!
    @IBOutlet weak var maxTitleLab: UILabel!
//    @IBOutlet weak var entrustPriceLab: UILabel!
//    @IBOutlet weak var entrustPriceTitleLab: UILabel!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var stateTitleLab: UILabel!
    @IBOutlet weak var detailsX: NSLayoutConstraint!
    
    @IBOutlet weak var commissionTitlepriceLab: UILabel!
    @IBOutlet weak var commissionPriceLab: UILabel!
    
    @IBOutlet weak var premiumTitleLab: UILabel!
    @IBOutlet weak var premiumLab: UILabel!
    
    @IBOutlet weak var quotePriceLab: UILabel!
    @IBOutlet weak var quotePriceTitleLab: UILabel!
    var model = BusinessBuyHistoryModel(){
        didSet{
            stateLabel.text = Tools.getMineAdvertisingMethod((model?.state?.stringValue)!)
//            entrustPriceLab.text = Tools.setNSDecimalNumber((model?.entrustPrice!)!) + " CNY"
            dateLab.text = model?.date

            payMethodLab.text = Tools.getPaymentDetailsMethod((model!.receivablesType!.stringValue))
//            entrustPriceTitleLab.text = LanguageHelper.getString(key: "C2C_mine_my_advertisement_Price") + "："
            
            payMethodTitleLab.text = LanguageHelper.getString(key: "C2C_mine_my_advertisement_Method")
            entrustMinPriceTitleLab.text = LanguageHelper.getString(key: "C2C_mine_my_advertisement_Min_limit")
            operatingBtn.setTitle(LanguageHelper.getString(key: "C2C_mine_my_advertisement_Drop"), for: .normal)
            maxTitleLab.text = LanguageHelper.getString(key: "C2C_Max") + "："
            
            entrustMaxPriceLab.text = String(format: "%.2f", (model?.entrustMaxPrice?.doubleValue)!) + "CNY"
            entrustMinPriceLab.text = String(format: "%.2f", (model?.entrustMinPrice?.doubleValue)!) + "CNY"
            
            let entrustPrice = model?.entrustPrice == nil ? 0 : (model?.entrustPrice)!
            commissionPriceLab.text = Tools.setNSDecimalNumber(entrustPrice) + " CNY"
            
            let premium = model?.premium == nil ? 0 : (model?.premium)!
            let newPremium = (premium.doubleValue) * 100
            premiumLab.text = String(format: "%.f", newPremium) + "%"
            
            let markPrice = model?.marketPrice == nil ? 0 : (model?.marketPrice)!
            quotePriceLab.text = Tools.setNSDecimalNumber(markPrice) + " CNY"
            
            if model?.state == 0 {
                operatingBtn.isHidden = false
                detailsX.constant = 10
            }else{
                operatingBtn.isHidden = true
                detailsX.constant = -70
            }
            
            if style == .buyStyle {
                stateLabel.text = LanguageHelper.getString(key: "C2C_mine_advertisement_finish")
                stateLabel.backgroundColor = UIColor.R_UIColorFromRGB(color: 0x00D85A)
            }else if style == .sellStyle{
                stateLabel.text = LanguageHelper.getString(key: "C2C_mine_advertisement_processing")
                stateLabel.backgroundColor = UIColor.R_UIColorFromRGB(color: 0xFF7052)
            }
         
            stateTitleLab.text = LanguageHelper.getString(key: "C2C_publish_details_order_Status") + "："
            orderStateLab.text = Tools.getMineAdvertisingMethod((model?.state?.stringValue)!)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        Tools.setViewShadow(backgroundVw)
        operatingBtn.layer.borderWidth = 1
        operatingBtn.layer.borderColor = UIColor.R_UIColorFromRGB(color: 0xCED7E6).cgColor
        operatingBtn.setTitleColor(R_UIThemeColor, for: .normal)
        
        detailsBtn.layer.borderWidth = 1
        detailsBtn.layer.borderColor = UIColor.R_UIColorFromRGB(color: 0xCED7E6).cgColor
        detailsBtn.setTitle(LanguageHelper.getString(key: "C2C_mine_my_advertisement_Details"), for: .normal)
        
        commissionTitlepriceLab.text = LanguageHelper.getString(key: "Mine_An_Commission_price") + "："
        premiumTitleLab.text = LanguageHelper.getString(key: "Mine_An_Premium_price") + "："
        quotePriceLab.text = LanguageHelper.getString(key: "Mine_An_Quote_price") + "："
        
        commissionPriceLab.textColor = R_UIThemeColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
