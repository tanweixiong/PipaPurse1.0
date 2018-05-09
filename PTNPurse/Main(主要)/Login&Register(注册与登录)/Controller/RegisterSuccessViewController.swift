//
//  RegisterSuccessViewController.swift
//  PTNPurse
//
//  Created by zhengyi on 2018/1/18.
//  Copyright © 2018年 Wilkinson. All rights reserved.
//

import UIKit

enum RegisterSuccessViewControllerType {
    case register
    case modifypwd
}

class RegisterSuccessViewController: UIViewController {

    @IBOutlet weak var topView: CreatTopView!
    
    @IBOutlet weak var successImageView: UIImageView!
    @IBOutlet weak var descLabel: UILabel!
    
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var toLoginBtn: UIButton!
    
    var type: RegisterSuccessViewControllerType?
    
    // MARK: - life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewContentByType()
        setViewStyle()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - EventResponse Method
    @IBAction func closeBtnTouched(_ sender: UIButton) {
        toLoginViewController()
    }
    
    @IBAction func toLoginBtnTouched(_ sender: UIButton) {
        toLoginViewController()
    }
    
    func toLoginViewController() {
        let rootvc = navigationController?.viewControllers[0]
        if (rootvc?.isKind(of: LoginController.self))! {
            navigationController?.popToRootViewController(animated: true)
        } else {
            Tools.removeCacheLoginData()
            Tools.switchToLoginViewController()
        }
    }
    

    // MARK: - Private Method
    func setViewContentByType() {
        if type! == .register {
            self.setViewContent(title: LanguageHelper.getString(key: LanguageHelper.getString(key: "login_creatsuccess")), desc: LanguageHelper.getString(key: "login_successdesc"))
        } else if type! == .modifypwd {
            self.setViewContent(title: LanguageHelper.getString(key: LanguageHelper.getString(key: "login_loginforgetpwd")), desc: LanguageHelper.getString(key: "login_modifysuccessdesc"))
        }
    }
    
    func setViewContent(title: String, desc: String) {
        topView.titleLabel.text = title
        descLabel.text = desc
    }
    
    func setViewStyle() {
        
        topView.backBtn.isHidden = true
        
        descLabel.textColor = R_ZYGrayColor
        
        Tools.setButtonType(isBoarder: true, sender: closeBtn, fontSize: 14, bgcolor: R_ZYThemeColor)
        Tools.setButtonType(isBoarder: false, sender: toLoginBtn, fontSize: 14, bgcolor: R_ZYThemeColor)
       
        toLoginBtn.setTitle(LanguageHelper.getString(key: "login_login"), for: .normal)
        closeBtn.setTitle(LanguageHelper.getString(key: "login_close"), for: .normal)
    }
    
}
