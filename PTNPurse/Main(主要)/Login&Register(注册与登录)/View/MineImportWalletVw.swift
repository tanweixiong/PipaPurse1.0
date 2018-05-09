//
//  MineImportWalletVw.swift
//  BCPPurse
//
//  Created by tam on 2018/4/9.
//  Copyright © 2018年 Wilkinson. All rights reserved.
//

import UIKit

class MineImportWalletVw: UIView {
    @IBOutlet weak var backGroundBtn: UIButton!
    @IBOutlet weak var forgetBtn: UIButton!
    @IBOutlet weak var importBtn: UIButton!
    @IBOutlet weak var accountTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var topVw: UIView!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var titleLab: UILabel!
    
    @IBOutlet weak var titleLab1: UILabel!
    @IBOutlet weak var titleLab2: UILabel!
    @IBOutlet weak var determineBtn: UIButton!
    
    
    @IBAction func onClick(_ sender: Any) {
         endEditing(true)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        accountTF.placeholder = LanguageHelper.getString(key: "login_loginaccountplaceholder")
        passwordTF.placeholder = LanguageHelper.getString(key: "person_pwdTextView_Please_enter_your_password")
        titleLab.text = LanguageHelper.getString(key: "add_wallet")
        
        titleLab1.text = LanguageHelper.getString(key: "person_Wallet_account")
        titleLab2.text = LanguageHelper.getString(key: "person_Wallet_password")
        determineBtn.setTitle(LanguageHelper.getString(key: "person_Determine"), for: .normal)
        forgetBtn.setTitle(LanguageHelper.getString(key: "login_loginforgetpwd") + "?", for: .normal)
    }
    
}
