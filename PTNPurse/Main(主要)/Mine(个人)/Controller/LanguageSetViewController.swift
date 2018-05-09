//
//  LanguageSetViewController.swift
//  PTNPurse
//
//  Created by zhengyi on 2018/1/21.
//  Copyright © 2018年 Wilkinson. All rights reserved.
//

import UIKit

enum LanguageSetViewControllerType {
    case language
    case currency
}

enum LanguageSetViewControllerStyle {
    case normal
    case special
}
class LanguageSetViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var topView: CreatTopView!
    @IBOutlet weak var tableView: UITableView!

    
    let languagetitleArray = ["简体中文", "English"]
    let languageimageArray = ["person_cn", "person_en"]
    
    let currencytitleArray = ["CNY", "USD"]
    let currencyimageArray = ["person_currency", "person_currency"]
    
    var type: LanguageSetViewControllerType?
    var style = LanguageSetViewControllerStyle.normal
    
    // MARK: - life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewStyle()
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
        if type! == .language {
            return languagetitleArray.count
        } else {
            return currencytitleArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("MineViewTableViewCell", owner: nil, options: nil)?[0] as! MineViewTableViewCell
        if type! == .language {
            cell.leftImageView.image = UIImage.init(named: languageimageArray[indexPath.row])
            cell.leftLabel.text = LanguageHelper.getString(key: languagetitleArray[indexPath.row])
            
            let language = UserDefaults.standard.object(forKey: UserLanguage) as! String
            if language == "zh-Hans" {
                if indexPath.row == 0 {
                    cell.viewType = .checkmark
                } else {
                    cell.viewType = .noright
                }
            } else if language == "en" {
                if indexPath.row == 1 {
                    cell.viewType = .checkmark
                } else {
                    cell.viewType = .noright
                }
            }
            
        } else {
            cell.leftImageView.image = UIImage.init(named: currencyimageArray[indexPath.row])
            cell.leftLabel.text = LanguageHelper.getString(key: currencytitleArray[indexPath.row])
            
            let currency = UserDefaults.standard.object(forKey: UserCurrency) as! String
            if currency == "CNY" {
                if indexPath.row == 0 {
                    cell.viewType = .checkmark
                } else {
                    cell.viewType = .noright
                }
            } else if currency == "USD" {
                if indexPath.row == 1 {
                    cell.viewType = .checkmark
                } else {
                    cell.viewType = .noright
                }
            }
        }
        
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
   
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = self.tableView(tableView, cellForRowAt: indexPath) as! MineViewTableViewCell
        cell.viewType = .checkmark
        
        var langeuage = ""
        var currency = ""
        if type! == .language {
            if indexPath.row == 0 {
                langeuage = "zh-Hans"
                LanguageHelper.shareInstance.setLanguage(langeuage: langeuage)
            }else if indexPath.row == 1 {
                langeuage = "en"
                LanguageHelper.shareInstance.setLanguage(langeuage: langeuage)
            }
            UserDefaults.standard.set(langeuage, forKey: UserLanguage)
            LanguageHelper.shareInstance.setLanguage(langeuage: langeuage)
            self.tableView.reloadData()
            self.setViewStyle()
        } else if type! == .currency {
            currency = currencytitleArray[indexPath.row]
            UserDefaults.standard.set(currency, forKey: UserCurrency)
            self.tableView.reloadData()
        }
        //切换语言
        let titles = Tools.getLocalLanguage() != "0" ? "Whether to switch languages？" : "是否切换语言？";
        let confirm = Tools.getLocalLanguage() != "0" ? "Confirm" : "确定";
        let cancle = Tools.getLocalLanguage() != "0" ? "Cancle" : "取消";
        let myTitle = Tools.getLocalLanguage() != "0" ? "Prompt" : "提示";
        let alert = UIAlertController.init(title: myTitle, message: titles, preferredStyle: .alert)
        let commitAction = UIAlertAction.init(title:confirm, style: .destructive) { (action) in
            if self.style == .special {
                let loginNav = FMNavigationController.init(rootViewController: LoginController())
                UIApplication.shared.keyWindow?.rootViewController = loginNav
            }else{
                let tab = MainTabBarController()
                UIApplication.shared.keyWindow?.rootViewController = tab
            }
        }
        let cancelAction = UIAlertAction.init(title: cancle, style: .cancel) { (action) in }
        alert.addAction(cancelAction)
        alert.addAction(commitAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = self.tableView(tableView, cellForRowAt: indexPath) as! MineViewTableViewCell
        cell.viewType = .noright

    }
    
    // MARK: - Private Method
    func setViewStyle() {
        
        if type! == .language {
            topView.setViewContent(title: LanguageHelper.getString(key: "person_multilanguage"))
           
        } else {
        
            topView.setViewContent(title: LanguageHelper.getString(key: "person_monetaryunit"))
        }
        
        topView.setButtonCallBack { (sender) in
            self.navigationController?.popViewController(animated: true)
        }
        
        
        
    }
    
    

}
