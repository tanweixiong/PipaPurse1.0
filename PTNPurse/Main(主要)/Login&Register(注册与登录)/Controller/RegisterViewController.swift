//
//  RegisterViewController.swift
//  rryproject
//
//  Created by zhengyi on 2018/1/11.
//  Copyright © 2018年 inesv. All rights reserved.
//

import UIKit
import SVProgressHUD
import ObjectMapper

enum RegisterViewControllerType {
    case register
    case forgetpwd
    case setPaymentPsd
}

enum RegisterViewControllerStatus {
    case normal
    case modify
}
class RegisterViewController: UIViewController, UITextFieldDelegate {
    fileprivate lazy var viewModel : BaseViewModel = BaseViewModel()
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var scrollContentView: UIView!
    @IBOutlet weak var topImageView: CreatTopView!
    @IBOutlet weak var nameTextView: LoginTextFieldView!
    @IBOutlet weak var pwdTextView: LoginTextFieldView!
    @IBOutlet weak var codeTextView: LoginTextFieldView!
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var scrollContentViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var invitationCodeTextView: LoginTextFieldView!
    @IBOutlet weak var register_y: NSLayoutConstraint!
    fileprivate var rigisterInformationStr = ""
    fileprivate var isRegister = true
    var type =  RegisterViewControllerType.register
    var status = RegisterViewControllerStatus.normal
    
    // MARK: - life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewStyle()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - EventResponse Method
    
    @IBAction func registerBtnTouched(_ sender: UIButton) {
        view.endEditing(true)
        let authorCode = self.codeTextView.textField.text!
        let pwd = self.pwdTextView.textField.text!
        let name = self.nameTextView.textField.text!
        
        if pwd.lengthOfBytes(using: .utf8) == 0 || name.lengthOfBytes(using: .utf8) == 0 || authorCode.lengthOfBytes(using: .utf8) == 0 {
            SVProgressHUD.showInfo(withStatus: LanguageHelper.getString(key: "login_infocantnil"))
            return
        }
        
        if name.lengthOfBytes(using: .utf8) == 0 {
            SVProgressHUD.showInfo(withStatus: LanguageHelper.getString(key: "login_loginaccountplaceholder"))
            return
        }
        
        if !Tools.validateAuthorCode(code: authorCode) {
            SVProgressHUD.showInfo(withStatus: LanguageHelper.getString(key: "login_codeerror"))
            return
        }
        
        if Tools.validateNewPassword(pwd: pwd) == false {
            SVProgressHUD.showInfo(withStatus: LanguageHelper.getString(key: "login_loginpwdplaceholder"))
            return
        }
        
        if type == .forgetpwd {
            register(name: name,pwd: pwd, code: authorCode, url: ZYConstAPI.kAPIForgetLoginPwd)
        } else if type == .register {
            register(name: name, pwd: pwd, code: authorCode, url: ZYConstAPI.kAPIRegister)
        }else if type == .setPaymentPsd {
            setPaymentPsw(name: name, pwd: pwd, code: authorCode, url: ZYConstAPI.kAPIModifyTradePwd)
        }
        
    }
    
    @objc func codeBtnTouched(btn:AutorizeButton) {
        if checkInpunt() {
            getAuthorizeCode(btn: btn)
        }
    }
    
    func checkInpunt()->Bool{
        let nameTextView = self.nameTextView.textField.text!
        if Tools.validateNewPhone(phone: nameTextView) == false && Tools.validateEmail(email: nameTextView) == false {
            SVProgressHUD.showInfo(withStatus: LanguageHelper.getString(key: "please_fill_finish"))
            return false
        }
        return true
    }
    
