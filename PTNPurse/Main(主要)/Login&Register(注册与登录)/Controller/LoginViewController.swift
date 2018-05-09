//
//  LoginViewController.swift
//  rryproject
//
//  Created by zhengyi on 2018/1/11.
//  Copyright © 2018年 inesv. All rights reserved.
//

import UIKit
import SVProgressHUD
import ObjectMapper

class LoginViewController: UIViewController {
    
    @IBOutlet weak var topImageView: UIImageView!
    @IBOutlet weak var nameTextView: LoginTextFieldView!
    @IBOutlet weak var pwdTextView: LoginTextFieldView!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var registerBtn: UIButton!  // 创建钱包
    @IBOutlet weak var forgetPwdBtn: UIButton! //导入钱包
    
    @IBOutlet weak var topImageWidth: NSLayoutConstraint!
    @IBOutlet weak var topImageViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var nameTextViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var pwdTextViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var loginBtnTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var registerBtnTopConstraint: NSLayoutConstraint!
    
    // MARK: - lifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setViewStyle()
        setViewConstraint()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - EventResponse Method
    @IBAction func loginBtnTouched(_ sender: UIButton) {
        
        view.endEditing(true)
        
        let account = nameTextView.textField.text!
        let pwd = pwdTextView.textField.text!
        
        if account.lengthOfBytes(using: .utf8) != 11 {
            SVProgressHUD.showInfo(withStatus: LanguageHelper.getString(key: "net_rightphone"))
            return
        }
        
        if pwd.lengthOfBytes(using: .utf8) == 0 {
            SVProgressHUD.showInfo(withStatus: LanguageHelper.getString(key: "login_loginpwdplaceholder"))
            return
        }
        
        if pwd.count < 6 || pwd.count > 10 {
            SVProgressHUD.showInfo(withStatus: LanguageHelper.getString(key: "login_loginpwdplaceholder"))
            return
        }
        
        self.login(account: account, pwd: pwd)
        
    }
    
    @IBAction func registerBtnTouched(_ sender: UIButton) { //创建钱包
        view.endEditing(true)
        let registervc = RegisterViewController()
        registervc.type = RegisterViewControllerType.register
        navigationController?.pushViewController(registervc, animated: true)
        
    }
    
    @IBAction func forgetPwdBtnTouched(_ sender: UIButton) { //导入钱包
        view.endEditing(true)
        let importvc = FileSelectViewController()
        navigationController?.pushViewController(importvc, animated: true)
    }
    
    @objc func toForgetViewController() {
        view.endEditing(true)
        let registervc = RegisterViewController()
        registervc.type = RegisterViewControllerType.forgetpwd
        navigationController?.pushViewController(registervc, animated: true)
        
    }
    
    
    
    // MARK: - NetWork Method
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
                    SVProgressHUD.showError(withStatus: result?.message)
                }
            }
        }) { (error) in
            SVProgressHUD.dismiss()
        }
    }
    

    // MARK: - Private Method
    func setViewStyle() {
        
        navigationController?.navigationBar.isHidden = true
        
        nameTextView.addTextFieldAndRightBtn(viewType: .DefaultType)
        nameTextView.textField.setKeyboardStyle(textType: .TextFieldIntegerNumber)
        nameTextView.backgroundColor = UIColor.clear
        nameTextView.titleLabel.text = LanguageHelper.getString(key: "login_loginaccount")
        nameTextView.textField.textColor = UIColor.black
        nameTextView.textField.placeholder = LanguageHelper.getString(key: "login_loginaccountplaceholder")
        
        pwdTextView.addTextFieldAndRightBtn(viewType: .RightBtnType)
        pwdTextView.rightBtn.addTarget(self, action: #selector(LoginViewController.toForgetViewController), for: .touchUpInside)
        pwdTextView.rightBtn.setTitle(LanguageHelper.getString(key: "login_loginforgetpwd"), for: .normal)
        pwdTextView.rightBtn.setTitleColor(R_ZYGrayColor, for: .normal)
        pwdTextView.rightBtn.titleLabel?.font = UIFont.init(name: R_ThemeFontName, size: 12)
        pwdTextView.textField.setKeyboardStyle(textType: .TextFieldNumberLetter)
        pwdTextView.backgroundColor = UIColor.clear
        pwdTextView.titleLabel.text = LanguageHelper.getString(key: "login_loginpwd")
        pwdTextView.textField.textColor = UIColor.black
        pwdTextView.textField.isSecureTextEntry = true
        pwdTextView.textField.placeholder = LanguageHelper.getString(key: "login_loginpwdplaceholder")
        
        loginBtn.setTitle(LanguageHelper.getString(key: "login_login"), for: .normal)
        loginBtn.setBackgroundImage(UIImage.init(), for: .normal)
        loginBtn.backgroundColor = R_ZYThemeColor
        loginBtn.setViewBoarderCorner(radius: 5)
        
        registerBtn.layer.borderColor = R_ZYPlaceholderColor.cgColor
        registerBtn.layer.borderWidth = 1
        registerBtn.setViewBoarderCorner(radius: 5)
        registerBtn.setTitleColor(R_ZYPlaceholderColor, for: .normal)
        registerBtn.setTitle(LanguageHelper.getString(key: "login_creataccount"), for: .normal)
        
        forgetPwdBtn.setViewBoarderCorner(radius: 5)
        forgetPwdBtn.backgroundColor = R_ZYBtnBgGrayColor
        forgetPwdBtn.setTitleColor(UIColor.white, for: .normal)
        forgetPwdBtn.setTitle(LanguageHelper.getString(key: "login_importaccount"), for: .normal)

        
        registerBtn.layer.borderWidth = 1
        registerBtn.setViewBoarderCorner(radius: 5)
        registerBtn.setTitleColor(R_ZYPlaceholderColor, for: .normal)
        
        if let phone = UserDefaults.standard.value(forKey: "phone") {
            nameTextView.textField.text = (phone as! String)
        }
    }
    
   
    
    func setViewConstraint() {
        
    
        topImageViewConstraint.constant = topImageViewConstraint.constant * VERTICAL_SCALE
        
        nameTextViewTopConstraint.constant = nameTextViewTopConstraint.constant * VERTICAL_SCALE
        
        loginBtnTopConstraint.constant = loginBtnTopConstraint.constant * VERTICAL_SCALE
        
        topImageWidth.constant = topImageWidth.constant * HORIZION_SCALE
        
        view.layoutIfNeeded()
    }
    


}
