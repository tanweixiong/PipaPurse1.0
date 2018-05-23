//
//  ModifyTradePwdViewController.swift
//  rryproject
//
//  Created by zhengyi on 2018/1/15.
//  Copyright © 2018年 inesv. All rights reserved.
//

import UIKit
import SVProgressHUD
import ObjectMapper

enum ModifyPwdType {
    case tradepwd
    case loginpwd
    case setTradepwd
}

class ModifyTradePwdViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var topView: CreatTopView!
    @IBOutlet weak var codeTextView: LoginTextFieldView!
    @IBOutlet weak var pwdTextView: LoginTextFieldView!
    @IBOutlet weak var commitBtn: UIButton!
    var isNeedNavi = true
    
    var type: ModifyPwdType? = .tradepwd
    var status = RegisterViewControllerStatus.normal
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewStyle()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if isNeedNavi {
           navigationController?.navigationBar.isHidden = false
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    @IBAction func confirmBtnTouched(_ sender: UIButton) {
        
        view.endEditing(true)
        let code = self.codeTextView.textField.text!
        let pwd = self.pwdTextView.textField.text!
        
        if pwd.lengthOfBytes(using: .utf8) == 0 || code.lengthOfBytes(using: .utf8) == 0 {
            SVProgressHUD.showInfo(withStatus: LanguageHelper.getString(key: "login_infocantnil"))
            return
        }
        
        if !Tools.validateAuthorCode(code: code) {
            SVProgressHUD.showInfo(withStatus: LanguageHelper.getString(key: "login_codeerror"))
            return
        }
        
        if pwd.lengthOfBytes(using: .utf8) != 6 {
            SVProgressHUD.showInfo(withStatus: LanguageHelper.getString(key: "login_tradepwdplaceholder"))
            return
        }
        
        if type != .setTradepwd {
            modifypwd(pwd: pwd, code: code)
        }else{
            setModifypwd(pwd: pwd, code: code)
        }
    }
    
    func back() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func codeBtnTouched(sender: AutorizeButton) {
        
        sender.isCounting = true
        getAuthorizeCode()
    }
    
    
    // MARK: - NetWork Method
    func getAuthorizeCode() {
        
        let phone = UserDefaults.standard.getUserInfo().username as! String
        //1:用户注册,2:用户忘记密码,3:用户修改交易密码,4:用户忘记交易密码
        let params = [ "username" : phone, "type" : "3"]
        ZYNetWorkTool.requestData(.post, URLString: ZYConstAPI.kAPIGetAuthorCode, language: true, parameters: params, showIndicator: true, success: { (jsonObjc) in
            let result = Mapper<NodataResponse>().map(JSONObject: jsonObjc)
            if let code = result?.code {
                if code == 200 {
                    SVProgressHUD.showSuccess(withStatus: LanguageHelper.getString(key: "net_requestsuccess"))
                } else {
                    SVProgressHUD.showError(withStatus: result?.message)
                }
            } else {
                SVProgressHUD.dismiss()
            }
        }) { (error) in
            SVProgressHUD.showError(withStatus: LanguageHelper.getString(key: "net_networkerror"))
        }
        
    }
    
    func modifypwd(pwd: String, code: String) {
        let phone = UserDefaults.standard.getUserInfo().username as! String
        let pwdmd5 = pwd.md5()
        let params = ["username": phone, "dealPwd":pwdmd5, "code": code]
        SVProgressHUD.show(with: .black)
        ZYNetWorkTool.requestData(.post, URLString: ZYConstAPI.kAPIModifyTradePwd, language: true, parameters: params, showIndicator: true, success: { (jsonObjc) in
            let result = Mapper<NodataResponse>().map(JSONObject: jsonObjc)
            if let code = result?.code {
                if code == 200 {
                    SVProgressHUD.showSuccess(withStatus: LanguageHelper.getString(key: "net_success"))
                    self.navigationController?.popViewController(animated: true)
                    Tools.saveTransactionPassword(password: pwd)
                } else {
                    SVProgressHUD.showError(withStatus: result?.message)
                }
            } else {
                SVProgressHUD.dismiss()
            }
        }) { (error) in
            SVProgressHUD.showError(withStatus: LanguageHelper.getString(key: "net_networkerror"))
        }
    }
    
    //设置交易密码
    func setModifypwd(pwd: String, code: String) {
        let phone = SingleTon.shared.userInfo?.username!
        let pwdmd5 = pwd.md5()
        let params = ["username": phone!, "dealPwd":pwdmd5, "code": code]
        SVProgressHUD.show(with: .black)
        ZYNetWorkTool.requestData(.post, URLString: ZYConstAPI.kAPISetTradePwd, language: true, parameters: params, showIndicator: true, success: { (jsonObjc) in
            let result = Mapper<NodataResponse>().map(JSONObject: jsonObjc)
            if let code = result?.code {
                if code == 200 {
                    SVProgressHUD.showSuccess(withStatus: LanguageHelper.getString(key: "net_success"))
                    self.navigationController?.popViewController(animated: true)
                    Tools.saveTransactionPassword(password: pwdmd5)
                } else {
                    SVProgressHUD.showError(withStatus: result?.message)
                }
            } else {
                SVProgressHUD.dismiss()
            }
        }) { (error) in
            SVProgressHUD.showError(withStatus: LanguageHelper.getString(key: "net_networkerror"))
        }
    }
    
    // MARK: - Delegate Method
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if codeTextView.textField.text != "" && pwdTextView.textField.text != "" {
            Tools.setButtonType(isBoarder: false, sender: commitBtn, fontSize: 14, bgcolor: R_ZYThemeColor)
            commitBtn.isUserInteractionEnabled = true
        } else {
            Tools.setButtonType(isBoarder: true, sender: commitBtn, fontSize: 14, bgcolor: R_ZYThemeColor)
            commitBtn.isUserInteractionEnabled = false
        }
        
    }
    // MARK: - Private Method
    func setViewStyle() {
        
        
        if type! == .loginpwd {
            
        } else if type! == .tradepwd{
            
        }
        
        if let flag = SingleTon.shared.pwdstate {
            if flag == 1 {
                topView.setViewContent(title: LanguageHelper.getString(key: "person_modifytradepwd"))
            } else if flag == 0 {
                topView.setViewContent(title: LanguageHelper.getString(key: "person_settradepwd"))
            }
        } else {
            topView.setViewContent(title: LanguageHelper.getString(key: "person_forgetminepwd"))
        }
        
        topView.setButtonCallBack { (sender) in
            self.navigationController?.popViewController(animated: true)
        }
        
        pwdTextView.addTextFieldAndRightBtn(viewType: .DefaultType)
        pwdTextView.textField.setKeyboardStyle(textType: .TextFieldIntegerNumber)
        pwdTextView.backgroundColor = UIColor.clear
        pwdTextView.titleLabel.text = LanguageHelper.getString(key: "login_newpwd")
        pwdTextView.textField.placeholder = LanguageHelper.getString(key: "login_newpwdplaceholder")
        pwdTextView.textField.textColor = UIColor.black
        pwdTextView.textField.isSecureTextEntry = true
        NotificationCenter.default.addObserver(self, selector: #selector(ModifyTradePwdViewController.textFieldTextDidChangeOneCI), name:NSNotification.Name.UITextFieldTextDidChange, object: nil)

        
        codeTextView.addTextFieldAndRightBtn(viewType: .SecondsCountType)
        codeTextView.textField.setKeyboardStyle(textType: .TextFieldIntegerNumber)
        codeTextView.backgroundColor = UIColor.clear
        codeTextView.titleLabel.text = LanguageHelper.getString(key: "login_registercode")
        codeTextView.textField.textColor = UIColor.black
        codeTextView.textField.placeholder = LanguageHelper.getString(key: "login_codeplaceholder")
        codeTextView.rightAutorBtn.addTarget(self, action: #selector(codeBtnTouched(sender:)), for: .touchUpInside)
        
        Tools.setButtonType(isBoarder: true, sender: commitBtn, fontSize: 14, bgcolor: R_ZYThemeColor)
        commitBtn.setTitle(LanguageHelper.getString(key: "login_next"), for: .normal)
        
        pwdTextView.textField.delegate = self
        codeTextView.textField.delegate = self
        
        
        if type == .tradepwd {
            pwdTextView.titleLabel.text = LanguageHelper.getString(key: "person_pwdTextView_Password")
            pwdTextView.textField.placeholder = LanguageHelper.getString(key: "person_pwdTextView_Please_enter_your_password")
            topView.setViewContent(title: LanguageHelper.getString(key: "person_settradepwd"))
        }
        
        
        if status == .modify {
            topView.setViewContent(title: LanguageHelper.getString(key: "edit_pay_password"))
            pwdTextView.titleLabel.text = LanguageHelper.getString(key: "edit_pay_password")
            pwdTextView.textField.placeholder = LanguageHelper.getString(key: "edit_plase_pay_password")
        }
    }
    
    @objc func textFieldTextDidChangeOneCI(noti:NSNotification){
        let textField = noti.object as! UITextField
        if textField == self.pwdTextView.textField{
            let textContent = textField.text
            let textNum = textContent?.count
            if textNum! > 6 {
                let index = textContent?.index((textContent?.startIndex)!, offsetBy: 6)
                let str = textContent?.substring(to: index!)
                textField.text = str
            }
        }
            
    }

}
