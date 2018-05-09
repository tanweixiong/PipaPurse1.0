//
//  BusinessBuyHistoryCell.swift
//  PTNPurse
//
//  Created by tam on 2018/3/13.
//  Copyright © 2018年 Wilkinson. All rights reserved.
//

import UIKit

class BusinessBuyHistoryCell: UITableViewCell {

    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var dateLab: UILabel!
    @IBOutlet weak var entrustPriceLab: UILabel!
    @IBOutlet weak var entrustMaxPriceLab: UILabel!
    @IBOutlet weak var payMethodLab: UILabel!
    @IBOutlet weak var entrustMinPriceLab: UILabel!
    @IBOutlet weak var receivablesTypeLab: UILabel!
    @IBOutlet weak var detailsBtn: UIButton!
    @IBOutlet weak var operatingBtn: UIButton!
    @IBOutlet weak var backgroundVw: UIView!
    
    
    @IBOutlet weak var entrustPriceTitleLab: UILabel!
    @IBOutlet weak var entrustMaxTitleLab: UILabel!
    @IBOutlet weak var payMethodTitleLab: UILabel!
    @IBOutlet weak var entrustMinPriceTitleLab: UILabel!
    
    var model = BusinessBuyHistoryModel(){
        didSet{
            stateLabel.text = Tools.getMineAdvertisingMethod((model?.state?.stringValue)!)
            dateLab.text = model?.date
            entrustPriceLab.text = Tools.setPriceNumber(price: (model?.entrustPrice!)!) + " CNY"
            entrustMaxPriceLab.text = (model?.entrustMaxPrice?.stringValue)! + "个"
            payMethodLab.text = Tools.getPaymentDetailsMethod((model!.receivablesType!.stringValue))
            entrustMinPriceLab.text = Tools.setPriceNumber(price: (model?.entrustMinPrice!)!) + " CNY"
            
            entrustPriceTitleLab.text = LanguageHelper.getString(key: "C2C_mine_my_advertisement_Price") + "："
            entrustMaxTitleLab.text = LanguageHelper.getString(key: "C2C_mine_my_advertisement_Limit")
            payMethodTitleLab.text = LanguageHelper.getString(key: "C2C_mine_my_advertisement_Method")
            entrustMinPriceTitleLab.text = LanguageHelper.getString(key: "C2C_mine_my_advertisement_Min_limit")
            operatingBtn.setTitle(LanguageHelper.getString(key: "C2C_mine_my_advertisement_Drop"), for: .normal)
            
            if model?.state == 0 {
                detailsBtn.isHidden = true
                operatingBtn.isHidden = false
            }else{
                detailsBtn.isHidden = true
                operatingBtn.isHidden = true
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        Tools.setViewShadow(backgroundVw)
        operatingBtn.layer.borderWidth = 1
        operatingBtn.layer.borderColor = UIColor.R_UIColorFromRGB(color: 0xCED7E6).cgColor
        detailsBtn.layer.borderWidth = 1
        detailsBtn.layer.borderColor = UIColor.R_UIColorFromRGB(color: 0xCED7E6).cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
