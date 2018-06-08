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
    @IBOutlet weak var percentTF: UITextField!{
        didSet{
            percentTF.textColor = UIColor.R_UIColorFromRGB(color: 0xBDBDBD)
        }
    }
    @IBOutlet weak var priceTitleLab: UILabel!
    @IBOutlet weak var priceTipsLab: UILabel!
    
    @IBOutlet weak var selectPositiveBtn: UIButton!
    @IBOutlet weak var lessBtn: UIButton!
    @IBOutlet weak var addBtn: UIButton!
    
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
            make.left.equalTo(sliderBgVw.snp.left).offset(20)
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
        
        if self.currencyPrices != 0 {
            self.sliderView.value = 100
            _ = self.getPremiumSlider(slider: 100)
            if premiumSliderBlock != nil {
                premiumSliderBlock!(Tools.getWalletPrice(amount: Tools.setNSDecimalNumber(self.currencyPrices)))
            }
        }else{
            self.sliderView.value = 100
            self.percentTF.placeholder = "--"
            if premiumSliderBlock != nil {
                premiumSliderBlock!("0")
            }
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(BusinessTransactionVC.textFieldTextDidChangeOneCI), name:NSNotification.Name.UITextFieldTextDidChange, object:nil)
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
    
    //MARK: -滑块
    @objc func changed(slider:UISlider){
        let progressInt = Int(slider.value)
        let difference = self.getPremiumSlider(slider: progressInt)
        let transactionUnitPrice = Tools.getConversionPrice(amount: "\(difference)")
        if premiumSliderBlock != nil {
           premiumSliderBlock!(transactionUnitPrice)
        }
    }
    
     //MARK: -减少
    @IBAction func lessOnClick(_ sender: UIButton) {
        var currentValue = Int(self.sliderView.value)
        if currentValue  != 0  &&  currentValue < 201{
            currentValue = currentValue - 1
            sliderView.value = Float(currentValue)
            setSliderValue(value: currentValue)
        }
    }
    
    //MARK: -增加
    @IBAction func addOnClick(_ sender: UIButton) {
        var currentValue = Int(self.sliderView.value)
        if currentValue  != 0  &&  currentValue < 201{
            currentValue = currentValue + 1
            sliderView.value = Float(currentValue)
            setSliderValue(value: currentValue)
        }
    }
    
    //MARK: -选择正负
    @IBAction func selectPositiveOnClick(_ sender: UIButton) {
        percentTF.resignFirstResponder()
        let selectPositiveRect = selectPositiveBtn.convert(self.selectPositiveBtn.bounds, to: window)
        let y = selectPositiveRect.maxY
        let x = selectPositiveRect.origin.x
        let menuView = PST_MenuView.init(frame: CGRect(x: x, y: y, width: 80, height: 95), titleArr: ["+","-"], imgArr: nil, arrowOffset: 30, rowHeight: 40, layoutType: PST_MenuViewLayoutType(rawValue: 1)!, directionType: PST_MenuViewDirectionType(rawValue: 0)!, delegate: self)
        menuView?.arrowColor = UIColor.white
        menuView?.titleColor = UIColor.R_UIColorFromRGB(color: 0x545B71)
    }
    
    //MARK: -输入值时发生变化
    func setSliderValue(value:Int){
        let difference = self.getPremiumSlider(slider: value)
        let transactionUnitPriceStr = Tools.getConversionPrice(amount: "\(difference)")
        if premiumSliderBlock != nil {
            premiumSliderBlock!(transactionUnitPriceStr)
        }
    }
    
    //MARK: -限制百分比输入
    @objc func textFieldTextDidChangeOneCI(notification:NSNotification){
        let textField = notification.object as! UITextField
        if textField == percentTF {
            let textContent = textField.text
            if textContent != ""{
                self.setSliderValue(value: Int(textContent!)!)
                self.sliderView.value = Float(Int(textContent!)!)
            }
            let textNum = textContent?.count
            if textNum! > 2 {
                let index = textContent?.index((textContent?.startIndex)!, offsetBy: 2)
                let str = textContent?.substring(to: index!)
                textField.text = str
            }
        }
   }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UITextFieldTextDidChange, object: nil)
    }
}

extension BusinessPremiumCell:PST_MenuViewDelegate{
    func didSelectRow(at index: Int, title: String!, img: String!) {
        getSelectPositive(chooseSymbol: index)
    }
}


extension BusinessPremiumCell {
    //MARK: -获取当前值方法
    func getSelectPositive(chooseSymbol:Int){
        let progressInt = Int(self.sliderView.value)
        
        let chooseSymbol = chooseSymbol == 0 ? "+" : "-" //选择值
         selectPositiveBtn.setTitle(chooseSymbol, for: .normal)
        
        let currcent = Int(percentTF.text!)

        var currentProgress:Int = 0
        if progressInt > 100 {
            if chooseSymbol == "-"{
                currentProgress = 99 - currcent!
            }else{
                currentProgress = currcent!
            }
        }else{
            if chooseSymbol == "+"{
                currentProgress = 100 + currcent!
            }else{
                currentProgress = currcent!
            }
        }
        self.sliderView.value = Float(currentProgress)
        

        let premiumValue = setCalculatedNum(value: Int(self.sliderView.value))
        if premiumSliderBlock != nil {
            premiumSliderBlock!("\(premiumValue)")
        }
    }
    
    //MARK: -计算值
    func setCalculatedNum(value:Int)->Double{
        let progressInt = value
        var currentProgress:Int = 0
        if progressInt > 100 {
            let positive = progressInt - 100
            currentProgress = positive
            currentProgress =  currentProgress == 100 ? 99 : currentProgress
        }else{
            currentProgress =  (100 - progressInt) * -1
            currentProgress =  currentProgress == -100 ? -99 : currentProgress
    
        }
        let transactionUnitPrice = currencyPrices.doubleValue * Double(currentProgress) / 100
        let difference = currencyPrices.doubleValue + transactionUnitPrice
        return difference
    }
    
    //MARK: -获取当前值方法
    func getPremiumSlider(slider:Int)->Double{
        let progressInt = slider
        var currentProgress:Int = 0
        if progressInt > 100 {
            let positive = progressInt - 100
            currentProgress = positive
            currentProgress =  currentProgress == 100 ? 99 : currentProgress
            selectPositiveBtn.setTitle("+", for: .normal)
            
            percentTF.text = "\(currentProgress)"
        }else{
            currentProgress =  (100 - progressInt) * -1
            currentProgress =  currentProgress == -100 ? -99 : currentProgress
            selectPositiveBtn.setTitle("-", for: .normal)
            
            let newCurrentProgress = currentProgress * -1
            percentTF.text = "\(newCurrentProgress)"
        }
        if currentProgress == 0 {
            selectPositiveBtn.setTitle("", for: .normal)
        }
        let transactionUnitPrice = currencyPrices.doubleValue * Double(currentProgress) / 100
        let difference = currencyPrices.doubleValue + transactionUnitPrice
        
        if slider == 0 {
            percentTF.text = "0"
            return self.currencyPrices.doubleValue
        }
        
        return difference
    }
}
