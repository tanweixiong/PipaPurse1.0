//
//  BusinessaDvertisementCell.swift
//  PTNPurse
//
//  Created by tam on 2018/3/13.
//  Copyright © 2018年 Wilkinson. All rights reserved.
//

import UIKit

enum BusinessaDvertisementCellStyle {
    case detriment
    case sell
}
class BusinessaDvertisementCell: UITableViewCell {
    var businessaStyle = BusinessaDvertisementStyle.processingStyle
    fileprivate var style = BusinessaDvertisementCellStyle.detriment
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
            transactionNumLab.text = Tools.setPriceNumber(price: dealNum!) + " " + LanguageHelper.getString(key: "homePage_Numbers")
            
            //状态，0：匹配中，1：已完成，2：撤销，3：等待买方付款，4：等待卖方确认，5：未付款回滚订单，6：纠纷强制打款，7：纠纷强制回滚
            //交易状态
            transactionStatusLab.text = Tools.getBusinessaTransactionStyle(Style: (model?.state?.stringValue)!)

            //交易状态
            var dealType = String()
            switch (model?.dealType?.intValue)! {
            case 0:
                dealType = LanguageHelper.getString(key: "C2C_mine_My_advertisement_Buy")
                statusLab.backgroundColor = UIColor.R_UIRGBColor(red: 65, green: 71, blue: 237, alpha: 1)
                self.style = .detriment
            case 1:
                dealType = LanguageHelper.getString(key: "C2C_mine_My_advertisement_Sell")
                statusLab.backgroundColor = UIColor.R_UIColorFromRGB(color: 0xFE7644)
                self.style = .sell
            default: break
            }
            statusLab.text = dealType
            
            //进行中需要
            if businessaStyle == .processingStyle {
               addSubview(self.contactBtn)
               addSubview(self.cancelOrderBtn)
               addSubview(self.remindBtn)
               setDetrimentStyle()
               contactBtn.isHidden = false
               cancelOrderBtn.isHidden = false
               remindBtn.isHidden = false
            }
            
