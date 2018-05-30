//
//  MineBindingPhoneVC.swift
//  PipaPurse
//
//  Created by tam on 2018/5/30.
//  Copyright © 2018年 Wilkinson. All rights reserved.
//

import UIKit
import SVProgressHUD
import ObjectMapper

class MineBindingPhoneVC: MainViewController {
    fileprivate lazy var VM : BaseViewModel = BaseViewModel()
    @IBOutlet weak var naviVw: CreatTopView!
    @IBOutlet weak var phoneVw: UIView!
    @IBOutlet weak var phoneTF: UITextField!{
        didSet{
            phoneTF.keyboardType = .numberPad
            phoneTF.delegate = self
        }
    }
    @IBOutlet weak var verificationVw: UIView!
    @IBOutlet weak var verificationTF: UITextField!{
        didSet{
            verificationTF.keyboardType = .numberPad
            verificationTF.delegate = self
        }
    }
    public var rightAutorBtn = AutorizeButton()
    
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
    
    override func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var maxLength:Int = 0
        if textField == self.phoneTF {
            maxLength = 11
        }else{
            maxLength = 10
        }
        //限制长度
        let proposeLength = (textField.text?.lengthOfBytes(using: String.Encoding.utf8))! - range.length + string.lengthOfBytes(using: String.Encoding.utf8)
        if proposeLength > maxLength { return false }
        return true
    }

}

extension MineBindingPhoneVC {
    func setupUI(){
        naviVw.setViewContent(title: LanguageHelper.getString(key: "Mine_Order_Bind_Phone"))
        naviVw.rightItemBtn.isHidden = false
        naviVw.rightItemBtn.setTitle("绑定", for: .normal)
        naviVw.rightItemBtn.setTitleColor(UIColor.R_UIColorFromRGB(color: 0xBDBDBD), for: .normal)
        naviVw.rightItemBtn.setTitleColor(UIColor.white, for: .selected)
        naviVw.rightItemBtn.addTarget(self, action: #selector(submitOnClick(_:)), for: .touchUpInside)
        naviVw.setButtonCallBack { (btn) in
            self.navigationController?.popViewController(animated: true)
        }
        rightAutorBtn.addTarget(self, action: #selector(codeBtnTouched(btn:)), for: .touchUpInside)
        verificationVw.addSubview(rightAutorBtn)
        view.bringSubview(toFront:rightAutorBtn)
        rightAutorBtn.snp.makeConstraints({ (make) in
            make.centerY.equalTo(verificationTF.snp.centerY)
            make.right.equalTo(self.view.snp.right).offset(-15)
            make.height.equalTo(75)
            make.width.equalTo(29)
        })
        NotificationCenter.default.addObserver(self, selector: #selector(MineBindingPhoneVC.textFieldTextDidChangeOneCI), name:NSNotification.Name.UITextFieldTextDidChange, object: nil)
        
        if UserDefaults.standard.getUserInfo().phone != nil &&  UserDefaults.standard.getUserInfo().phone != "" {
            phoneTF.isUserInteractionEnabled = false
            verificationVw.isHidden = true
        }
    }
    
    @objc func submitOnClick(_ sender:UIButton){
        if Tools.noPaymentPasswordIsSetToExecute() == false{ view.endEditing(true)
            return}
        let input = PaymentPasswordVw(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        input?.delegate = self
        input?.show()
    }
    
    @objc func codeBtnTouched(btn:AutorizeButton) {
        if !Tools.validateMobile(mobile: self.phoneTF.text!) {
            SVProgressHUD.showInfo(withStatus: LanguageHelper.getString(key: "net_rightphone"))
            return
        }
        btn.isCounting = true
        let params = [ "username" : self.phoneTF.text!, "type" : "4"]
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
    
    @objc func textFieldTextDidChangeOneCI(noti:NSNotification){
         setTextfieldStyle()
    }
    
    func setTextfieldStyle(){
        if checkInpunt() {
            naviVw.rightItemBtn.isEnabled = true
            naviVw.rightItemBtn.isSelected = true
        }else{
            naviVw.rightItemBtn.isEnabled = false
            naviVw.rightItemBtn.isSelected = false
        }
    }
    
    func checkInpunt()->Bool{
        let phone = phoneTF.text!
        let verification = verificationTF.text!
        if phone.count != 11 {
           return false
        }
        if verification.count != 0 {
            return false
        }
        return true
    }
    
}
extension MineBindingPhoneVC : PaymentPasswordDelegate {
    func inputPaymentPassword(_ pwd: String!) -> String! {
        let parameters = ["token":(UserDefaults.standard.getUserInfo().token)!,"phone":self.phoneTF.text!,"code":verificationTF.text!,"dealPwd":pwd.md5(),"language":Tools.getLocalLanguage()]
        VM.loadSuccessfullyReturnedData(requestType: .post, URLString: ZYConstAPI.kAPIBindPhone, parameters: parameters, showIndicator: false) { (model:HomeBaseModel) in
            SVProgressHUD.showSuccess(withStatus: LanguageHelper.getString(key: "Added_Successfully"))
        }
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