    // MARK: - NetWork Method
    func getAuthorizeCode(btn:AutorizeButton) {
        
        let phone = nameTextView.textField.text!
        //1:用户注册,2:用户忘记密码,3:用户修改交易密码,4:用户忘记交易密码
        var params = [ "username" : phone, "type" : "1"]
        if type == .register {
            //判断邮箱注册还是手机号码
            params = [ "username" : phone, "type" : "1"]
        } else if type == .forgetpwd {
            params = [ "username" : phone, "type" : "2"]
        } else if type == .setPaymentPsd {
            params = [ "username" : phone, "type" : "3"]
        }
        
        ZYNetWorkTool.requestData(.post, URLString: ZYConstAPI.kAPIGetAuthorCode, language: true, parameters: params, showIndicator: true, success: { (jsonObjc) in
            let result = Mapper<NodataResponse>().map(JSONObject: jsonObjc)
            if let code = result?.code {
                if code == 200 {
                    SVProgressHUD.showSuccess(withStatus: LanguageHelper.getString(key: "net_requestsuccess"))
                    btn.isCounting = true
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
    
    func register(name: String, pwd: String, code: String, url: String) {
        let invitationCode = invitationCodeTextView.textField.text!
        let pwdmd5 = pwd.md5()
        let params = ["username": name, "pwd":pwdmd5, "code": code,"invitationCode":invitationCode]
        SVProgressHUD.show(with: .black)
        ZYNetWorkTool.requestData(.post, URLString: url, language: true, parameters: params, showIndicator: true, success: { (jsonObjc) in
            let result = Mapper<NodataResponse>().map(JSONObject: jsonObjc)
            if let code = result?.code {
                if code == 200 {
                    if self.type == .forgetpwd {
                        SVProgressHUD.showSuccess(withStatus: LanguageHelper.getString(key: "net_success"))
                        let successvc = RegisterSuccessViewController()
                        successvc.type = RegisterSuccessViewControllerType.modifypwd
                        self.navigationController?.pushViewController(successvc, animated: true)
                    } else if self.type == .register {
                        SVProgressHUD.showSuccess(withStatus: LanguageHelper.getString(key: "net_success"))
                        let successvc = RegisterSuccessViewController()
                        successvc.type = RegisterSuccessViewControllerType.register
                        self.navigationController?.pushViewController(successvc, animated: true)
                    }else if self.type == .setPaymentPsd{
                        self.navigationController?.popToRootViewController(animated: true)
                    }
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
    
    func forgetpwd(name: String, pwd: String, code: String, url: String) {
        
        let pwdmd5 = pwd.md5()
        let params = ["username": name, "pwd":pwdmd5, "code": code]
        SVProgressHUD.show(with: .black)
        ZYNetWorkTool.requestData(.post, URLString: url, language: true, parameters: params, showIndicator: true, success: { (jsonObjc) in
            let result = Mapper<NodataResponse>().map(JSONObject: jsonObjc)
            if let code = result?.code {
                if code == 200 {
                    if self.type == .forgetpwd {
                        SVProgressHUD.showSuccess(withStatus: LanguageHelper.getString(key: "net_success"))
                        let successvc = RegisterSuccessViewController()
                        successvc.type = RegisterSuccessViewControllerType.modifypwd
                        self.navigationController?.pushViewController(successvc, animated: true)
                    } else if self.type == .register {
                        SVProgressHUD.showSuccess(withStatus: LanguageHelper.getString(key: "net_success"))
                        let successvc = RegisterSuccessViewController()
                        successvc.type = RegisterSuccessViewControllerType.register
                        self.navigationController?.pushViewController(successvc, animated: true)
                    }
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
    
    func setPaymentPsw(name: String, pwd: String, code: String, url: String) {
        let pwdmd5 = pwd.md5()
        let params = ["username": name, "dealPwd":pwdmd5, "code": code,"type":"3"]
        SVProgressHUD.show(with: .black)
        ZYNetWorkTool.requestData(.post, URLString: url, language: true, parameters: params, showIndicator: true, success: { (jsonObjc) in
            SVProgressHUD.dismiss()
            let result = Mapper<NodataResponse>().map(JSONObject: jsonObjc)
            if let code = result?.code {
                if code == 200 {
                    if self.type == .forgetpwd {
                        SVProgressHUD.showSuccess(withStatus: LanguageHelper.getString(key: "net_success"))
                        let successvc = RegisterSuccessViewController()
                        successvc.type = RegisterSuccessViewControllerType.modifypwd
                        self.navigationController?.pushViewController(successvc, animated: true)
                    } else if self.type == .register {
                        SVProgressHUD.showSuccess(withStatus: LanguageHelper.getString(key: "net_success"))
                        let successvc = RegisterSuccessViewController()
                        successvc.type = RegisterSuccessViewControllerType.register
                        self.navigationController?.pushViewController(successvc, animated: true)
                    }else if self.type == .setPaymentPsd{
                        SVProgressHUD.showSuccess(withStatus: LanguageHelper.getString(key: "modify_pay_pwd_success"))
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: {
                             self.navigationController?.popToRootViewController(animated: true)
                        })
                    }
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
    
    // MARK: - Delegate Method
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if nameTextView.textField.text != "" && pwdTextView.textField.text != "" && codeTextView.textField.text != "" {
            
            Tools.setButtonType(isBoarder: false, sender: registerBtn, fontSize: 14, bgcolor: R_ZYThemeColor)
            registerBtn.isUserInteractionEnabled = true
            
        } else {
            Tools.setButtonType(isBoarder: true, sender: registerBtn, fontSize: 14, bgcolor: R_ZYThemeColor)
            registerBtn.isUserInteractionEnabled = false
        }
        
    }
    
    //判断是否已经注册
    func isRegisterFinish(account:String){
        let userName = account
        let language = Tools.getLocalLanguage()
        let parameters = ["userName":userName,"language":language]
        viewModel.loadSuccessfullyReturnedData(requestType: .post, URLString: ZYConstAPI.kAPIUserIsExistence, parameters: parameters, showIndicator: false) { (model:HomeBaseModel) in
            //200 不存在
            if model.code == 200 {
               self.isRegister = false
            //400 存在
            }else if model.code == 1044{
               self.rigisterInformationStr = model.message!
               self.isRegister = true
               SVProgressHUD.showInfo(withStatus: self.rigisterInformationStr)
            }
        }
    }

    // MARK: - Private Method
    func setViewStyle() {
        if type == .forgetpwd {
            topImageView.setViewContent(title: LanguageHelper.getString(key: "retrieve_Login_Password"))
            pwdTextView.titleLabel.text = LanguageHelper.getString(key: "retrieve_Login_Password")
            pwdTextView.textField.placeholder = LanguageHelper.getString(key: "login_newpwdplaceholder")
            registerBtn.isEnabled = false
        } else if type == .register {
            topImageView.setViewContent(title: LanguageHelper.getString(key: "login_creataccount"))
            pwdTextView.textField.placeholder = LanguageHelper.getString(key: "login_loginpwdplaceholder")
            pwdTextView.titleLabel.text = LanguageHelper.getString(key: "login_loginpwd")
            registerBtn.isEnabled = false
        }else if type == .setPaymentPsd{
            topImageView.setViewContent(title: LanguageHelper.getString(key: "Mine_Transaction_Password"))
            pwdTextView.titleLabel.text = LanguageHelper.getString(key: "set_pay_password")
            pwdTextView.textField.placeholder = LanguageHelper.getString(key: "person_plase_settradepwd")
            registerBtn.isEnabled = false
        }
        
        nameTextView.addTextFieldAndRightBtn(viewType: .SecondsCountType)
        nameTextView.textField.setKeyboardStyle(textType: .TextFieldNormal)
        nameTextView.rightAutorBtn.setTitle(LanguageHelper.getString(key: "get_code"), for: .normal)
        nameTextView.backgroundColor = UIColor.clear
        nameTextView.titleLabel.text = LanguageHelper.getString(key: "login_registeraccount")
        nameTextView.textField.textColor = UIColor.black
        nameTextView.textField.placeholder = LanguageHelper.getString(key: "login_loginaccountplaceholder")
        nameTextView.rightAutorBtn.addTarget(self, action: #selector(codeBtnTouched(btn:)), for: .touchUpInside)
        NotificationCenter.default.addObserver(self, selector: #selector(RegisterViewController.textFieldTextDidChangeOneCI), name:NSNotification.Name.UITextFieldTextDidChange, object: nil)

        pwdTextView.addTextFieldAndRightBtn(viewType: .DefaultType)
        pwdTextView.textField.setKeyboardStyle(textType: .TextFieldNumberLetter)
        pwdTextView.backgroundColor = UIColor.clear
        pwdTextView.textField.textColor = UIColor.black
        pwdTextView.textField.isSecureTextEntry = true
        
        codeTextView.addTextFieldAndRightBtn(viewType: .DefaultType)
        codeTextView.textField.setKeyboardStyle(textType: .TextFieldIntegerNumber)
        codeTextView.backgroundColor = UIColor.clear
        codeTextView.titleLabel.text = LanguageHelper.getString(key: "register_code")
        codeTextView.textField.textColor = UIColor.black
        codeTextView.textField.placeholder = LanguageHelper.getString(key: "login_codeplaceholder")
        
        if type == .register{
            invitationCodeTextView.isHidden = false
            register_y.constant = 120
            invitationCodeTextView.addTextFieldAndRightBtn(viewType: .DefaultType)
            invitationCodeTextView.textField.setKeyboardStyle(textType: .TextFieldNormal)
            invitationCodeTextView.backgroundColor = UIColor.clear
            invitationCodeTextView.titleLabel.text = LanguageHelper.getString(key: "person_Invitation_code")
            invitationCodeTextView.textField.textColor = UIColor.black
            invitationCodeTextView.textField.placeholder = LanguageHelper.getString(key: "person_Please_enter_your_invitation_code")
        }
        
        Tools.setButtonType(isBoarder: true, sender: registerBtn, fontSize: 14, bgcolor: R_ZYThemeColor)
        
        registerBtn.setTitle(LanguageHelper.getString(key: "login_next"), for: .normal)
        
        topImageView.btnCallBack = ({ (sender) in
            self.navigationController?.popViewController(animated: true)
        })
        
        if type == .setPaymentPsd {
            registerBtn.setTitle(LanguageHelper.getString(key: "login_ok"), for: .normal)
            pwdTextView.textField.keyboardType = .numberPad
        }
        
        if status == .modify {
            topImageView.setViewContent(title: LanguageHelper.getString(key: "edit_pay_password"))
            pwdTextView.titleLabel.text = LanguageHelper.getString(key: "edit_pay_password")
            pwdTextView.textField.placeholder = LanguageHelper.getString(key: "edit_plase_pay_password")
        }
        
        self.automaticallyAdjustsScrollViewInsets = false
    }
    
    func setViewConstraint() {
        
        view.layoutIfNeeded()
    }
    
    func toSuccessViewController() {
        let svc = RegisterSuccessViewController()
        self.navigationController?.pushViewController(svc, animated: true)
    }
    
   @objc func textFieldTextDidChangeOneCI(noti:NSNotification){
        let textField = noti.object as! UITextField
        if type == .setPaymentPsd {
            setPaymentPsdStyle()
            if textField == self.pwdTextView.textField{
                self.setLimitTheNumberOfWords(wordNum: 6, textField: textField)
            }
        }else if type == .register {
            setPaymentPsdStyle()
        }else if type == .forgetpwd{
            setPaymentPsdStyle()
        }
    }
    
    //限制字数
    func setLimitTheNumberOfWords(wordNum:NSInteger,textField:UITextField){
        let textContent = textField.text
        let textNum = textContent?.count
        if textNum! > wordNum {
            let index = textContent?.index((textContent?.startIndex)!, offsetBy: wordNum)
            let str = textContent?.substring(to: index!)
            textField.text = str
        }
    }
    
    //设置确定按钮状态
    func setPaymentPsdStyle(){
        if checkPaymentPsdInpunt() {
            registerBtn.backgroundColor = R_UIThemeColor
            registerBtn.setTitleColor(UIColor.white, for: .normal)
            registerBtn.layer.borderWidth = 0
            registerBtn.isEnabled = true
        }else{
            registerBtn.backgroundColor = UIColor.clear
            registerBtn.setTitleColor(R_ZYPlaceholderColor, for: .normal)
            registerBtn.layer.borderWidth = 1
            registerBtn.isEnabled = false
        }
        
    }
    
    func checkPaymentPsdInpunt()->Bool{
        let nameText = nameTextView.textField.text!
        if Tools.validateNewPhone(phone: nameText) == false && Tools.validateEmail(email: nameText) == false {
            return false
        }

        let code = codeTextView.textField.text!
        if code == "" {
            return false
        }
        
        let pwdText = pwdTextView.textField.text!
        if pwdText.count < 6 {
            return false
        }
        return true
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name:NSNotification.Name.UITextFieldTextDidChange, object: nil)
    }
}



