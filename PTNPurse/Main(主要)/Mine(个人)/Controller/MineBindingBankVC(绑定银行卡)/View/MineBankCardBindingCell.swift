//
//  MineBankCardBindingCell.swift
//  BCPPurse
//
//  Created by SKINK on 2018/4/16.
//  Copyright © 2018年 Wilkinson. All rights reserved.
//

import UIKit

class MineBankCardBindingCell: UITableViewCell {
    @IBOutlet weak var addDataLab: UILabel!
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var bankCardNameLab: UILabel!
    @IBOutlet weak var bankCardNumLab: UILabel!
    @IBOutlet weak var backGroundVw: UIView!
    
    var model = MineBindingBankModel(){
        didSet{
            bankCardNameLab.text = model?.bank == nil ? "" : model?.bank
            bankCardNumLab.text = model?.code == nil ? "" : model?.code
            addDataLab.text = model?.date == nil ? "" : model?.date
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        addDataLab.text = LanguageHelper.getString(key: "binding_Date_added") + " " + "2016/07／16"
        backGroundVw.layer.borderWidth = 1
        backGroundVw.layer.borderColor = UIColor.R_UIColorFromRGB(color: 0xE8E8E8).cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
