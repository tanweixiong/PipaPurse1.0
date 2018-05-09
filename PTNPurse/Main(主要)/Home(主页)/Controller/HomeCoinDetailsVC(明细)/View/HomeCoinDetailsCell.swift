//
//  HomeCoinDetailsCell.swift
//  PTNPurse
//
//  Created by tam on 2018/1/17.
//  Copyright © 2018年 Wilkinson. All rights reserved.
//

import UIKit

class HomeCoinDetailsCell: UITableViewCell {
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var dataLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var backgroundVw: UIView!
    @IBOutlet weak var unitLabel: UILabel!
    
    @IBOutlet weak var lineCenterY: NSLayoutConstraint!
    @IBOutlet weak var relDetailsView: UIView!
    @IBOutlet weak var convertedQuantityLabel: UILabel!
    @IBOutlet weak var frozenQuantityLabel: UILabel!
    @IBOutlet weak var freedView: UIView!
    
    var model = HomeCoinDetailsModel(){
        didSet{
            //接收
            if model?.type == 0  {
                lineView.backgroundColor = UIColor.R_UIColorFromRGB(color: 0xFF4757)
                numberLabel.textColor = UIColor.R_UIColorFromRGB(color: 0xFF4757)
                self.statusLabel.text = LanguageHelper.getString(key: "homePage_Details_Turn_Into")
            }else{
                lineView.backgroundColor = UIColor.R_UIColorFromRGB(color: 0x2FD574)
                numberLabel.textColor = UIColor.R_UIColorFromRGB(color: 0x545B71)
                self.statusLabel.text = LanguageHelper.getString(key: "homePage_Details_Turn_Out")
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
            var price = String()
//            0：转出，1：转入
            if transferModel?.changeFlag == 1 {
                lineView.backgroundColor = UIColor.R_UIColorFromRGB(color: 0x2FD574)
                numberLabel.textColor = UIColor.R_UIColorFromRGB(color: 0x2FD574)
                //单位
                unitLabel.text = (transferModel?.inCoinName!)!
                price = transferModel?.pnt == nil ? "0" : (transferModel?.pnt?.stringValue)!
            }else {
                //转账
                lineView.backgroundColor = UIColor.R_UIColorFromRGB(color: 0xFF4757)
                numberLabel.textColor = UIColor.R_UIColorFromRGB(color: 0xFF4757)
                //单位
                unitLabel.text = (transferModel?.outCoinName!)!
                price = transferModel?.coinNum == nil ? "0" : (transferModel?.coinNum?.stringValue)!
            }
            
            let changeStyle = transferModel?.changeFlag == 0 ? "-" : "+"
            numberLabel.text = changeStyle + price
            
            self.statusLabel.text = (transferModel?.outCoinName!)! + LanguageHelper.getString(key: "homePage_Details_Conversion_List_Data") + (transferModel?.inCoinName!)!
            
            let data = transferModel?.dateString == nil ? "" : transferModel?.dateString
            self.dataLabel.text = data
            
            
            let frozenAssets = transferModel?.frozenAssets == nil ? "0" : (transferModel?.frozenAssets?.stringValue)!
            let available = transferModel?.available == nil ? "0" : (transferModel?.available?.stringValue)!
            relDetailsView.isHidden = false
            lineCenterY.constant = -10
            convertedQuantityLabel.text = "可用:" + available
            frozenQuantityLabel.text = "冻结:" + frozenAssets
            
            let percentage = transferModel?.percentage == nil ? 0 : transferModel?.percentage
            let frozenWidth = SCREEN_WIDTH - 30 - 21 - 13
            frozenScheduleView.frame.size.width = CGFloat((percentage?.floatValue)! * 0.01 * Float(frozenWidth))
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        freedView.backgroundColor = UIColor.R_UIRGBColor(red: 205, green: 216, blue: 229, alpha: 1)
        Tools.setViewShadow(backgroundVw)
    }

    lazy var frozenScheduleView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 0, height:freedView.frame.size.height))
        view.backgroundColor = UIColor.R_UIColorFromRGB(color: 0xFE7644)
        freedView.addSubview(view)
        return view
    }()
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
