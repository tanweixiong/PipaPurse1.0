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
        "person_modifytradepwd"
        ,"binding_Alipay_account_settings"
        ,"binding_WeChat_account_settings"
        ,"binding_Bank_card_binding"]
    let imageArray = [
        "person_friend"
        ,"ic_binding_alipay"
        ,"ic_binding_weChat"
        ,"ic_binding_bankCard"]
    
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
        let cell = Bundle.main.loadNibNamed("MineViewTableViewCell", owner: nil, options: nil)?[0] as! MineViewTableViewCell
        cell.viewType = .arrow
        cell.leftImageView.image = UIImage.init(named: imageArray[indexPath.row])
        cell.rightImageView.image = UIImage.init(named: "person_rightarrow")
        cell.leftLabel.text = LanguageHelper.getString(key: titleArray[indexPath.row])
        if indexPath.row == 0 {
            if let flag = SingleTon.shared.pwdstate {
                if flag == 1 {
                    cell.leftLabel.text = LanguageHelper.getString(key: "person_modifytradepwd")
                } else if flag == 0 {
                    cell.leftLabel.text = LanguageHelper.getString(key: "person_settradepwd")
                }
            } else {
                cell.leftLabel.text = LanguageHelper.getString(key: "person_settradepwd")
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
   
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
        case 0:
            let modifyTradePwdVC = ModifyTradePwdViewController()
            if let flag = SingleTon.shared.pwdstate {
                if flag == 1 {
                    modifyTradePwdVC.status = .modify
                } else if flag == 0 {
                    modifyTradePwdVC.status = .normal
                }
            } else {
                modifyTradePwdVC.status = .normal
            }
            modifyTradePwdVC.type = .tradepwd
            self.navigationController?.pushViewController(modifyTradePwdVC, animated: true)
        case 1:
            let mineSetAccountVC = MineSetAccountVC()
            mineSetAccountVC.style = .alipayStyle
            self.navigationController?.pushViewController(mineSetAccountVC, animated: true)
        case 2:
            let mineSetAccountVC = MineSetAccountVC()
            mineSetAccountVC.style = .weChatStyle
            self.navigationController?.pushViewController(mineSetAccountVC, animated: true)
        case 3:
            let mineBankCardBindingVC = MineBankCardBindingVC()
            self.navigationController?.pushViewController(mineBankCardBindingVC, animated: true)
        default:
            break
        }
        
    }
    
    // MARK: - Private Method
    func setViewStyle() {
        topView.setViewContent(title: LanguageHelper.getString(key: "perseon_safety"))
        topView.setButtonCallBack { (sender) in
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    
    func getUserTradeState() {
        let token = UserDefaults.standard.value(forKey: "token")
        let userno = SingleTon.shared.userInfo?.id
        let params = ["token" : token,"userNo":userno!]
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
    
    /*
    func setTradePwdState() {
        
        if let state = SingleTon.shared.pwdstate?.flag  {
            let cell = tableView.cellForRow(at: IndexPath.init(row: 0, section: 0))
            if state == 0 {
                cell?.detailTextLabel?.attributedText = NSAttributedString.init(string: "未设置!", attributes: [NSForegroundColorAttributeName : R_UIThemeColor])
            } else if state == 1 {
                cell?.detailTextLabel?.attributedText = NSAttributedString.init(string: "已设置!", attributes: [NSForegroundColorAttributeName : R_UIThemeColor])
            }
        }
        
    }*/


}
