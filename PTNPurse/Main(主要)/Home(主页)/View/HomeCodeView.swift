//
//  HomeCodeView.swift
//  PTNPurse
//
//  Created by tam on 2018/1/25.
//  Copyright © 2018年 Wilkinson. All rights reserved.
//

import UIKit

class HomeCodeView: UIView {
    @IBOutlet weak var codeImageView: UIImageView!
    @IBOutlet weak var codeBackgroundVw: UIView!
    @IBOutlet weak var codeLab: UILabel!
    @IBOutlet weak var paymentVw: UIView!
    @IBOutlet weak var paymentLab: UILabel!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var codeVwBottom: NSLayoutConstraint!
    
    var style = BusinessTransactionStyle.buyStyle
    var orderModel = BusinessaDvertisementModel(){
        didSet{
            if orderModel?.receivablesType == 2 || orderModel?.receivablesType == 3 {
                paymentVw.isHidden = false
                var placeholderImg = String()
                //支付宝
                if orderModel?.receivablesType == 2 {
                    paymentVw.backgroundColor = UIColor.R_UIColorFromRGB(color: 0x78CBFC)
                    saveBtn.backgroundColor = UIColor.R_UIColorFromRGB(color: 0x359CDF)
                    paymentLab.text = LanguageHelper.getString(key: "Mine_Order_Alipay_account") + "："
                    if let alipayAccount = UserDefaults.standard.getUserInfo().apay {
                        paymentLab.text = LanguageHelper.getString(key: "Mine_Order_Alipay_account") + "：" + alipayAccount
                    }
                    placeholderImg = "ic_AlipayCode"
                    //微信
                }else if orderModel?.receivablesType == 3 {
                    paymentVw.backgroundColor = UIColor.R_UIColorFromRGB(color: 0x7AE9A9)
                    saveBtn.backgroundColor = UIColor.R_UIColorFromRGB(color: 0x6BE28A)
                    paymentLab.text = LanguageHelper.getString(key: "Mine_Order_WeChat_account") + "："
                    if let weChatAccount = UserDefaults.standard.getUserInfo().weChat {
                        paymentLab.text = LanguageHelper.getString(key: "Mine_Order_WeChat_account") + "：" + weChatAccount
                    }
                    placeholderImg = "ic_WechatCode"
                }
                
                
                if style == .buyStyle {
                    if let url = orderModel?.sellAccountUrl {
                      codeImageView.sd_setImage(with: (NSURL(string: url)! as URL), placeholderImage:UIImage.init(named: placeholderImg))
                    }
                    
                    let text = orderModel?.receivablesType == 2 ? LanguageHelper.getString(key: "Mine_Order_Alipay_account") : LanguageHelper.getString(key: "Mine_Order_WeChat_account")
                    
                    if let sellAccount = orderModel?.sellAccount {
                        paymentLab.text = text + "：" + sellAccount
                    }
                    
                }else if style == .sellStyle {
                    if let url = orderModel?.buyAccountUrl {
                        codeImageView.sd_setImage(with: (NSURL(string: url)! as URL), placeholderImage:UIImage.init(named: placeholderImg))
                    }
                    
                    let text = orderModel?.receivablesType == 2 ? LanguageHelper.getString(key: "Mine_Order_Alipay_account") : LanguageHelper.getString(key: "Mine_Order_WeChat_account")
                    
                    if let sellAccount = orderModel?.buyAccount {
                        paymentLab.text = text + "：" + sellAccount
                    }
                }
            }
        }
    }
    
    @IBAction func isHideCodeView(_ sender: UIButton) {
        UIView.animate(withDuration: 0.5, animations: {
            self.codeBackgroundVw.alpha = 0
            self.codeBackgroundVw.frame = CGRect(x: 30, y: SCREEN_HEIGHT - self.codeBackgroundVw.frame.size.height , width: self.codeBackgroundVw.frame.size.width, height: self.codeBackgroundVw.frame.size.height)
        }, completion: { (isfinish:Bool) in
            self.isHidden = !self.isHidden
        })
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        codeLab.text = LanguageHelper.getString(key: "homePage_Scan_Address")
    }
}
