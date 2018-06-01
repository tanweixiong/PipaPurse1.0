//
//  MineSetAccountVC.swift
//  BCPPurse
//
//  Created by SKINK on 2018/4/16.
//  Copyright © 2018年 Wilkinson. All rights reserved.
//

import UIKit
import SVProgressHUD
import ObjectMapper

enum MineSetAccountStyle{
    case alipayStyle
    case weChatStyle
}

class MineSetAccountVC: MainViewController {
    fileprivate lazy var viewModel : BaseViewModel = BaseViewModel()
    fileprivate lazy var codeImage = UIImage()
    fileprivate lazy var isUpload:Bool = false
    fileprivate lazy var urlString = ""
    var type = 0
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
        view.paymentMethodTF.delegate = self
        view.paymentMethodTF.placeholder = style == .alipayStyle ? LanguageHelper.getString(key: "binding_Please_enter_alipay_account") : LanguageHelper.getString(key: "binding_Please_enter_weChat_account")
        view.titleLab.text = style == .alipayStyle ? LanguageHelper.getString(key: "binding_Alipay_account") : LanguageHelper.getString(key: "binding_Wechat_account")
        view.uploadBtn.addTarget(self, action: #selector(onClick(_:)), for: .touchUpInside)
        NotificationCenter.default.addObserver(self, selector: #selector(MineSetAccountVC.textFieldTextDidChangeOneCI), name:NSNotification.Name.UITextFieldTextDidChange, object: nil)
        return view
    }()
    
    lazy var submitBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.frame = CGRect(x: SCREEN_WIDTH - 15 - 40, y: 32, width: 40, height: 22)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        btn.setTitleColor(UIColor.R_UIColorFromRGB(color: 0xBDBDBD), for: .normal)
        btn.setTitleColor(UIColor.white, for: .selected)
        btn.setTitle(LanguageHelper.getString(key: "save"), for: .normal)
        btn.titleLabel?.textAlignment = .right
        btn.isEnabled = false
        btn.addTarget(self, action: #selector(onClick(_:)), for: .touchUpInside)
        return btn
    }()
    
    //限制位数
    override func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == mineSetAccountVw.paymentMethodTF {
            var maxLength:Int = 0
            maxLength = 20
            //限制长度
            let proposeLength = (textField.text?.lengthOfBytes(using: String.Encoding.utf8))! - range.length + string.lengthOfBytes(using: String.Encoding.utf8)
            if proposeLength > maxLength { return false }
            return true
        }
        return true
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UITextFieldTextDidChange, object: nil)
    }
    
}

extension MineSetAccountVC {
    func setupUI(){
        if type == 0 {
            style = .alipayStyle
        }else if type == 1 {
            style = .weChatStyle
        }
        let title = style == .alipayStyle ? LanguageHelper.getString(key: "binding_Alipay_account") : LanguageHelper.getString(key: "binding_Wechat_account")
        setNormalNaviBar(title:title)
        view.backgroundColor = UIColor.R_UIRGBColor(red: 249, green: 249, blue: 251, alpha: 1)
        view.addSubview(mineSetAccountVw)
        view.addSubview(submitBtn)
        mineSetAccountVw.paymentMethodTF.keyboardType = .asciiCapable
    }
    
    @objc func onClick(_ sender:UIButton){
        if sender == submitBtn {
            if Tools.noPaymentPasswordIsSetToExecute() == false{view.endEditing(true)
                return
            }
            let input = PaymentPasswordVw(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
            input?.delegate = self
            input?.show()
        }else if sender == mineSetAccountVw.uploadBtn {
            uploadImage()
        }
    }
    
    //上传资料
    func postData(dealPwd:String){
        let account = mineSetAccountVw.paymentMethodTF.text!
        let token = (UserDefaults.standard.getUserInfo().token)!
        let url = style == .alipayStyle ? ZYConstAPI.kAPIBindApay : ZYConstAPI.kAPIBindWeChat
        let type =  style == .alipayStyle ? "alipay" : "weChat"
        let key = style == .alipayStyle ? "apayPhoto" : "weChatPhoto"
        let dealPwd = dealPwd.md5()
        let parameters = ["token":token,type:account,"dealPwd":dealPwd]
        SVProgressHUD.show(withStatus: LanguageHelper.getString(key: "please_wait"))
        ZYNetWorkTool.uploadMuchPictures(url: url, parameter: parameters, imageArray: [codeImage], imageKey: key, success: { (json) in
            let responseData = Mapper<NodataResponse>().map(JSONObject: json)
            if let code = responseData?.code {
                guard  200 == code else {
                    SVProgressHUD.showError(withStatus: responseData?.message)
                    return
                }
                SVProgressHUD.showSuccess(withStatus: LanguageHelper.getString(key: "Added_Successfully"))
                
                //记录在本地
                let userInfo = UserDefaults.standard.getUserInfo()
                if self.style == .alipayStyle {
                    userInfo.apay = account
                    userInfo.apayUrl = self.urlString
                }else if self.style == .weChatStyle{
                    userInfo.weChat = account
                    userInfo.weChatUrl = self.urlString
                }
                UserDefaults.standard.saveCustomObject(object: userInfo, key: R_UserInfo)
                
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: {
                    self.navigationController?.popViewController(animated: true)
                })
            } else {
                SVProgressHUD.showError(withStatus: LanguageHelper.getString(key: "net_networkerror"))
            }
        }) { (error) in
              SVProgressHUD.showError(withStatus: LanguageHelper.getString(key: "net_networkerror"))
        }
    }
    
