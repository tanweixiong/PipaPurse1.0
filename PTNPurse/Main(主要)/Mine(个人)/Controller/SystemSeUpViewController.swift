//
//  SystemSeUpViewController.swift
//  PTNPurse
//
//  Created by zhengyi on 2018/1/21.
//  Copyright © 2018年 Wilkinson. All rights reserved.
//

import UIKit
import SVProgressHUD
import ObjectMapper

class SystemSeUpViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var topView: CreatTopView!
    @IBOutlet weak var tableView: UITableView!
    
    let titleArray = ["person_multilanguage","person_quitlogin"]
    let imageArray = ["person_language","person_logout"]
    
    // MARK: - life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setViewStyle()
        tableView.reloadData()
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
        cell.leftLabel.text = LanguageHelper.getString(key: titleArray[indexPath.row])
        cell.rightImageView.image = UIImage.init(named: "person_rightarrow")
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
  
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
        case 0:
            let languagvc = LanguageSetViewController()
            languagvc.type = .language
            self.navigationController?.pushViewController(languagvc, animated: true)
        case 1:
            self.logoutBtnTouched()
        default:
            break
        }
        
        
    }
    
    // MARK: - Private Method
    func setViewStyle() {
        
        topView.setViewContent(title: LanguageHelper.getString(key: "person_setup"))
        topView.setButtonCallBack { (sender) in
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    
    // MARK: - EventResponse Method
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
    
    // MARK: - NetWork Method
    func logout() {
        
        let token = SingleTon.shared.userInfo?.token!
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
