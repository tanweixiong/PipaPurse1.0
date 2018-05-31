//
//  HomeBackupDetailsVC.swift
//  PTNPurse
//
//  Created by tam on 2018/1/24.
//  Copyright © 2018年 Wilkinson. All rights reserved.
//

import UIKit
import SVProgressHUD
import ObjectMapper

enum HomeBackupDetailsStyle {
   case backupStyle
   case importStyle
}

class HomeBackupDetailsVC: MainViewController,HomeBackupDetailsViewDelegate {
    fileprivate lazy var viewModel : HomeBackupDetailsVM = HomeBackupDetailsVM()
    var style = HomeBackupDetailsStyle.backupStyle
    fileprivate var addressJson = String()
    fileprivate var fileName = String()
    fileprivate var memoryStr = ""
    var memoryArray = NSMutableArray()
    override func viewDidLoad() {
        super.viewDidLoad()
        let titles = style == .backupStyle ? LanguageHelper.getString(key: "homePage_Backup_Wallet_Navi") : LanguageHelper.getString(key: "homePage_Import_Wallet_Navi")
        setNormalNaviBar(title: titles)
        getMemoryWords()
    }
    
    func getMemoryWords(){
        let token = UserDefaults.standard.getUserInfo().token
        let parameters = ["token":token!]
        SVProgressHUD.show(withStatus:LanguageHelper.getString(key: "please_wait"))
        viewModel.loadMemosSuccessfullyReturnedData(requestType: .get, URLString: ZYConstAPI.kAPIMemoGetMemos, parameters:parameters, showIndicator: false) {
            SVProgressHUD.dismiss()
            if self.viewModel.memoModel.count != 0 {
                for index in 0...self.viewModel.memoModel.count - 1 {
                    let model = self.viewModel.memoModel[index]
                    self.memoryStr = self.memoryStr + model.memo! + " "
                    let memory = model.memo == nil ? "" : model.memo
                    self.memoryArray.add(memory!)
                }
                self.view.addSubview(self.titlesLabel)
                self.view.addSubview(self.channelView)
            }
        }
    }
    
    //备份钱包
    func setBackup(memorandum:String){
        if memorandum != "" {
            let userNo = (UserDefaults.standard.getUserInfo().id?.stringValue)!
            let memorandum =  memorandum
            let token = UserDefaults.standard.getUserInfo().token
            let parameters = ["userNo":userNo,"memorandum":memorandum,"token":token!]
            viewModel.loadBackupSuccessfullyReturnedData(requestType: .post, URLString: ZYConstAPI.kAPIExportAddress, parameters: parameters, showIndicator: true) {
                SVProgressHUD.showSuccess(withStatus: LanguageHelper.getString(key: "homePage_Backup_Successful"))
                Tools.storeJsonInDocuments(jsonStr: self.viewModel.mnemonicJson, fileName: self.fileName)
            }
        }else{
            SVProgressHUD.showInfo(withStatus: LanguageHelper.getString(key: "homePage_List_Details_Confirm_Backup_Prompt"))
        }
    }
    
