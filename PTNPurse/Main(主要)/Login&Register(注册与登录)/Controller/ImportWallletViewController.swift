//
//  ImportWallletViewController.swift
//  PTNPurse
//
//  Created by zhengyi on 2018/1/19.
//  Copyright © 2018年 Wilkinson. All rights reserved.
//

import UIKit
import SVProgressHUD
import ObjectMapper

class ImportWallletViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    @IBOutlet weak var topView: CreatTopView!
    @IBOutlet weak var promptView: LoginTextFieldView!
    @IBOutlet weak var keyNotView: LoginNoteTextView!
    @IBOutlet weak var importBtn: UIButton!
    
    
    // MARK: - lift cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewStyle()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - EventResponse Method
    @IBAction func importBtnTouched(_ sender: UIButton) {
        view.endEditing(true)
        
        let filename = SingleTon.shared.fileName!
        let key = keyNotView.noteTextView.textView.text!
        let filecontent = Tools.getJsonFileContentInDocuments(fileName: filename)
        
        if keyNotView.noteTextView.textView.text! == "" {
            SVProgressHUD.showInfo(withStatus: LanguageHelper.getString(key: "login_infocantnil"))
            return
        }
        
        if (filecontent.lengthOfBytes(using: .utf8)) == 0 {
            SVProgressHUD.showInfo(withStatus:  LanguageHelper.getString(key: "login_infoclogin_selectfileerrorantnil"))
            return
        }
        
        importWalletAddress(prompt: key, adddress: filecontent)
    
    }
    
    // MARK: - NetWork Method
    func importWalletAddress(prompt: String, adddress: String) {
//        let promptArray = prompt.components(separatedBy: " ")
//        var promptstr = ""
//        for promt in promptArray {
//            promptstr = "，" + promt
//        }
        let userNo = (UserDefaults.standard.getUserInfo().id)!
        let params = ["addressJson": adddress , "memorandum":prompt,"userNo":(userNo.stringValue)]
        SVProgressHUD.show(with: .black)
        ZYNetWorkTool.requestData(.post, URLString: ZYConstAPI.kAPIImportAddress, language: true, parameters: params, showIndicator: true, success: { (jsonObjc) in
            SVProgressHUD.dismiss()
            let result = Mapper<LoginResponse>().map(JSONObject: jsonObjc)
            if let code = result?.code {
                if code == 200 {
                    let address = result?.data?.address == nil ? "" : result?.data?.address
                    let userInfo = UserDefaults.standard.getUserInfo()
                    userInfo.ptnaddress = address
                    UserDefaults.standard.saveCustomObject(customObject: userInfo, key: R_UserInfo)
                    
                    SingleTon.shared.userInfo = result?.data
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
    
    // MARK: - Delegate Method
    func textViewDidEndEditing(_ textView: UITextView) {
        changeBtnStyle()
    }
    
    func changeBtnStyle() {
        
        if  keyNotView.noteTextView.textView.text! != "" {
            Tools.setButtonType(isBoarder: false, sender: importBtn, fontSize: R_ZYBtnFontSize, bgcolor: R_ZYThemeColor)
            importBtn.isUserInteractionEnabled = true
        } else {
            Tools.setButtonType(isBoarder: true, sender: importBtn, fontSize: R_ZYBtnFontSize, bgcolor: R_ZYThemeColor)
            importBtn.isUserInteractionEnabled = false
        }
        
    }
    
    // MARK: - Private Method
    func setViewStyle() {
        
        topView.setViewContent(title: LanguageHelper.getString(key: "login_importaccount"))

        
        keyNotView.setNoteViewContent(title: LanguageHelper.getString(key: "login_prompt"), placeHolder: LanguageHelper.getString(key: "login_promptplaceholder"))
        
        importBtn.setTitle(LanguageHelper.getString(key: "login_importaccount"), for: .normal)
        
        Tools.setButtonType(isBoarder: true, sender: importBtn, fontSize: R_ZYBtnFontSize, bgcolor: R_ZYThemeColor)
     
        topView.setButtonCallBack { (sender) in
            self.navigationController?.popViewController(animated: true)
        }
        
        keyNotView.noteTextView.setTextViewHandle { (textViewString) in
            self.changeBtnStyle()
        }
    }
    

}
