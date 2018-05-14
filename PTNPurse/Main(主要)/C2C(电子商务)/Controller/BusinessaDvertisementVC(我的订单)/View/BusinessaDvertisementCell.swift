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
    @IBOutlet weak var photoImageVw: UIImageView!
    @IBOutlet weak var usernameLab: UILabel!
    @IBOutlet weak var stateLab: UILabel!
    
    @IBOutlet weak var orderNumLab: UILabel!
    @IBOutlet weak var transactionTypeLab: UILabel!
    @IBOutlet weak var transactionPriceLab: UILabel!
    @IBOutlet weak var transactionCoinPriceLab: UILabel!
    @IBOutlet weak var transactionDataLab: UILabel!
    @IBOutlet weak var backgroundVw: UIView!
    
    var model = BusinessaDvertisementModel(){
        didSet{
            let photo = model?.photo == nil ? "" :  model?.photo
            photoImageVw.sd_setImage(with:NSURL(string: photo!)! as URL, placeholderImage: UIImage.init(named: "ic_defaultPicture"))
            
            let name = model?.username == nil ? "" : model?.username
            usernameLab.text = name!
            
            //状态，0：匹配中，1：已完成，2：撤销，3：等待买方付款，4：等待卖方确认，5：未付款回滚订单，6：纠纷强制打款，7：纠纷强制回滚
            //交易状态
            stateLab.text = Tools.getBusinessaTransactionStyle(Style: (model?.state?.stringValue)!)
            
            //价格
            let sumPrice = model?.sumPrice == nil ? 0 : model?.sumPrice
            transactionPriceLab.text = Tools.setPriceNumber(price: sumPrice!) + " CNY"

            //单价
            let unitPrice = model?.dealPrice == nil ? 0 : model?.dealPrice
            transactionPriceLab.text = Tools.setPriceNumber(price: unitPrice!) + " CNY"
            
            orderNumLab.text = "12312"
            
            transactionTypeLab.text = "出售BTC"
            
            transactionPriceLab.text = "5000 CNY"
            
            transactionCoinPriceLab.text = "0.29 BTC"
            
            transactionDataLab.text = model?.dateFormatDate
    

            //交易状态
            switch (model?.dealType?.intValue)! {
            //0购买
            case 0:
                self.style = .detriment
                transactionTypeLab.textColor = UIColor.R_UIColorFromRGB(color: 0xFF7052)
            case 1:
                self.style = .sell
                transactionTypeLab.textColor = UIColor.R_UIColorFromRGB(color: 0x00D85A)
            default: break
            }
   
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
            initiateDisputeBtn.frame = CGRect(x: 23, y: self.transactionDataLab.frame.maxY + 20, width: 95, height: 30)
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
            make.top.equalTo(self.transactionDataLab.snp.bottom).offset(20)
            make.width.equalTo(width)
            make.height.equalTo(30)
        }
        
        cancelOrderBtn.snp.updateConstraints { (make) in
            make.right.equalTo(self.remindBtn.snp.left).offset(right_x)
            make.top.equalTo(self.transactionDataLab.snp.bottom).offset(20)
            make.width.equalTo(cancelOrderWidth)
            make.height.equalTo(30)
        }
        
        contactBtn.snp.updateConstraints { (make) in
            make.right.equalTo(self.cancelOrderBtn.snp.left).offset(contact_x)
            make.top.equalTo(self.transactionDataLab.snp.bottom).offset(20)
            make.width.equalTo(contactWidth)
            make.height.equalTo(contactHeight)
        }
    }
    
    lazy var contactBtn: UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setTitle(LanguageHelper.getString(key: "C2C_mine_My_advertisement_Contact"), for: .normal)
        btn.frame = CGRect(x: 0, y: transactionDataLab.frame.maxY, width: 95, height:30)
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
        btn.frame = CGRect(x: 0, y: transactionDataLab.frame.maxY, width: 95, height:30)
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
        btn.frame = CGRect(x: 0, y: transactionDataLab.frame.maxY, width: 95, height:30)
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
