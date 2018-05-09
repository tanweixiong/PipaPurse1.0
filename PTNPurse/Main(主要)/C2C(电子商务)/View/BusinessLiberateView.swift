//
//  BusinessLiberateView.swift
//  PTNPurse
//
//  Created by tam on 2018/3/12.
//  Copyright © 2018年 Wilkinson. All rights reserved.
//

import UIKit

class BusinessLiberateView: UIView {

    @IBOutlet weak var liberateViewY: NSLayoutConstraint!
    @IBOutlet weak var liberateBuyVw: UIView!
    @IBOutlet weak var liberateSellVw: UIView!
    @IBOutlet weak var liberateView: UIView!
    @IBOutlet weak var backgroundBtn: UIButton!
    @IBOutlet weak var liberateBuyBtn: UIButton!
    @IBOutlet weak var liberateSellBtn: UIButton!
    
    @IBOutlet weak var liberateSellLab: UILabel!
    @IBOutlet weak var liberateBuyLab: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        liberateBuyVw.layer.cornerRadius = liberateBuyVw.width/2
        liberateBuyVw.layer.masksToBounds = true
        liberateSellVw.layer.cornerRadius = liberateSellVw.width/2
        liberateSellVw.layer.masksToBounds = true
        
        liberateSellLab.text = LanguageHelper.getString(key: "C2C_home_transaction_purchase")
        liberateBuyLab.text = LanguageHelper.getString(key: "C2C_home_transaction_sale")

    }
    
 
    @IBAction func onClick(_ sender: Any) {
        if self.isHidden == false{
            UIView.animate(withDuration: 1, animations: {
                self.liberateViewY.constant = -self.liberateView.height
            }, completion: { (finish) in
                self.isHidden = true
            })
        }
    }
}