    //导入钱包
    func setImportWallet(memorandum:String){
        let filename = SingleTon.shared.fileName!
        let filecontent = Tools.getJsonFileContentInDocuments(fileName: filename)
        let userNo = (UserDefaults.standard.getUserInfo().id)!
        let token = (UserDefaults.standard.getUserInfo().token)!
        let params = ["addressJson": filecontent, "memorandum":memorandum,"userNo":(userNo.stringValue),"token":token]
        SVProgressHUD.show(with: .black)
        ZYNetWorkTool.requestData(.post, URLString: ZYConstAPI.kAPIImportAddress, language: true, parameters: params, showIndicator: true, success: { (jsonObjc) in
            let result = Mapper<HomeImprotWalletBaseModel>().map(JSONObject: jsonObjc)
            if let code = result?.code {
                if code == 200 {
                    SVProgressHUD.showSuccess(withStatus: LanguageHelper.getString(key: "person_Import_finish"))
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: R_NotificationHomeReload), object: nil)
      
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2, execute: {
                        self.navigationController?.popToRootViewController(animated: true)
                    })
                } else {
                    SVProgressHUD.showInfo(withStatus: result?.message)
                }
            }

        }) { (error) in
            SVProgressHUD.dismiss()
        }
    }
    
    func getUserInfoByToken() {
        let token = UserDefaults.standard.value(forKey: "token") as! String
        let params = ["token" : token]
        ZYNetWorkTool.requestData(.post, URLString: ZYConstAPI.kAPIGetUserInfoByToken, language: true, parameters: params, showIndicator: true, success: { (jsonObjc) in
            SVProgressHUD.dismiss()
            let result = Mapper<LoginResponse>().map(JSONObject: jsonObjc)
            if let code = result?.code {
                if code == 200 {
                    SingleTon.shared.userInfo = result?.data
                    UserDefaults.standard.setValue(result?.data?.username, forKey: "phone")
                    let dict = jsonObjc as! NSDictionary
                    if (dict.object(forKey: "data") != nil){
                        let userInfo = UserInfo(dict: dict.object(forKey: "data") as! [String : AnyObject])
                        UserDefaults.standard.saveCustomObject(customObject: userInfo, key: R_UserInfo)
                    }
                    Tools.cacheLoginData(token: (result?.data?.token)!)
                }
            }
        }) { (error) in
            SVProgressHUD.dismiss()
        }
    }
    
    func setAlertTextField(memorandum:String){
        if memorandum != "" {
            let alertController = UIAlertController(title: LanguageHelper.getString(key: "prompt"),
                                                    message: LanguageHelper.getString(key: "homePage_Please_enter_your_file_name"), preferredStyle: .alert)
            alertController.addTextField {
                (textField: UITextField!) -> Void in
                textField.placeholder = LanguageHelper.getString(key: "homePage_Please_enter_your_file_name")
            }
            let cancelAction = UIAlertAction(title: LanguageHelper.getString(key: "cancel"), style: .cancel, handler: nil)
            let okAction = UIAlertAction(title: LanguageHelper.getString(key: "confirm"), style: .default, handler: {
                action in
                let textfield = alertController.textFields?.first
                let text = textfield?.text!
                let fileArr = Tools.getJsonFileArrayInDocuments()
                //文件名不能为空
                if text == "" {
                    SVProgressHUD.showInfo(withStatus: LanguageHelper.getString(key: "homePage_File_name_cannot_be_empty"))
                    return
                }
                //判断是否含有文件
                if fileArr.count != 0 {
                    for item in 0...fileArr.count - 1 {
                        let fileName = fileArr[item] as? NSString
                        let newFilename = fileName?.replacingOccurrences(of: ".json", with: "")
                        if text == newFilename {
                            SVProgressHUD.showInfo(withStatus: LanguageHelper.getString(key: "homePage_File_name_already_exists"))
                            return
                        }
                    }
                }
                self.fileName = (textfield?.text!)!
                self.setBackup(memorandum: memorandum)
            })
            alertController.addAction(cancelAction)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }else{
                SVProgressHUD.showInfo(withStatus: LanguageHelper.getString(key: "homePage_List_Details_Confirm_Backup_Prompt"))
        }
    }
    
    lazy var titlesLabel: UILabel = {
        let label = UILabel()
        label.text = LanguageHelper.getString(key: "homePage_Backup_Wallet_Prompt2")
        label.textColor = UIColor.R_UIColorFromRGB(color: 0x545B71)
        label.font = UIFont.systemFont(ofSize: 14)
        label.frame = CGRect(x: 15, y: MainViewControllerUX.naviNormalHeight + 15, width: SCREEN_WIDTH - 30, height: 20)
        self.view.addSubview(label)
        return label
    }()
    
    lazy var channelView: HomeBackupDetailsView = {
        let view = HomeBackupDetailsView.init(frame: CGRect(x: 0, y:titlesLabel.frame.maxY, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - titlesLabel.frame.maxY), dataArray: self.memoryArray)
        view.delegate = self
        let titles = style == .backupStyle ? LanguageHelper.getString(key: "homePage_Backup_Wallet_Confirm_Backup") : LanguageHelper.getString(key: "homePage_Backup_Wallet_Confirm_Import")
        view.determineBtn.setTitle(titles, for: .normal)
        return view
    }()
    
    func homeBackupDetailsChooseMemorandum(memorandum: String) {
        if style == .backupStyle {
            setAlertTextField(memorandum: memorandum)
        }else{
            setImportWallet(memorandum: memorandum)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
