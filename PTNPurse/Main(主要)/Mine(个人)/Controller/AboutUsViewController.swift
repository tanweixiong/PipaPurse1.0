//
//  AboutUsViewController.swift
//  PTNPurse
//
//  Created by zhengyi on 2018/1/21.
//  Copyright © 2018年 Wilkinson. All rights reserved.
//

import UIKit
import SVProgressHUD
import ObjectMapper

class AboutUsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var topView: CreatTopView!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    let titleArray = ["person_currentversion", "person_latestversion","Mine_FeedbackAndOpinions","Mine_Representation_Record"]
    let imageArray = ["ic_aboutus_details","ic_aboutus_details","ic_aboutus_details","ic_aboutus_details"]
    
    var newVersion: Version?
    
    // MARK: - life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewStyle()
        getVersion()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
        cell.viewType = MineViewTableViewCellType.label
        cell.leftImageView.image = UIImage.init(named: imageArray[indexPath.row])
        cell.leftLabel.text = LanguageHelper.getString(key: titleArray[indexPath.row])
        let currentVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
        //todo: set right label content
        if indexPath.row == 0 {
            cell.rightLabel.text = currentVersion
        } else  if indexPath.row == 1 {
            if newVersion != nil {
                if (newVersion?.version!)! > currentVersion {
                    cell.rightLabel.text = newVersion?.version
                } else {
                    cell.rightLabel.text = LanguageHelper.getString(key: "person_nonewversion")
                }
            } else {
                cell.rightLabel.text = LanguageHelper.getString(key: "person_nonewversion")
            }
        }else{
            cell.rightLabel.text = ""
        }
        return cell
    }
    
   
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
        case 1:
            self.checkVersion()
        case 2:
            let opitionViewController = OpitionViewController()
            self.navigationController?.pushViewController(opitionViewController, animated: true)
        case 3:
            let businessSubmissionMessageVC = BusinessSubmissionMessageVC()
            self.navigationController?.pushViewController(businessSubmissionMessageVC, animated: true)
        default:
            break
        }
    }
    
    // MARK: - Private Method
    func setViewStyle() {
        
        topView.setViewContent(title: LanguageHelper.getString(key: "person_about"))
        topView.setButtonCallBack { (sender) in
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    
    func checkVersion() {
        let currentVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
        if self.newVersion != nil {
            if (self.newVersion?.version)! > currentVersion {
                if let urlstr = self.newVersion?.versionUrl  {
                    let url = URL.init(string: urlstr)
                    if url != nil {
                        UIApplication.shared.openURL(url!)
                    } else {
                        SVProgressHUD.showInfo(withStatus: LanguageHelper.getString(key: "net_wrongurl"))
                    }
                }
            } else if (self.newVersion?.version)! == currentVersion {
                SVProgressHUD.showInfo(withStatus:LanguageHelper.getString(key: "person_nonewversion"))
            }
        } else {
            SVProgressHUD.showSuccess(withStatus: LanguageHelper.getString(key: "lastest_version"))
        }
        
    }

    
    // MARK: - NetWork Method

    func getVersion() {
        
        let params = [ "type" : "2"]
        ZYNetWorkTool.requestData(.get, URLString: ZYConstAPI.kAPIGetVersion, language: false, parameters: params, showIndicator: true, success: { (jsonObjc) in
            let result = Mapper<VersionRespondse>().map(JSONObject: jsonObjc)
            if let code = result?.code {
                if code == 200 {
                    self.newVersion = result?.data
                    self.tableView.reloadData()
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
    
    
  

}
