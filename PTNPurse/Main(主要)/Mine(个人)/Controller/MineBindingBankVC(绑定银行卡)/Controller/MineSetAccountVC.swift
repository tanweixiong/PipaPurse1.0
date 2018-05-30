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
    fileprivate lazy var codeImage = UIImageView()
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
        view.uploadBtn.addTarget(self, action: #selector(onClick(_:)), for: .touchUpInside)
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
        ZYNetWorkTool.uploadPictures(url: url, parameter: parameters, image: codeImage.image!, imageKey: key, success: { (json) in
            let responseData = Mapper<NodataResponse>().map(JSONObject: json)
            if let code = responseData?.code {
                guard  200 == code else {
                    SVProgressHUD.showError(withStatus: responseData?.message)
                    return
                }
                SVProgressHUD.showSuccess(withStatus: LanguageHelper.getString(key: "net_success"))
                if responseData?.data != nil {
                    self.mineSetAccountVw.codeImageVw = self.codeImage
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
        if codeImage.image != nil {
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
            self.codeImage.image = chosenImage
        }
    }
}

