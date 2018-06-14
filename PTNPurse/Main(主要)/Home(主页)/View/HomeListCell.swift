//
//  HomeListCell.swift
//  PTNPurse
//
//  Created by tam on 2018/1/16.
//  Copyright © 2018年 Wilkinson. All rights reserved.
//

import UIKit

class HomeListCell: UITableViewCell {
    @IBOutlet weak var coinImage: UIImageView!
    @IBOutlet weak var backgroundVw: UIView!
    @IBOutlet weak var coinNameLabel: UILabel!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var moneyRateLabel: UILabel!
    var model = HomeWalletsModel() {
        didSet{
            
            if let coinName = model?.coinName {
                 coinNameLabel.text = coinName
            }

            if let balance = model?.totalBalance {
                balanceLabel.text = Tools.getWalletAmount(amount: Tools.setNSDecimalNumber(balance))
            }
            
            if let moneyRate = model?.moneyRate {
                moneyRateLabel.text = "≈¥" + Tools.getWalletAmount(amount: moneyRate.stringValue)
            }
            
            let url = model?.coinImg == nil ? "" : model?.coinImg
            coinImage.sd_setImage(with: NSURL(string:url!)! as URL, placeholderImage: UIImage.init(named: "ic_defaultPicture"))
        }
    }
    
    var quotesModel = QuotesModel(){
        didSet{
            if let coinName = quotesModel?.coinName {
                coinNameLabel.text = coinName
            }
            
            let url = quotesModel?.coinImg == nil ? "" : quotesModel?.coinImg
            coinImage.sd_setImage(with: NSURL(string:url!)! as URL, placeholderImage: UIImage.init(named: "ic_defaultPicture"))
            
            //usd
            if let coinPrice = quotesModel?.coinPrice {
                 let unit = Tools.getIsChinese() == true ? " USD" : " CNY"
                moneyRateLabel.text = "≈¥" + Tools.getWalletAmount(amount: coinPrice.stringValue) + unit
            }
            
            //cny
            if let coinPriceBySys = quotesModel?.coinPriceBySys {
                let unit = Tools.getIsChinese() == true ? " CNY" : " USD"
                balanceLabel.text =  Tools.getWalletAmount(amount: coinPriceBySys.stringValue) + unit
            }
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setData(){
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
