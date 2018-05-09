//
//  LoginVw.swift
//  BCPPurse
//
//  Created by tam on 2018/4/9.
//  Copyright © 2018年 Wilkinson. All rights reserved.
//

import UIKit

class LoginVw: UIView {
    @IBOutlet weak var importBtn: UIButton!
    @IBOutlet weak var createBtn: UIButton!
    @IBOutlet weak var welcomeLab: UILabel!
    
    @IBOutlet weak var languageLab: UILabel!
    @IBOutlet weak var chooseLanguageBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        createBtn.layer.borderWidth = 1
        createBtn.layer.borderColor = UIColor.R_UIRGBColor(red: 188, green: 191, blue: 203, alpha: 1).cgColor
        welcomeLab.text = "Welcome to Photon"
        importBtn.setTitle(LanguageHelper.getString(key: "login_importaccount"), for: .normal)
        createBtn.setTitle(LanguageHelper.getString(key: "login_creataccount"), for: .normal)
        
        languageLab.text = LanguageHelper.getString(key: "binding_Lgoin_Language")
    }

}
