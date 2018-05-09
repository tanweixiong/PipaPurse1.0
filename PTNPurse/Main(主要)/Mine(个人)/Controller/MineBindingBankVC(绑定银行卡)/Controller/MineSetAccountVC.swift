//
//  MineSetAccountVC.swift
//  BCPPurse
//
//  Created by SKINK on 2018/4/16.
//  Copyright © 2018年 Wilkinson. All rights reserved.
//

import UIKit
import SVProgressHUD

enum MineSetAccountStyle{
    case alipayStyle
    case weChatStyle
}

class MineSetAccountVC: MainViewController {
    fileprivate lazy var viewModel : BaseViewModel = BaseViewModel()
    var style = MineSetAccountStyle.alipayStyle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        getData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    lazy var mineSetAccountVw: MineSetAccountVw = {
        let view = Bundle.main.loadNibNamed("MineSetAccountVw", owner: nil, options: nil)?.last as! MineSetAccountVw
        view.frame = CGRect(x: 0, y: MainViewControllerUX.naviNormalHeight, width: SCREEN_WIDTH, height: SCREEN_HEIGHT -  MainViewControllerUX.naviNormalHeight)
        view.titleLab.text = style == .alipayStyle ? LanguageHelper.getString(key: "binding_Alipay_account") : LanguageHelper.getString(key: "binding_Wechat_account")
        view.paymentMethodTF.placeholder = style == .alipayStyle ? LanguageHelper.getString(key: "binding_Please_enter_alipay_account") : LanguageHelper.getString(key: "binding_Please_enter_weChat_account")
        view.determineBtn.addTarget(self, action: #selector(onClick(_:)), for: .touchUpInside)
        view.determineBtn.setTitle(LanguageHelper.getString(key: "binding_Determine_binding"), for: .normal)
        NotificationCenter.default.addObserver(self, selector: #selector(MineSetAccountVC.textFieldTextDidChangeOneCI), name:NSNotification.Name.UITextFieldTextDidChange, object: nil)
        view.determineBtn.isEnabled = false
        return view
    }()
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UITextFieldTextDidChange, object: nil)
    }
    
}

extension MineSetAccountVC {
    func setupUI(){
        let title = style == .alipayStyle ? LanguageHelper.getString(key: "binding_Alipay_account") : LanguageHelper.getString(key: "binding_Wechat_account")
        setNormalNaviBar(title:title)
        view.backgroundColor = UIColor.R_UIRGBColor(red: 249, green: 249, blue: 251, alpha: 1)
        view.addSubview(mineSetAccountVw)
    }
    
    @objc func onClick(_ sender:UIButton){
          postData()
    }
    
    func postData(){
        let account = mineSetAccountVw.paymentMethodTF.text!
        let token = (UserDefaults.standard.getUserInfo().token)!
        let url = style == .alipayStyle ? ZYConstAPI.kAPIBindApay : ZYConstAPI.kAPIBindWeChat
        let type =  style == .alipayStyle ? "alipay" : "weChat"
        let parameters = ["token":token,type:account]
        viewModel.loadSuccessfullyReturnedData(requestType: .post, URLString: url, parameters: parameters, showIndicator: false) { (model:HomeBaseModel) in
            SVProgressHUD.showSuccess(withStatus:LanguageHelper.getString(key: "Added_Successfully"))
            let userInfo = UserDefaults.standard.getUserInfo()
            if self.style == .alipayStyle {
                userInfo.apay = account
            }else if self.style == .weChatStyle{
                userInfo.weChat = account
            }
            UserDefaults.standard.saveCustomObject(customObject: userInfo, key: R_UserInfo)
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: {
                self.navigationController?.popViewController(animated: true)
            })
        }
    }
    
    @objc func textFieldTextDidChangeOneCI(notification:NSNotification){
        if checkInput() {
            mineSetAccountVw.determineBtn.isSelected = true
            mineSetAccountVw.determineBtn.isEnabled = true
            mineSetAccountVw.determineBtn.backgroundColor = R_UIThemeColor
            mineSetAccountVw.determineBtn.setTitleColor(UIColor.white, for: .normal)
             mineSetAccountVw.determineBtn.layer.borderWidth = 0
        }else{
            mineSetAccountVw.determineBtn.isSelected = false
            mineSetAccountVw.determineBtn.isEnabled = false
            mineSetAccountVw.determineBtn.backgroundColor = UIColor.clear
            mineSetAccountVw.determineBtn.setTitleColor(UIColor.R_UIColorFromRGB(color: 0xCED7E6), for: .normal)
            mineSetAccountVw.determineBtn.layer.borderWidth = 1
        }
    }
    
    func checkInput()->Bool{
        let account:String = mineSetAccountVw.paymentMethodTF.text!
        if account.count > 0  {
            return true
        }
        return false
    }
    
    func getData(){
        if style == .alipayStyle {
            let alipay = UserDefaults.standard.getUserInfo().apay
            if alipay != nil && alipay != "" {
                mineSetAccountVw.paymentMethodTF.text = alipay
            }
        }else if style == .weChatStyle {
            let weChat = UserDefaults.standard.getUserInfo().weChat
            if weChat != nil && weChat != "" {
                mineSetAccountVw.paymentMethodTF.text = weChat
            }
        }
    }
    
}
