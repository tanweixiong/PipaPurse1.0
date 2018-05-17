//
//  MineMiningVw.swift
//  PTNPurse
//
//  Created by tam on 2018/5/15.
//  Copyright © 2018年 Wilkinson. All rights reserved.
//

import UIKit

class MineMiningVw: UIView {
    @IBOutlet weak var personImgeVw: YLImageView!
    @IBOutlet weak var cumulativeIncomeLab: UILabel!{
        didSet{
            cumulativeIncomeLab.text = LanguageHelper.getString(key: "Mine_Mining_Cumulative") + cumulativeIncomeLab.text!
        }
    }
    @IBOutlet weak var incomeBtn: UIButton!
    @IBOutlet weak var rankingBtn: UIButton!
    @IBOutlet weak var miningBag: UIImageView!
    @IBOutlet weak var ruleDescriptionBtn: UIButton!
    @IBOutlet weak var widthRatio: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //gif
        let path = Bundle.main.url(forResource: "ic_mining_person", withExtension: "gif")
        let data = NSData(contentsOf: path!)
        personImgeVw.image = YLGIFImage(data: data! as Data)
        
        widthRatio.constant = -XMAKE(20)
        
        incomeBtn.setTitle(LanguageHelper.getString(key: "Mine_Mining_My_Income"), for: .normal)
        rankingBtn.setTitle(LanguageHelper.getString(key: "Mine_Mining_Ranking"), for: .normal)
    }

}
