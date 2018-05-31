//
//  MineImportWalletVC.swift
//  BCPPurse
//
//  Created by tam on 2018/4/9.
//  Copyright © 2018年 Wilkinson. All rights reserved.
//

import UIKit
import SVProgressHUD
import ObjectMapper

class MineImportWalletVC: MainViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    lazy var backgroundVw: MineImportWalletVw = {
        let view = Bundle.main.loadNibNamed("MineImportWalletVw", owner: nil, options: nil)?.last as! MineImportWalletVw
        view.frame = CGRect(x: 0, y: 0 , width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
        view.importBtn.tag = 1
        view.importBtn.addTarget(self, action: #selector(onClick(_:)), for: .touchUpInside)
        view.forgetBtn.tag = 2
        view.forgetBtn.addTarget(self, action: #selector(onClick(_:)), for: .touchUpInside)
        view.backBtn.tag = 3
        view.backBtn.addTarget(self, action: #selector(onClick(_:)), for: .touchUpInside)
//        view.accountTF.keyboardType = .phonePad
        view.passwordTF.isSecureTextEntry = true
        view.passwordTF.keyboardType = .numbersAndPunctuation
        NotificationCenter.default.addObserver(self, selector: #selector(MineImportWalletVC.textFieldTextDidChangeOneCI), name:NSNotification.Name.UITextFieldTextDidChange, object: nil)
        return view
    }()
    
    lazy var importBtn: UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setTitle(LanguageHelper.getString(key: "homePage_Import"), for: .normal)
        btn.frame = CGRect(x: SCREEN_WIDTH - 15 - 70, y: 70, width: 70, height:30)
        btn.backgroundColor = UIColor.white
        btn.setTitleColor(UIColor.R_UIColorFromRGB(color: 0x545B71), for: .normal)
        btn.addTarget(self, action: #selector(onClick(_:)), for: .touchUpInside)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.layer.cornerRadius = 5
        btn.clipsToBounds = true
        btn.tag = 4
        return btn
    }()
    
}

extension MineImportWalletVC {
    
    @objc func onClick(_ sender:UIButton){
        if sender.tag == 1 {
            view.endEditing(true)
            let account = backgroundVw.accountTF.text!
            let password = backgroundVw.passwordTF.text!
            login(account: account, pwd: password)
        }else if sender.tag == 2 {
            let registervc = RegisterViewController()
            registervc.type = RegisterViewControllerType.forgetpwd
            navigationController?.pushViewController(registervc, animated: true)
        }else if sender.tag == 3 {
            self.navigationController?.popViewController(animated: true)
        }else if sender.tag == 4 {
            let importvc = FileSelectViewController()
            navigationController?.pushViewController(importvc, animated: true)
        }
    }
    
    @objc func textFieldTextDidChangeOneCI(){
        let account = backgroundVw.accountTF.text!
        let password = backgroundVw.passwordTF.text!
        backgroundVw.importBtn.isSelected = account != "" && password != "" && checkInpunt() ? true : false
        setImportStyle()
    }
    
    func setupUI(){
         view.addSubview(backgroundVw)
        if UIDevice.current.isX(){
            backgroundVw.frame.origin.y = -24
            backgroundVw.frame.size.height = SCREEN_HEIGHT + 24
        }
    }
    
    //设置状态
    func setImportStyle(){
        if backgroundVw.importBtn.isSelected {
            backgroundVw.importBtn.backgroundColor = R_UIThemeSkyBlueColor
            backgroundVw.importBtn.setTitleColor(UIColor.white, for: .normal)
            backgroundVw.importBtn.isUserInteractionEnabled = true
        }else {
            backgroundVw.importBtn.backgroundColor = UIColor.R_UIColorFromRGB(color: 0xDEDEDE)
            backgroundVw.importBtn.setTitleColor(UIColor.R_UIColorFromRGB(color: 0xBDBDBD), for: .normal)
            backgroundVw.importBtn.isUserInteractionEnabled = false
        }
    }
    
    func login(account: String, pwd: String) {
        let pwdmd5 = pwd.md5()
        let params = ["username" : account, "pwd":pwdmd5]
        SVProgressHUD.show(with: .black)
        ZYNetWorkTool.requestData(.post, URLString: ZYConstAPI.kAPILogin, language: true, parameters: params, showIndicator: true, success: { (jsonObjc) in
            SVProgressHUD.dismiss()
            let result = Mapper<LoginResponse>().map(JSONObject: jsonObjc)
            if let code = result?.code {
                if code == 200 {
                    SingleTon.shared.userInfo = result?.data
                    let dict = jsonObjc as! NSDictionary
                    if (dict.object(forKey: "data") != nil){
                        let userInfo = UserInfo(dict: dict.object(forKey: "data") as! [String : AnyObject])
                        UserDefaults.standard.saveCustomObject(customObject: userInfo, key: R_UserInfo)
                    }
                    UserDefaults.standard.setValue(account, forKey: "phone")
                    Tools.cacheLoginData(token: (result?.data?.token)!)
                    Tools.switchToMainViewController()
                } else {
                    SVProgressHUD.showInfo(withStatus: result?.message)
                }
            }
        }) { (error) in
            SVProgressHUD.dismiss()
        }
    }
    
    func checkInpunt()->Bool{
        let account = backgroundVw.accountTF.text!
        let pwd = backgroundVw.passwordTF.text!
        if Tools.validateEmail(email: account) == false && Tools.validateNewPhone(phone: account) == false {
            return false
        }
        
        if pwd.lengthOfBytes(using: .utf8) == 0 {
            return false
        }
        
        if Tools.validateNewPassword(pwd:pwd) == false {
            return false
        }
        return true
    }
}



