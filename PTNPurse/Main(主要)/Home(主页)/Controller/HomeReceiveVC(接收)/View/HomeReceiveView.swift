//
//  HomeReceiveView.swift
//  PTNPurse
//
//  Created by tam on 2018/1/16.
//  Copyright © 2018年 Wilkinson. All rights reserved.
//

import UIKit

class HomeReceiveView: UIView {

    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var scanCodeLabel: UILabel!
    @IBOutlet weak var codeImageView: UIImageView!
    @IBOutlet weak var copyAddressBtn: UIButton!
    @IBOutlet weak var headImageView: UIImageView!
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var promptTextField: UITextView!
    @IBOutlet weak var promptLabel: UILabel!
    @IBOutlet weak var backgroundBtn: UIButton!
    @IBOutlet weak var codeViewBtn: UIButton!
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override func awakeFromNib() {
        super.awakeFromNib()

   copyAddressBtn.setTitle(LanguageHelper.getString(key: "homePage_Copy"), for: .normal)
          scanCodeLabel.text = LanguageHelper.getString(key: "homePage_Scan_Addres")
        promptLabel.text = LanguageHelper.getString(key: "homePage_Scan_Prompt")
    }
}
