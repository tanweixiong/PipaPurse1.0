//
//  HomeCoinDetailsCell.swift
//  PTNPurse
//
//  Created by tam on 2018/1/17.
//  Copyright © 2018年 Wilkinson. All rights reserved.
//

import UIKit

class HomeCoinDetailsCell: UITableViewCell {
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var dataLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var backgroundVw: UIView!
    @IBOutlet weak var unitLabel: UILabel!
    @IBOutlet weak var statusBtn: UIButton!
    
    var model = HomeCoinDetailsModel(){
        didSet{
            backgroundVw.layer.borderWidth = 1
            //接收
            if model?.type == 0  {
                numberLabel.textColor = UIColor.R_UIColorFromRGB(color: 0xFF4757)
                statusLabel.text = LanguageHelper.getString(key: "homePage_Details_Turn_Into")
                
                backgroundVw.backgroundColor = UIColor.R_UIColorFromRGB(color: 0xFFE1DB)
                statusLabel.textColor =  UIColor.R_UIColorFromRGB(color: 0xFF7052)
                numberLabel.textColor =  UIColor.R_UIColorFromRGB(color: 0xFF7052)
                statusBtn.backgroundColor = UIColor.R_UIColorFromRGB(color: 0xFF7052)
                backgroundVw.layer.borderColor = UIColor.R_UIColorFromRGB(color: 0xFF7052).cgColor
            }else{
                numberLabel.textColor = UIColor.R_UIColorFromRGB(color: 0x545B71)
                statusLabel.text = LanguageHelper.getString(key: "homePage_Details_Turn_Out")
                
                backgroundVw.backgroundColor = UIColor.R_UIColorFromRGB(color: 0xE9F9F0)
                statusLabel.textColor = UIColor.R_UIColorFromRGB(color: 0x00D85A)
                numberLabel.textColor =  UIColor.R_UIColorFromRGB(color: 0x00D85A)
                statusBtn.backgroundColor = UIColor.R_UIColorFromRGB(color: 0x00D85A)
                backgroundVw.layer.borderColor = UIColor.R_UIColorFromRGB(color: 0x2DC76D).cgColor
            }
            
            let date = model?.date == nil ? "" : model?.date
            self.dataLabel.text = date
            
            let number = Tools.setNSDecimalNumber(model?.tradeNum == nil ? 0 : (model?.tradeNum)!)
            let type = model?.type == 0 ? "+" : "-"
            numberLabel.text = type + number
        }
    }
    
    var transferModel = HomeCoinTransferDetailsModel(){
        didSet{
  
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
