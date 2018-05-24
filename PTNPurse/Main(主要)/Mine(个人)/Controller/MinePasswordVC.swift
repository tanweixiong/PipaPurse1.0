//
//  MinePasswordVC.swift
//  PipaPurse
//
//  Created by tam on 2018/5/24.
//  Copyright © 2018年 Wilkinson. All rights reserved.
//

import UIKit
import SVProgressHUD

class MinePasswordVC: MainViewController {
    fileprivate lazy var viewModel : BaseViewModel = BaseViewModel()
    @IBOutlet weak var oldPasswordTF: UITextField!
    @IBOutlet weak var newPasswordTF: UITextField!
    @IBOutlet weak var repeatPasswordTF: UITextField!
    @IBOutlet weak var determineBtn: UIButton!
    @IBOutlet weak var naviVw: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onClick(_ sender: UIButton) {
        getData()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UITextFieldTextDidChange, object: nil)
    }
}

extension MinePasswordVC {
    func setupUI(){
        setNormalNaviBar(title: LanguageHelper.getString(key: "login_loginpwd"))
        oldPasswordTF.placeholder = LanguageHelper.getString(key: "Mine_Modify_Old_Password")
        oldPasswordTF.textColor = UIColor.R_UIColorFromRGB(color: 0x545B71)
//        oldPasswordTF.isSecureTextEntry = true
        newPasswordTF.placeholder = LanguageHelper.getString(key: "Mine_Modify_New_Password")
        newPasswordTF.textColor = UIColor.R_UIColorFromRGB(color: 0x545B71)
        newPasswordTF.isSecureTextEntry = true
        repeatPasswordTF.placeholder = LanguageHelper.getString(key: "Mine_Modify_Repeat_Password")
        repeatPasswordTF.textColor = UIColor.R_UIColorFromRGB(color: 0x545B71)
        repeatPasswordTF.isSecureTextEntry = true
        determineBtn.setTitle(LanguageHelper.getString(key: "Mine_Modify_Determine_Password"), for: .normal)
        NotificationCenter.default.addObserver(self, selector: #selector(MinePasswordVC.textFieldTextDidChangeOneCI), name:NSNotification.Name.UITextFieldTextDidChange, object: nil)
    }
    
    @objc func textFieldTextDidChangeOneCI(noti:NSNotification){
        if checkInpunt() {
            determineBtn.isEnabled = true
            determineBtn.backgroundColor = R_UIThemeColor
        }else{
            determineBtn.isEnabled = false
            determineBtn.backgroundColor = UIColor.R_UIColorFromRGB(color: 0xCED7E6)
        }
    }
    
    func getData(){
        if newPasswordTF.text! == repeatPasswordTF.text! {
            let token = (UserDefaults.standard.getUserInfo().token)!
            let oldPwdMD5 = oldPasswordTF.text!.md5()
            let newPwdMD5 = newPasswordTF.text!.md5()
            let parameters = ["token":token,"oldPwd":oldPwdMD5,"newPwd":newPwdMD5]
            viewModel.loadSuccessfullyReturnedData(requestType: .post, URLString: ZYConstAPI.kAPIModifyLoginPwd, parameters: parameters, showIndicator: false) { (model:HomeBaseModel) in
                if model.code == 200 {
                    SVProgressHUD.showSuccess(withStatus: LanguageHelper.getString(key: "password_changes_succeeded"))
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: {
                         self.navigationController?.popViewController(animated: true)
                   })
            }}
        }else{
            SVProgressHUD.showInfo(withStatus:LanguageHelper.getString(key: "two_password_different"))
            return
        }
    }
    
    func checkInpunt()->Bool{
        let oldPassword = oldPasswordTF.text!
        let newPassword = newPasswordTF.text!
        let repeatPassword = repeatPasswordTF.text!
        
        if oldPassword.count < 6 || oldPassword.count > 16 {
            return false
        }
        
        if newPassword.count < 6 || newPassword.count > 16  {
            return false
        }
        
        if repeatPassword.count < 6 || repeatPassword.count > 16  {
            return false
        }
        return true
    }
}














