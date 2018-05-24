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
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UITextFieldTextDidChange, object: nil)
    }
}

extension MinePasswordVC {
    func setupUI(){
        setNormalNaviBar(title: LanguageHelper.getString(key: "login_loginpwd"))
        oldPasswordTF.placeholder = LanguageHelper.getString(key: "Mine_Modify_Old_Password")
        oldPasswordTF.textColor = UIColor.R_UIColorFromRGB(color: 0x545B71)
        newPasswordTF.placeholder = LanguageHelper.getString(key: "Mine_Modify_New_Password")
        newPasswordTF.textColor = UIColor.R_UIColorFromRGB(color: 0x545B71)
        repeatPasswordTF.placeholder = LanguageHelper.getString(key: "Mine_Modify_Repeat_Password")
        repeatPasswordTF.textColor = UIColor.R_UIColorFromRGB(color: 0x545B71)
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
            let parameters = ["token":token,"oldPwd":oldPasswordTF.text!,"newPwd":newPasswordTF.text!]
            viewModel.loadSuccessfullyReturnedData(requestType: .post, URLString: ZYConstAPI.kAPIModifyLoginPwd, parameters: parameters, showIndicator: false) { (model:HomeBaseModel) in
                if model.code == 200 {
                    SVProgressHUD.showSuccess(withStatus: LanguageHelper.getString(key: "password_changes_succeeded"))
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
        
        if oldPassword.count > 5 && oldPassword.count < 17 {
            return true
        }
        
        if newPassword.count > 5 && newPassword.count < 17 {
            return true
        }
        
        if repeatPassword.count > 5 && repeatPassword.count < 17 {
            return true
        }
        return false
    }
}














