//
//  BusinessReleaseMethodCell.swift
//  PTNPurse
//
//  Created by tam on 2018/5/14.
//  Copyright © 2018年 Wilkinson. All rights reserved.
//

import UIKit

class BusinessReleaseMethodCell: UITableViewCell {

    @IBOutlet weak var firstVw: UIView!
    @IBOutlet weak var secondVw: UIView!
    @IBOutlet weak var selectCoinBtn: UIButton!
    @IBOutlet weak var selectMethodBtn: UIButton!
    @IBOutlet weak var cointf: UITextField!
    @IBOutlet weak var paymentMethodtf: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        firstVw.layer.borderWidth = 1
        firstVw.layer.borderColor = UIColor.R_UIRGBColor(red: 206, green: 215, blue: 231, alpha: 1).cgColor
        
        secondVw.layer.borderWidth = 1
        secondVw.layer.borderColor = UIColor.R_UIRGBColor(red: 206, green: 215, blue: 231, alpha: 1).cgColor
        
        selectCoinBtn.tag = 1
        selectMethodBtn.tag = 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
