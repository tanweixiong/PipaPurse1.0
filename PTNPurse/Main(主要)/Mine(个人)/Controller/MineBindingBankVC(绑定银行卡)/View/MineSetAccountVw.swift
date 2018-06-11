//
//  MineSetAccountVw.swift
//  BCPPurse
//
//  Created by SKINK on 2018/4/16.
//  Copyright © 2018年 Wilkinson. All rights reserved.
//

import UIKit

class MineSetAccountVw: UIView {
    @IBOutlet weak var titleLab: UILabel!
    @IBOutlet weak var paymentMethodTF: UITextField!
    @IBOutlet weak var uploadBtn: UIButton!
    @IBOutlet weak var codeImageVw: UIImageView!
    @IBOutlet weak var codeVw: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        uploadBtn.setTitle(LanguageHelper.getString(key: "C2C_Upload_Upload_Payment_QR_Code"), for: .normal)
    }
    
    @IBAction func cleanOnClick(_ sender: UIButton) {
        self.endEditing(true)
    }
    
}


