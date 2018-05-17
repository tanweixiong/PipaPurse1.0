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
        view.paymentMethodTF.placeholder = style == .alipayStyle ? LanguageHelper.getString(key: "binding_Please_enter_alipay_account") : LanguageHelper.getString(key: "binding_Please_enter_weChat_account")
        view.titleLab.text = style == .alipayStyle ? LanguageHelper.getString(key: "binding_Alipay_account_settings") : LanguageHelper.getString(key: "binding_WeChat_account_settings")
        NotificationCenter.default.addObserver(self, selector: #selector(MineSetAccountVC.textFieldTextDidChangeOneCI), name:NSNotification.Name.UITextFieldTextDidChange, object: nil)
        return view
    }()
    
    //33 32
    lazy var submitBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.frame = CGRect(x: SCREEN_WIDTH - 15 - 34, y: 32, width: 34, height: 22)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        btn.setTitleColor(UIColor.R_UIColorFromRGB(color: 0xBDBDBD), for: .normal)
        btn.setTitleColor(UIColor.white, for: .selected)
        btn.setTitle(LanguageHelper.getString(key: "save"), for: .normal)
        btn.isEnabled = false
        btn.addTarget(self, action: #selector(onClick(_:)), for: .touchUpInside)
        return btn
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
        view.addSubview(submitBtn)
    }
    
    @objc func onClick(_ sender:UIButton){
        if Tools.noPaymentPasswordIsSetToExecute() == false{view.endEditing(true)
            return
        }
        let input = PaymentPasswordVw(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        input?.delegate = self
        input?.show()
    }
    
    func postData(dealPwd:String){
        let account = mineSetAccountVw.paymentMethodTF.text!
        let token = (UserDefaults.standard.getUserInfo().token)!
        let url = style == .alipayStyle ? ZYConstAPI.kAPIBindApay : ZYConstAPI.kAPIBindWeChat
        let type =  style == .alipayStyle ? "alipay" : "weChat"
        let dealPwd = dealPwd.md5()
        let parameters = ["token":token,type:account,"dealPwd":dealPwd]
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
         setTextfieldStyle()
    }
    
    func setTextfieldStyle(){
        if checkInput() {
            submitBtn.isEnabled = true
            submitBtn.isSelected = true
        }else{
            submitBtn.isEnabled = false
            submitBtn.isSelected = false
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
        setTextfieldStyle()
    }
}

extension MineSetAccountVC:PaymentPasswordDelegate{
    func inputPaymentPassword(_ pwd: String!) -> String! {
        postData(dealPwd: pwd)
        return pwd
    }
    
    func inputPaymentPasswordChangeForgetPassword() {
        let forgetvc = ModifyTradePwdViewController()
        forgetvc.type = ModifyPwdType.tradepwd
        forgetvc.status = .modify
        forgetvc.isNeedNavi = false
        self.navigationController?.pushViewController(forgetvc, animated: true)
    }
}

