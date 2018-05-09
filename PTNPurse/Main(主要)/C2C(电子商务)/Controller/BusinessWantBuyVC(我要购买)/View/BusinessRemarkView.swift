//
//  BusinessRemarkView.swift
//  PTNPurse
//
//  Created by tam on 2018/3/12.
//  Copyright © 2018年 Wilkinson. All rights reserved.
//

import UIKit

class BusinessRemarkView: UIView {
    @IBOutlet weak var backgroundVw: UIView!
    @IBOutlet weak var remarkTV: UITextView!
    @IBOutlet weak var remarkLab: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        Tools.setViewShadow(backgroundVw)
        remarkLab.text = LanguageHelper.getString(key: "C2C_home_Remark")
   }
    
    var model = BusinessWantBuyData(){
        didSet{
            remarkTV.text = model.remark
        }
    }

}
