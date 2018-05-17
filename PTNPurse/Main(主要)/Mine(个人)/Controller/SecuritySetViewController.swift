//
//  SecuritySetViewController.swift
//  PTNPurse
//
//  Created by zhengyi on 2018/1/21.
//  Copyright © 2018年 Wilkinson. All rights reserved.
//

import UIKit
import SVProgressHUD
import ObjectMapper

class SecuritySetViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var topView: CreatTopView!
    @IBOutlet weak var talbeView: UITableView!
    let titleArray = [
        "modify_login_passsword"
        ,"person_modifytradepwd"
        ,"Mine_PaymentMethod"
        ,"Mine_LanguageSettings"
        ,"person_quitlogin"
        ]
    
    // MARK: - life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewStyle()
        getUserTradeState()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - NetWork Method
    func getFriends() {
        
    }
    
    // MARK: - Delegate Method
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("SecuritySetViewCell", owner: nil, options: nil)?[0] as! SecuritySetViewCell
        cell.selectionStyle = .none
        cell.headingContentLab.text = LanguageHelper.getString(key: titleArray[indexPath.row])
        if indexPath.row == 1 {
            if let flag = SingleTon.shared.pwdstate {
                if flag == 1 {
                    cell.headingContentLab.text = LanguageHelper.getString(key: "person_modifytradepwd")
                } else if flag == 0 {
                    cell.headingContentLab.text = LanguageHelper.getString(key: "person_settradepwd")
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
        case 0:
            let vc = RegisterViewController()
            vc.type = .forgetpwd
            self.navigationController?.pushViewController(vc, animated: true)
        case 1:
            let vc = RegisterViewController()
            vc.type = .setPaymentPsd
            self.navigationController?.pushViewController(vc, animated: true)
        case 2:
            let mineSetPaymentVC = MineSetPaymentVC()
            self.navigationController?.pushViewController(mineSetPaymentVC, animated: true)
        case 3:
            let languageSetViewController = LanguageSetViewController()
            self.navigationController?.pushViewController(languageSetViewController, animated: true)
        case 4:
            logoutBtnTouched()
        default:
            break
        }
    }
    
    func setViewStyle() {
        topView.setViewContent(title: LanguageHelper.getString(key: "perseon_safety"))
        topView.setButtonCallBack { (sender) in
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func getUserTradeState() {
        let token = UserDefaults.standard.value(forKey: "token")
        let userno = (UserDefaults.standard.getUserInfo().id?.stringValue)!
        let params = ["token" : token,"userNo":userno]
        ZYNetWorkTool.requestData(.post, URLString: ZYConstAPI.kAPIHasSetTradePwd, language: true, parameters: params, showIndicator: true, success: { (jsonObjc) in
            let result = Mapper<HadSetTradePwdResponse>().map(JSONObject: jsonObjc)
            if let code = result?.code {
                if code == 200 {
                    
                    SingleTon.shared.pwdstate = result?.data
                   self.talbeView.reloadData()
                    
                }  else if code == -1 {
                    SVProgressHUD.showError(withStatus: "登录已过期，请重新登录")
                    Tools.switchToLoginViewController()
                } else {
                    SVProgressHUD.showError(withStatus: result?.message!)
                }
            }
        }) { (error) in
            SVProgressHUD.showError(withStatus: "无法连接到服务器")
            
        }
    }

    func logoutBtnTouched() {
        let alert = UIAlertController.init(title: LanguageHelper.getString(key: "person_alert"), message: LanguageHelper.getString(key: "person_alertmessage"), preferredStyle: .alert)
        let commitAction = UIAlertAction.init(title: LanguageHelper.getString(key: "person_quit"), style: .destructive) { (action) in
            self.logout()
        }
        let cancelAction = UIAlertAction.init(title: LanguageHelper.getString(key: "login_cancle"), style: .cancel) { (action) in
        }
        alert.addAction(cancelAction)
        alert.addAction(commitAction)
        self.present(alert, animated: true, completion: nil)
    }

    func logout() {
        let token = (UserDefaults.standard.getUserInfo().token)!
        let params = ["token" : token]
        ZYNetWorkTool.requestData(.post, URLString: ZYConstAPI.kAPIQuitLogin, language: true, parameters: params, showIndicator: true, success: { (jsonObjc) in
            let result = Mapper<NodataResponse>().map(JSONObject: jsonObjc)
            if let code = result?.code {
                if code == 200 {
                    Tools.removeCacheLoginData()
                    Tools.switchToLoginViewController()
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

}
