//
//  HomeCertificationView.swift
//  PTNPurse
//
//  Created by tam on 2018/3/7.
//  Copyright © 2018年 Wilkinson. All rights reserved.
//

import UIKit

class HomeCertificationView: UIView {
    @IBOutlet weak var uploadBtn: UIButton!
    @IBOutlet weak var companyNameTF: UITextField!
    @IBOutlet weak var fileNameTF: UITextField!
    @IBOutlet weak var compenyTitleLabel: UILabel!
    @IBOutlet weak var uploadFileTitleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        uploadBtn.layer.borderColor = UIColor.R_UIRGBColor(red: 223, green: 223, blue: 223, alpha: 1).cgColor
        uploadBtn.layer.borderWidth = 1
        uploadBtn.setTitle(LanguageHelper.getString(key: "perseon_Upload_File"), for: .normal)
        compenyTitleLabel.text = LanguageHelper.getString(key: "perseon_Company_Name")
        companyNameTF.placeholder = LanguageHelper.getString(key: "perseon_Enter_Company_Name")
        uploadFileTitleLabel.text = LanguageHelper.getString(key: "perseon_File_Upload")
        fileNameTF.placeholder = LanguageHelper.getString(key: "perseon_Upload_File")
   }
}
