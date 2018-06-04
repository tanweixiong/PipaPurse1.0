//
//  BusinessPremiumCell.swift
//  PipaPurse
//
//  Created by tam on 2018/5/30.
//  Copyright © 2018年 Wilkinson. All rights reserved.
//

import UIKit

class BusinessPremiumCell: UITableViewCell {
    var premiumSliderBlock:((String)->())?;
    var currencyPrices = NSNumber()
    @IBOutlet weak var premiumTipsLab: UILabel!
    @IBOutlet weak var premiumTitleLab: UILabel!
    @IBOutlet weak var percentageVw: UIView!
    @IBOutlet weak var sliderBgVw: UIView!
    @IBOutlet weak var percentLab: UILabel!
    @IBOutlet weak var priceTitleLab: UILabel!
    @IBOutlet weak var priceTipsLab: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        percentageVw.layer.borderWidth = 1
        percentageVw.layer.borderColor = R_UIThemeColor.cgColor
        premiumTitleLab.text = LanguageHelper.getString(key: "C2C_Proportion_Title")
        priceTitleLab.text = LanguageHelper.getString(key: "C2C_mine_my_advertisement_Price")
        premiumTipsLab.text = LanguageHelper.getString(key: "C2C_publish_Premium_Ticp")
        priceTipsLab.text = LanguageHelper.getString(key: "C2C_publish_Premium_Price")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupUI(currencyPrices:NSNumber){
        self.currencyPrices = currencyPrices
        sliderBgVw.addSubview(sliderView)
        sliderView.snp.makeConstraints { (make) in
            make.left.equalTo(sliderBgVw.snp.left).offset(0)
            make.centerY.equalTo(sliderBgVw.snp.centerY).offset(0)
            make.width.equalTo(sliderBgVw.width)
            make.height.equalTo(20)
        }
        
        let currencyPricesStr = (self.currencyPrices.stringValue)
        let transactionUnitPrice = self.currencyPrices.doubleValue * Double(10) / 100
        let difference = currencyPrices.doubleValue + transactionUnitPrice
        let transactionUnitPriceStr = Tools.getConversionPrice(amount: "\(difference)")
        if Tools.getLocalLanguage() == "0" {
            premiumTipsLab.text = "通过滑动溢出比例来调整公告，设置负数，报价将低于市场价，设置正数，报价将高于市场价，比如当前价格\(currencyPricesStr)，溢价比例为10%，那么价格为\(transactionUnitPriceStr)"
        }else{
             premiumTipsLab.text = "Premium ticp for example, if the current price is \(currencyPricesStr) and the premium rate is 10%, then the price is \(transactionUnitPriceStr)"
        }
        
        let differences = self.getPremiumSlider(slider: 0)
        let transactionUnitPriceStrs = Tools.getConversionPrice(amount: "\(differences)")
        if premiumSliderBlock != nil {
            premiumSliderBlock!(transactionUnitPriceStrs)
        }
    }
    
    lazy var sliderView: PTNSlider = {
        let slider = PTNSlider()
        slider.minimumTrackTintColor = R_UIThemeColor
        slider.maximumTrackTintColor = UIColor.R_UIColorFromRGB(color: 0xCED7E6)
        slider.addTarget(self, action: #selector(changed(slider:)), for: UIControlEvents.valueChanged)
        slider.minimumValue = 0
        slider.maximumValue = 200
        return slider
    }()
    
    @objc func changed(slider:UISlider){
        let progressInt = Int(slider.value)
        var currentProgress:Int = 0
        if progressInt > 100 {
            let positive = progressInt - 100
            currentProgress = positive
            currentProgress =  currentProgress == 100 ? 99 : currentProgress
            percentLab.text = "\(currentProgress)"
        }else{
            currentProgress =  (100 - progressInt) * -1
            currentProgress =  currentProgress == -100 ? -99 : currentProgress
            percentLab.text = "\(currentProgress)"
        }
        let transactionUnitPrice = currencyPrices.doubleValue * Double(currentProgress) / 100
        let difference = currencyPrices.doubleValue + transactionUnitPrice
        let transactionUnitPriceStr = Tools.getConversionPrice(amount: "\(difference)")
        if premiumSliderBlock != nil {
           premiumSliderBlock!(transactionUnitPriceStr)
        }
    }
    
    func getPremiumSlider(slider:Int)->Double{
        let progressInt = slider
        var currentProgress:Int = 0
        if progressInt > 100 {
            let positive = progressInt - 100
            currentProgress = positive
            currentProgress =  currentProgress == 100 ? 99 : currentProgress
            percentLab.text = "\(currentProgress)"
        }else{
            currentProgress =  (100 - progressInt) * -1
            currentProgress =  currentProgress == -100 ? -99 : currentProgress
            percentLab.text = "\(currentProgress)"
        }
        let transactionUnitPrice = currencyPrices.doubleValue * Double(currentProgress) / 100
        let difference = currencyPrices.doubleValue + transactionUnitPrice
        return difference
    }
    
}
