//
//  BusinessOrderFinishCell.swift
//  PTNPurse
//
//  Created by tam on 2018/3/26.
//  Copyright © 2018年 Wilkinson. All rights reserved.
//

import UIKit

class BusinessOrderFinishCell: UITableViewCell {
    @IBOutlet weak var backgroundVw: UIView!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLab: UILabel!
    @IBOutlet weak var priceLab: UILabel!
    @IBOutlet weak var transactionUnitPriceLab: UILabel!
    @IBOutlet weak var transactionNumLab: UILabel!
    @IBOutlet weak var transactionStatusLab: UILabel!
    @IBOutlet weak var statusLab: UILabel!
    
    @IBOutlet weak var transactionUnitTitleLab: UILabel!
    @IBOutlet weak var transactionNumTitleLab: UILabel!
    @IBOutlet weak var transactionStatusTitleLab: UILabel!
    
    var model = BusinessaDvertisementModel(){
        didSet{
            let photo = model?.photo == nil ? "" :  model?.photo
            avatarImageView.sd_setImage(with:NSURL(string: photo!)! as URL, placeholderImage: UIImage.init(named: "ic_defaultPicture"))
            
            let name = model?.username == nil ? "" : model?.username
            nameLab.text = name!
            
            //价格
            let sumPrice = model?.sumPrice == nil ? 0 : model?.sumPrice
            let dealNum = model?.dealNum == nil ? 0 : model?.dealNum
            priceLab.text = Tools.setPriceNumber(price: sumPrice!) + " CNY"
            
            //单价
            let unitPrice = model?.dealPrice == nil ? 0 : model?.dealPrice
            transactionUnitPriceLab.text = Tools.setPriceNumber(price: unitPrice!) + " CNY"
            
            //交易数量
            transactionNumLab.text = Tools.setPriceNumber(price: dealNum!) +  " " + LanguageHelper.getString(key: "homePage_Numbers")
            
            //状态，0：匹配中，1：已完成，2：撤销，3：等待买方付款，4：等待卖方确认，5：未付款回滚订单，6：纠纷强制打款，7：纠纷强制回滚
            //交易状态
            transactionStatusLab.text = Tools.getBusinessaTransactionStyle(Style: (model?.state?.stringValue)!)
            
            //交易状态
            var dealType = String()
            switch (model?.dealType?.intValue)! {
            case 0:
                dealType = LanguageHelper.getString(key: "C2C_mine_My_advertisement_Buy")
                statusLab.backgroundColor = UIColor.R_UIRGBColor(red: 65, green: 71, blue: 237, alpha: 1)
            case 1:
                dealType = LanguageHelper.getString(key: "C2C_mine_My_advertisement_Sell")
                statusLab.backgroundColor = UIColor.R_UIColorFromRGB(color: 0xFE7644)
            default: break
            }
            statusLab.text = dealType
            
            transactionUnitTitleLab.text = LanguageHelper.getString(key: "C2C_mine_My_advertisement_Unit") + "："
            transactionNumTitleLab.text = LanguageHelper.getString(key: "C2C_mine_My_advertisement_Quantity") + "："
            transactionStatusTitleLab.text = LanguageHelper.getString(key: "C2C_mine_My_advertisement_Status") + "："
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        Tools.setViewShadow(backgroundVw)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