            transactionUnitTitleLab.text = LanguageHelper.getString(key: "C2C_mine_My_advertisement_Unit") + "："
            transactionNumTitleLab.text = LanguageHelper.getString(key: "C2C_mine_My_advertisement_Quantity") + "："
            transactionStatusTitleLab.text = LanguageHelper.getString(key: "C2C_mine_My_advertisement_Status") + "："
        }
    }
    
    //分别设置两种状态
    func setDetrimentStyle(){
        let status = model?.state  //返回状态
        //买方
        if style == .detriment {
            //等待买方确认
            if status == 3 {
                remindBtn.setTitle(LanguageHelper.getString(key: "C2C_transaction_Confirm_payment"), for: .normal)
                remindBtn.setTitleColor(UIColor.R_UIColorFromRGB(color: 0xFE7644), for: .normal)
            //等待卖方确认
            }else if status == 4 {
                remindBtn.setTitle(LanguageHelper.getString(key: "C2C_transaction_Remind_pay"), for: .normal)
                remindBtn.setTitleColor(UIColor.R_UIColorFromRGB(color: 0xFE7644), for: .normal)
                cancelOrderBtn.isHidden = true
            //已完成
            }else if status == 1 {
                remindBtn.isHidden = true
                contactBtn.isHidden = true
                cancelOrderBtn.isHidden = true
            }
        //卖方
        }else if style == .sell{
            if status == 3 {
                remindBtn.isUserInteractionEnabled = false
                remindBtn.isHidden = true
            } else if status == 4 {
                remindBtn.setTitle(LanguageHelper.getString(key: "C2C_transaction_Confirm_payments"), for: .normal)
                remindBtn.setTitleColor(UIColor.R_UIColorFromRGB(color: 0xFE7644), for: .normal)
                cancelOrderBtn.isHidden = true
            }else if status == 1{
                remindBtn.isHidden = true
                contactBtn.isHidden = true
                cancelOrderBtn.isHidden = true
            }
        }
        setStartLayout()
        //发起纠纷
        if style == .sell && status == 4{
            backgroundVw.addSubview(initiateDisputeBtn)
            initiateDisputeBtn.frame = CGRect(x: 23, y: self.transactionStatusTitleLab.frame.maxY + 20, width: 95, height: 30)
        }else{
             initiateDisputeBtn.isHidden = true
        }
    }
    
    //进行中状态
    func setStartLayout(){
        let width = remindBtn.isHidden == true ? 0 : 95
        let right_x = remindBtn.isHidden == true ? 0 : -10
        
        let cancelOrderWidth = cancelOrderBtn.isHidden == true ? 0 : 95
        let contact_x = cancelOrderBtn.isHidden == true ? 0 : -10
        
        let contactWidth = contactBtn.isHidden == true ? 0 : 95
        let contactHeight =  contactBtn.isHidden == true ? 0 : 30
        
        remindBtn.snp.updateConstraints { (make) in
            make.right.equalTo(self.backgroundVw.snp.right).offset(-15)
            make.top.equalTo(self.transactionStatusTitleLab.snp.bottom).offset(20)
            make.width.equalTo(width)
            make.height.equalTo(30)
        }
        
        cancelOrderBtn.snp.updateConstraints { (make) in
            make.right.equalTo(self.remindBtn.snp.left).offset(right_x)
            make.top.equalTo(self.transactionStatusTitleLab.snp.bottom).offset(20)
            make.width.equalTo(cancelOrderWidth)
            make.height.equalTo(30)
        }
        
        contactBtn.snp.updateConstraints { (make) in
            make.right.equalTo(self.cancelOrderBtn.snp.left).offset(contact_x)
            make.top.equalTo(self.transactionStatusTitleLab.snp.bottom).offset(20)
            make.width.equalTo(contactWidth)
            make.height.equalTo(contactHeight)
        }
    }
    
    lazy var contactBtn: UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setTitle(LanguageHelper.getString(key: "C2C_mine_My_advertisement_Contact"), for: .normal)
        btn.frame = CGRect(x: 0, y: transactionStatusTitleLab.frame.maxY, width: 95, height:30)
        btn.setTitleColor(UIColor.R_UIColorFromRGB(color: 0xCFD3D5), for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        btn.layer.cornerRadius = 5
        btn.layer.masksToBounds = true
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor.R_UIColorFromRGB(color: 0xCFD3D5).cgColor
        btn.tag = 1
        return btn
    }()
    
    lazy var cancelOrderBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setTitle(LanguageHelper.getString(key: "C2C_mine_My_advertisement_Cancel"), for: .normal)
        btn.frame = CGRect(x: 0, y: transactionStatusTitleLab.frame.maxY, width: 95, height:30)
        btn.setTitleColor(UIColor.R_UIColorFromRGB(color: 0xCFD3D5), for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        btn.layer.cornerRadius = 5
        btn.layer.masksToBounds = true
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor.R_UIColorFromRGB(color: 0xCFD3D5).cgColor
        btn.tag = 2
        return btn
    }()
    
    lazy var remindBtn: UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setTitle(LanguageHelper.getString(key: "C2C_transaction_Confirm_Order"), for: .normal)
        btn.frame = CGRect(x: 0, y: transactionStatusTitleLab.frame.maxY, width: 95, height:30)
        btn.setTitleColor(UIColor.R_UIColorFromRGB(color: 0xCFD3D5), for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        btn.layer.cornerRadius = 5
        btn.layer.masksToBounds = true
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor.R_UIColorFromRGB(color: 0xCFD3D5).cgColor
        btn.tag = 3
        return btn
    }()
    
    lazy var initiateDisputeBtn: UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setTitle(LanguageHelper.getString(key: "C2C_transaction_initiate_Dispute"), for: .normal)
        btn.setTitleColor(R_UIThemeColor, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        btn.layer.cornerRadius = 5
        btn.layer.masksToBounds = true
        btn.layer.borderWidth = 1
        btn.layer.borderColor = R_UIThemeColor.cgColor
        btn.tag = 120
        return btn
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        Tools.setViewShadow(backgroundVw)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
