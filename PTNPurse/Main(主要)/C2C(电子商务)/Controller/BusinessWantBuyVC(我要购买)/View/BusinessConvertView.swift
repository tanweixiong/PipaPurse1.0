//
//  BusinessConvertVC.swift
//  PTNPurse
//
//  Created by tam on 2018/3/12.
//  Copyright © 2018年 Wilkinson. All rights reserved.
//

import UIKit

class BusinessConvertView: UIView {

    @IBOutlet weak var coinNameLab: UILabel!
    @IBOutlet weak var disNameLab: UILabel!
    @IBOutlet weak var backgroundVw: UIView!
    @IBOutlet weak var coinNumTF: UITextField!
    @IBOutlet weak var disPriceTF: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        Tools.setViewShadow(backgroundVw)
        coinNumTF.textColor = UIColor.R_UIColorFromRGB(color: 0x4D4F51)
   }
    

}