    //上传图片
    func uploadpictures(image:UIImage) {
        let token = (UserDefaults.standard.getUserInfo().token)!
        let params = ["token" : token] as [String : Any]
        SVProgressHUD.show(withStatus: LanguageHelper.getString(key: "C2C_publish_dispute_prompt_Uploading"))
        ZYNetWorkTool.uploadPictures(url: ZYConstAPI.kAPIUpdataUserPhoto, parameter: params, image: image, imageKey: "photo", success: { (json) in
            SVProgressHUD.dismiss()
            Tools.DLog(message: params)
            let responseData = Mapper<NodataResponse>().map(JSONObject: json)
            if let code = responseData?.code {
                guard  200 == code else {
                    SVProgressHUD.showError(withStatus: responseData?.message)
                    return
                }
                SVProgressHUD.showSuccess(withStatus: LanguageHelper.getString(key: "net_success"))
                if responseData?.data != nil {
                    self.urlString = (responseData?.data)!
                    self.setTextfieldStyle()
                }
            } else {
                SVProgressHUD.showError(withStatus: LanguageHelper.getString(key: "net_networkerror"))
            }
        }) { (error) in
            SVProgressHUD.showError(withStatus: LanguageHelper.getString(key: "net_networkerror"))
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
    
    func getData(){
        if self.style == .alipayStyle {
            let alipay = UserDefaults.standard.getUserInfo().apay
            let alipayCodeUrl = UserDefaults.standard.getUserInfo().apayUrl
            if alipay != nil && alipay != "" {
                mineSetAccountVw.paymentMethodTF.text = alipay
                if alipayCodeUrl != nil && alipayCodeUrl != "" {
                    mineSetAccountVw.codeImageVw.sd_setImage(with: NSURL(string: alipayCodeUrl!)! as URL, placeholderImage: UIImage.init(named: "ic_home_re_code"))
                    self.urlString = alipayCodeUrl!
                    isUpload = true
                }
            }
        }else if self.style == .weChatStyle {
            let weChat = UserDefaults.standard.getUserInfo().weChat
            let weChatCodeUrl = UserDefaults.standard.getUserInfo().weChatUrl
            if weChat != nil && weChat != "" {
                mineSetAccountVw.paymentMethodTF.text = weChat
                if weChatCodeUrl != nil && weChatCodeUrl != "" {
                    mineSetAccountVw.codeImageVw.sd_setImage(with: NSURL(string: weChatCodeUrl!)! as URL, placeholderImage: UIImage.init(named: "ic_home_re_code"))
                    self.urlString = weChatCodeUrl!
                    isUpload = true
                }
            }
        }
        setTextfieldStyle()
    }
    
    func uploadImage(){
        let alertAction = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
        alertAction.addAction(UIAlertAction.init(title: LanguageHelper.getString(key: "person_camera"), style: .default, handler: { (alertCamera) in
            let pickerVC = UIImagePickerController()
            pickerVC.delegate = self
            pickerVC.sourceType = .camera
            pickerVC.allowsEditing = true
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.present(pickerVC, animated: true, completion: nil)
            } else {
                SVProgressHUD.showInfo(withStatus: LanguageHelper.getString(key: "person_cameraenable"))
            }
        }))
        
        alertAction.addAction(UIAlertAction.init(title:LanguageHelper.getString(key: "person_photo"), style: .default, handler: { (alertPhoto) in
            let pickerVC = UIImagePickerController()
            pickerVC.delegate = self
            pickerVC.sourceType = .photoLibrary
            pickerVC.allowsEditing = true
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                self.present(pickerVC, animated: true, completion: nil)
            }  else {
                SVProgressHUD.showInfo(withStatus: LanguageHelper.getString(key: "person_photoenable"))
            }
        }))
        alertAction.addAction(UIAlertAction.init(title:  LanguageHelper.getString(key: "login_cancle"), style: .cancel, handler: { (alertCancel) in
            
        }))
        self.present(alertAction, animated: true, completion: nil)
    }
    
    func checkInput()->Bool{
        let account:String = mineSetAccountVw.paymentMethodTF.text!
        if account.count == 0  {
            return false
        }
        if isUpload == false {
            return false
        }
        return true
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

extension MineSetAccountVC : UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let chosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            picker.dismiss(animated: true, completion: nil)
            self.isUpload = true
            self.codeImage = chosenImage
            self.mineSetAccountVw.codeImageVw.image = self.codeImage
            self.uploadpictures(image: self.codeImage)
        }
    }
}

