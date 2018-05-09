//
//  OpitionViewController.swift
//  PTNPurse
//
//  Created by zhengyi on 2018/1/21.
//  Copyright © 2018年 Wilkinson. All rights reserved.
//

import UIKit
import SVProgressHUD
import ObjectMapper

enum OpinionType: String {
    case apperror = "1"
    case proadvice = "2"
}

class OpitionViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var topView: CreatTopView!
    @IBOutlet weak var errorTypeTextView: LoginTextFieldView!
    
    @IBOutlet weak var adviceTextVeiew: LoginNoteTextView!
    
    @IBOutlet weak var phoneTextView: LoginTextFieldView!
    @IBOutlet weak var commitBtn: UIButton!
    
    var opinionType: OpinionType? = .apperror
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewStyle()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - EventResponse Method
    @objc func appErrorBtnTouched(sender: UIButton) {
        
        sender.isSelected = !sender.isSelected
        
        errorTypeTextView.leftTitleBtn1.isSelected = sender.isSelected
        errorTypeTextView.leftImageBtn1.isSelected = sender.isSelected
        errorTypeTextView.leftTitleBtn2.isSelected = !sender.isSelected
        errorTypeTextView.leftImageBtn2.isSelected = !sender.isSelected
        
        if sender.isSelected {
            opinionType = .apperror
        }
        
    }
    
    @objc func appAddviceBtnTouched(sender: UIButton) {
        
        sender.isSelected = !sender.isSelected

        errorTypeTextView.leftTitleBtn2.isSelected = sender.isSelected
        errorTypeTextView.leftImageBtn2.isSelected = sender.isSelected
        errorTypeTextView.leftTitleBtn1.isSelected = !sender.isSelected
        errorTypeTextView.leftImageBtn1.isSelected = !sender.isSelected
        
        if sender.isSelected {
            opinionType = .proadvice
        }
        
    }
    
    
    @IBAction func commitBtnTouched(_ sender: UIButton) {
        let content = adviceTextVeiew.noteTextView.textView.text
        let phone = phoneTextView.textField.text
        
        if (content?.lengthOfBytes(using: .utf8))! == 0 {
            SVProgressHUD.showInfo(withStatus: LanguageHelper.getString(key: "login_infocantnil"))
            return
        }
        
//        if (phone?.lengthOfBytes(using: .utf8))! != 11 {
//            SVProgressHUD.showInfo(withStatus: LanguageHelper.getString(key: "net_rightphone"))
//            return
//        }
        
        advice(content: content!, phone: phone!)
    }
    
    // MARK: - NetWork Method
    func advice(content: String, phone: String) {
        let token = SingleTon.shared.userInfo?.token!
        let type = self.opinionType?.rawValue
        let params = ["token" : token!, "remark": content, "contact": phone,"type":type!]
        SVProgressHUD.show(with: .black)
        ZYNetWorkTool.requestData(.post, URLString: ZYConstAPI.kAPIAddAdvise, language: true, parameters: params, showIndicator: true, success: { (jsonObjc) in
            let result = Mapper<NodataResponse>().map(JSONObject: jsonObjc)
            if let code = result?.code {
                if code == 200 {
                    SVProgressHUD.showSuccess(withStatus: LanguageHelper.getString(key: "net_success"))
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: {
                        self.navigationController?.popViewController(animated: true)
                    })
                } else if code == -1 {
                    SVProgressHUD.showError(withStatus: LanguageHelper.getString(key: "net_tokenout"))
                    Tools.switchToLoginViewController()
                } else {
                    SVProgressHUD.showError(withStatus: result?.message!)
                }
            }
        }) { (error) in
            SVProgressHUD.showError(withStatus: LanguageHelper.getString(key: "net_networkerror"))
            
        }
        
    }
    
    // MARK: - Delegate Method

    
    func textFieldDidEndEditing(_ textField: UITextField) {
        checkInfo()
    }
    
    func checkInfo() {
        
        let content = adviceTextVeiew.noteTextView.textView.text
        let phone = phoneTextView.textField.text
        
        if (content?.lengthOfBytes(using: .utf8))! != 0 && (phone?.lengthOfBytes(using: .utf8))! != 0 {
           Tools.setButtonType(isBoarder: false, sender: commitBtn, fontSize: 14, bgcolor: R_ZYThemeColor)
            commitBtn.isUserInteractionEnabled = true
        } else {
            Tools.setButtonType(isBoarder: true, sender: commitBtn, fontSize: 14, bgcolor: R_ZYThemeColor)
            commitBtn.isUserInteractionEnabled = false
        }
        
    }
    
    // MARK: - Private Method
    func setViewStyle() {
        
        topView.setViewContent(title: LanguageHelper.getString(key: "person_opinion"))
        topView.setButtonCallBack { (sender) in
            self.navigationController?.popViewController(animated: true)
        }
        
        errorTypeTextView.addTextFieldAndRightBtn(viewType: .DoubleBtnType)
        errorTypeTextView.backgroundColor = UIColor.clear
        errorTypeTextView.titleLabel.text = LanguageHelper.getString(key: "person_opiniontype")
        errorTypeTextView.leftTitleBtn1.addTarget(self, action: #selector(OpitionViewController.appErrorBtnTouched(sender:)), for: .touchUpInside)
        errorTypeTextView.leftImageBtn1.addTarget(self, action: #selector(OpitionViewController.appErrorBtnTouched(sender:)), for: .touchUpInside)
        errorTypeTextView.leftTitleBtn2.addTarget(self, action: #selector(OpitionViewController.appAddviceBtnTouched(sender:)), for: .touchUpInside)
        errorTypeTextView.leftImageBtn2.addTarget(self, action: #selector(OpitionViewController.appAddviceBtnTouched(sender:)), for: .touchUpInside)

        appErrorBtnTouched(sender: errorTypeTextView.leftTitleBtn1)
        
        phoneTextView.addTextFieldAndRightBtn(viewType: .DefaultType)
        phoneTextView.textField.setKeyboardStyle(textType: .TextFieldIntegerNumber)
        phoneTextView.backgroundColor = UIColor.clear
        phoneTextView.titleLabel.text = LanguageHelper.getString(key: "person_contactmethod")
        phoneTextView.textField.textColor = UIColor.black
        phoneTextView.textField.placeholder = LanguageHelper.getString(key: "login_loginaccountplaceholder")
        
        adviceTextVeiew.setNoteViewContent(title: LanguageHelper.getString(key: "person_opinioncontent"), placeHolder: LanguageHelper.getString(key: "person_opinionplaceholder"))
        adviceTextVeiew.noteTextView.textView.textColor = R_ZYThemeColor
        
        Tools.setButtonType(isBoarder: true, sender: commitBtn, fontSize: 14, bgcolor: R_ZYThemeColor)
        commitBtn.setTitle(LanguageHelper.getString(key: "submit_feedback"), for: .normal)
        
        phoneTextView.textField.delegate = self
                
        adviceTextVeiew.noteTextView.setTextViewHandle { (text) in
            self.checkInfo()
        }
    }
    

}
