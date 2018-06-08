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
    @IBOutlet weak var transactionSumLab: UILabel!
    @IBOutlet weak var transactionPaymentLab: UILabel!
    @IBOutlet weak var transactionPaymentX: NSLayoutConstraint!
    
    @IBOutlet weak var orderNumTLab: UILabel!
    @IBOutlet weak var orderTypeTLab: UILabel!
    @IBOutlet weak var orderUnitLab: UILabel!
    @IBOutlet weak var orderNumberLab: UILabel!
    @IBOutlet weak var orderTimeLab: UILabel!
    @IBOutlet weak var orderSumLab: UILabel!
    @IBOutlet weak var orderPaymentLab: UILabel!
    
    @IBOutlet weak var paymentCodeBtn: UIButton!
    @IBOutlet weak var backgroundVw: UIView!
    @IBOutlet weak var codeImageVw: UIButton!
    @IBOutlet weak var statusVw: UIView!
    var model = BusinessaDvertisementModel(){
        didSet{
            let photo = model?.photo == nil ? "" :  model?.photo
            photoImageVw.sd_setImage(with:NSURL(string: photo!)! as URL, placeholderImage: UIImage.init(named: "ic_defaultPicture"))
            
            let name = model?.username == nil ? "" : model?.username
            usernameLab.text = name!
            
            //状态，0：匹配中，1：已完成，2：撤销，3：等待买方付款，4：等待卖方确认，5：未付款回滚订单，6：纠纷强制打款，7：纠纷强制回滚
            stateLab.text = Tools.getBusinessaTransactionStyle(Style: (model?.state?.stringValue)!)
            
            orderNumLab.text = model?.orderNo == nil ? "" : (model?.orderNo)!
            
            transactionTypeLab.text = model?.dealType == 0 ? LanguageHelper.getString(key: "C2C_home_Buy") : LanguageHelper.getString(key: "C2C_home_Sell")  + (model?.coinCore)!
            transactionTypeLab.textColor = model?.dealType == 0 ? UIColor.R_UIColorFromRGB(color: 0xFF7052) : UIColor.R_UIColorFromRGB(color: 0x00D85A)
            
            transactionPriceLab.text = Tools.setNSDecimalNumber((model?.dealPrice)!) + " CNY"
            
            transactionCoinPriceLab.text = Tools.setNSDecimalNumber((model?.dealNum)!) + " 个"
            
            transactionDataLab.text = model?.date == nil ? "" : model?.date
            
            transactionSumLab.text = Tools.setNSDecimalNumber((model?.sumPrice)!) + " CNY"
            
            transactionPaymentLab.text = Tools.getPaymentDetailsMethod((model?.receivablesType?.stringValue)!)
            
            style = model?.dealType == 0 ? .detriment : .sell
            
            if model?.receivablesType == 1 {
                codeImageVw.isHidden = true
                paymentCodeBtn.isHidden = true
                transactionPaymentX.constant = -15
            }else{
                codeImageVw.isHidden = false
                paymentCodeBtn.isHidden = false
                transactionPaymentX.constant = 5
                if model?.receivablesType == 2 {
                    codeImageVw.setImage(UIImage.init(named: "ic_AlipayCode"), for: .normal)
                }else if model?.receivablesType == 3{
                    codeImageVw.setImage(UIImage.init(named: "ic_WechatCode"), for: .normal)
                }
            }
   
            //进行中需要
            addSubview(self.contactBtn)
            addSubview(self.cancelOrderBtn)
            addSubview(self.remindBtn)
            setDetrimentStyle()
            contactBtn.isHidden = false
            cancelOrderBtn.isHidden = false
            remindBtn.isHidden = false
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
                remindBtn.setTitleColor(R_UIThemeColor, for: .normal)
            //等待卖方确认
            }else if status == 4 {
                remindBtn.setTitle(LanguageHelper.getString(key: "C2C_transaction_Remind_pay"), for: .normal)
                remindBtn.setTitleColor(R_UIThemeColor, for: .normal)
                cancelOrderBtn.isHidden = true
            //已完成
            }else if status == 1{
                remindBtn.isHidden = true
                contactBtn.isHidden = true
                cancelOrderBtn.isHidden = true
            }
            
            if status == 2 ||  status == 5 ||  status == 6 ||  status == 7 || status == 8{
                remindBtn.isHidden = true
                contactBtn.isHidden = false
                cancelOrderBtn.isHidden = true
            }
        //卖方
        }else if style == .sell{
            if status == 3 {
                remindBtn.isUserInteractionEnabled = false
                remindBtn.isHidden = true
            } else if status == 4 {
                remindBtn.setTitle(LanguageHelper.getString(key: "C2C_transaction_Confirm_payments"), for: .normal)
                remindBtn.setTitleColor(R_UIThemeColor, for: .normal)
                cancelOrderBtn.isHidden = true
            }else if status == 1{
                remindBtn.isHidden = true
                contactBtn.isHidden = true
                cancelOrderBtn.isHidden = true
            }
            
            if status == 2 ||  status == 5 ||  status == 6 ||  status == 7 || status == 8{
                remindBtn.isHidden = true
                contactBtn.isHidden = false
                cancelOrderBtn.isHidden = true
            }
        }
        setStartLayout()
        
         //发布购买发起纠纷
        if style == .sell {
            if  status == 4{
                statusVw.addSubview(initiateDisputeBtn)
                initiateDisputeBtn.frame = CGRect(x: 23, y: orderPaymentLab.frame.maxY + 10, width: 95, height: 30)
                initiateDisputeBtn.isHidden = false
            }else if status == 6{
                statusVw.addSubview(initiateDisputeBtn)
                initiateDisputeBtn.frame = CGRect(x: SCREEN_WIDTH - 10 * 5 - 95 * 2  , y: orderPaymentLab.frame.maxY + 10, width: 95, height: 30)
                initiateDisputeBtn.isHidden = false
            }else{
                 initiateDisputeBtn.isHidden = true
            }
            
        }else if style == .detriment{
            if status == 4{
                statusVw.addSubview(initiateDisputeBtn)
                initiateDisputeBtn.frame = CGRect(x: 23, y: orderPaymentLab.frame.maxY + 10, width: 95, height: 30)
                initiateDisputeBtn.isHidden = false
            }else if status == 6 {
                statusVw.addSubview(initiateDisputeBtn)
                initiateDisputeBtn.frame = CGRect(x: SCREEN_WIDTH - 10 * 5 - 95 * 2 , y: orderPaymentLab.frame.maxY + 10, width: 95, height: 30)
                initiateDisputeBtn.isHidden = false
            }else{
                initiateDisputeBtn.isHidden = true
            }
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
            make.top.equalTo(self.orderPaymentLab.snp.bottom).offset(10)
            make.width.equalTo(width)
            make.height.equalTo(30)
        }
        
        cancelOrderBtn.snp.updateConstraints { (make) in
            make.right.equalTo(self.remindBtn.snp.left).offset(right_x)
            make.top.equalTo(self.orderPaymentLab.snp.bottom).offset(10)
            make.width.equalTo(cancelOrderWidth)
            make.height.equalTo(30)
        }
        
        contactBtn.snp.updateConstraints { (make) in
            make.right.equalTo(self.cancelOrderBtn.snp.left).offset(contact_x)
            make.top.equalTo(self.orderPaymentLab.snp.bottom).offset(10)
            make.width.equalTo(contactWidth)
            make.height.equalTo(contactHeight)
        }
    }
    
    lazy var contactBtn: UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setTitle(LanguageHelper.getString(key: "C2C_mine_My_advertisement_Contact"), for: .normal)
        btn.frame = CGRect(x: 0, y: 0, width: 95, height:30)
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
        btn.frame = CGRect(x: 0, y: 0, width: 95, height:30)
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
        btn.frame = CGRect(x: 0, y: 0, width: 95, height:30)
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
        btn.setTitleColor(UIColor.R_UIColorFromRGB(color: 0xCFD3D5), for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        btn.layer.cornerRadius = 5
        btn.layer.masksToBounds = true
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor.R_UIColorFromRGB(color: 0xCFD3D5).cgColor
        btn.tag = 120
        return btn
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        Tools.setViewShadow(backgroundVw)
        
        orderTypeTLab.text = LanguageHelper.getString(key: "homePage_Finish_Details_Transaction_Type") + "："
        orderUnitLab.text = LanguageHelper.getString(key: "C2C_mine_My_advertisement_Unit") + "："
        orderNumberLab.text = LanguageHelper.getString(key: "C2C_mine_My_advertisement_Quantity") + "："
        orderTimeLab.text = LanguageHelper.getString(key: "homePage_Finish_Details_Transaction_Time") + "："
        orderNumTLab.text = LanguageHelper.getString(key: "C2C_transaction_finish_OrderNum") + "："
        orderSumLab.text = LanguageHelper.getString(key: "Mine_Transaction_SumPrice") + "："
        orderPaymentLab.text =  LanguageHelper.getString(key: "C2C_payment_method") + "："
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
