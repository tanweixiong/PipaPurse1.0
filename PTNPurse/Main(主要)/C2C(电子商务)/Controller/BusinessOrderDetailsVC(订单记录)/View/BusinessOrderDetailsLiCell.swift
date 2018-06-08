//
//  BusinessOrderDetailsLiCell.swift
//  PTNPurse
//
//  Created by tam on 2018/3/13.
//  Copyright © 2018年 Wilkinson. All rights reserved.
//

import UIKit

class BusinessOrderDetailsLiCell: UITableViewCell {
    @IBOutlet weak var headingLab: UILabel!
    @IBOutlet weak var headingContentLab: UILabel!
    @IBOutlet weak var backgroundVw: UIView!
    var businessaStyle = BusinessaDvertisementStyle.processingStyle
    
    func setData(heading:String,content:String){
        headingLab.text = heading + "："
        headingContentLab.text = content
    }
    
    //增加进行中的状态
    func setIncreaseState(model:BusinessOrderDetailsModel){
        //进行中状态
        //进行中需要
        self.headingLab.isHidden = true
        self.headingContentLab.isHidden = true
        if businessaStyle == .processingStyle {
            addSubview(contactBtn)
            addSubview(cancelOrderBtn)
            addSubview(remindBtn)
            setDetrimentStyle(model: model)
            contactBtn.isHidden = false
            cancelOrderBtn.isHidden = false
            remindBtn.isHidden = false
        }else{
            contactBtn.isHidden = true
            cancelOrderBtn.isHidden = true
            remindBtn.isHidden = true
        }
    }
    
    //分别设置两种状态
    func setDetrimentStyle(model:BusinessOrderDetailsModel){
        let status = model.state  //返回状态
        let style = model.dealType
        //买方
        if style == 0 {
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
            
            if status == 2 ||  status == 5 ||  status == 6 ||  status == 7 || status == 8{
                remindBtn.isHidden = true
                contactBtn.isHidden = false
                cancelOrderBtn.isHidden = true
            }
            //卖方
        }else if style == 1{
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
            
            if status == 2 ||  status == 5 ||  status == 6 ||  status == 7 || status == 8{
                remindBtn.isHidden = true
                contactBtn.isHidden = false
                cancelOrderBtn.isHidden = true
            }
        }
        setStartLayout()
        
        if style == 0 {
            //发布购买发起纠纷
            if status == 4{
                backgroundVw.addSubview(initiateDisputeBtn)
                initiateDisputeBtn.frame = CGRect(x: 23, y: 15, width: 95, height: 30)
                initiateDisputeBtn.isHidden = false
            }else if status == 6{
                backgroundVw.addSubview(initiateDisputeBtn)
                initiateDisputeBtn.frame = CGRect(x:SCREEN_WIDTH - 10 * 5 - 95 * 2 , y: 15, width: 95, height: 30)
                initiateDisputeBtn.isHidden = false
            }else{
                initiateDisputeBtn.isHidden = true
            }
        }else if style == 1 {
            //发布出售发起纠纷
            if  status == 4{
                backgroundVw.addSubview(initiateDisputeBtn)
                initiateDisputeBtn.frame = CGRect(x: 23, y: 15, width: 95, height: 30)
                initiateDisputeBtn.isHidden = false
            }else if status == 6 {
                backgroundVw.addSubview(initiateDisputeBtn)
                initiateDisputeBtn.frame = CGRect(x: SCREEN_WIDTH - 10 * 5 - 95 * 2 , y: 15, width: 95, height: 30)
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
            make.top.equalTo(self.snp.top).offset(15)
            make.width.equalTo(width)
            make.height.equalTo(30)
        }
        
        cancelOrderBtn.snp.updateConstraints { (make) in
            make.right.equalTo(self.remindBtn.snp.left).offset(right_x)
            make.top.equalTo(self.snp.top).offset(15)
            make.width.equalTo(cancelOrderWidth)
            make.height.equalTo(30)
        }
        
        contactBtn.snp.updateConstraints { (make) in
            make.right.equalTo(self.cancelOrderBtn.snp.left).offset(contact_x)
            make.top.equalTo(self.snp.top).offset(15)
            make.width.equalTo(contactWidth)
            make.height.equalTo(contactHeight)
        }
    }
    
    lazy var contactBtn: UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setTitle(LanguageHelper.getString(key: "C2C_mine_My_advertisement_Contact"), for: .normal)
        btn.frame = CGRect(x: 0, y: 15, width: 95, height:30)
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
        btn.frame = CGRect(x: 0, y: 15, width: 95, height:30)
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
        btn.frame = CGRect(x: 0, y: 15, width: 95, height:30)
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
        btn.setTitleColor(UIColor.R_UIColorFromRGB(color: 0xFF7052), for: .normal)
        btn.layer.borderColor = UIColor.R_UIColorFromRGB(color: 0xCFD3D5).cgColor
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        btn.layer.cornerRadius = 5
        btn.layer.masksToBounds = true
        btn.layer.borderWidth = 1
        btn.tag = 4
        return btn
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
