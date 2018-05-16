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
    
    @IBOutlet weak var entrustPriceLab: UILabel!
    @IBOutlet weak var entrustPriceTitleLab: UILabel!
    
    @IBOutlet weak var proportionLab: UILabel!
    @IBOutlet weak var proportionTitleLab: UILabel!
    
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var stateTitleLab: UILabel!
    var model = BusinessBuyHistoryModel(){
        didSet{
            stateLabel.text = Tools.getMineAdvertisingMethod((model?.state?.stringValue)!)
            entrustPriceLab.text = Tools.setPriceNumber(price: (model?.entrustPrice!)!) + " CNY"
            dateLab.text = model?.date
            entrustMaxPriceLab.text = (model?.entrustMaxPrice?.stringValue)! + "个"
            payMethodLab.text = Tools.getPaymentDetailsMethod((model!.receivablesType!.stringValue))
            entrustMinPriceLab.text = Tools.setPriceNumber(price: (model?.entrustMinPrice!)!) + " CNY"
            
            entrustPriceTitleLab.text = LanguageHelper.getString(key: "C2C_mine_my_advertisement_Price") + "："
            payMethodTitleLab.text = LanguageHelper.getString(key: "C2C_mine_my_advertisement_Method")
            entrustMinPriceTitleLab.text = LanguageHelper.getString(key: "C2C_mine_my_advertisement_Min_limit")
            operatingBtn.setTitle(LanguageHelper.getString(key: "C2C_mine_my_advertisement_Drop"), for: .normal)
            maxTitleLab.text = LanguageHelper.getString(key: "C2C_Max") + "："
            
            if model?.state == 0 {
                detailsBtn.isHidden = true
                operatingBtn.isHidden = false
            }else{
                detailsBtn.isHidden = true
                operatingBtn.isHidden = true
            }
            
            if style == .buyStyle {
                stateLabel.text = "购买广告"
                stateLabel.backgroundColor = UIColor.R_UIColorFromRGB(color: 0xFF7052)
                entrustPriceLab.textColor = UIColor.R_UIColorFromRGB(color: 0xFF7052)
            }else{
                stateLabel.text = "出售广告"
                stateLabel.backgroundColor = UIColor.R_UIColorFromRGB(color: 0x00D85A)
                entrustPriceLab.textColor = UIColor.R_UIColorFromRGB(color: 0x00D85A)
            }
         
            stateTitleLab.text = LanguageHelper.getString(key: "C2C_publish_details_order_Status") + "："
            stateLabel.text = Tools.getMineAdvertisingMethod((model?.state?.stringValue)!)
            
            proportionLab.text = "10%"
            proportionTitleLab.text = LanguageHelper.getString(key: "C2C_Proportion") + "："
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
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
